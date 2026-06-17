import { Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { Cart, CartStatuses } from '../models';
import { PutCartPayload } from 'src/order/type';
import Database from 'src/db/database';



@Injectable()
export class CartService {
  constructor(private readonly db: Database) { }

  async findByUserId(userId: string): Promise<Cart | null> {
    const row = await this.db.query(
      `SELECT
        carts.id,
        carts.user_id,
        EXTRACT(EPOCH FROM carts.created_at) * 1000 AS created_at,
        EXTRACT(EPOCH FROM carts.updated_at) * 1000 AS updated_at,
        carts.status,
        COALESCE(
          json_agg(
            json_build_object(
              'product_id', cart_items.product_id,
              'count', cart_items.count
            )
          ) FILTER (WHERE cart_items.product_id IS NOT NULL),
          '[]'
        ) AS items
      FROM carts
      LEFT JOIN cart_items ON carts.id = cart_items.cart_id
      WHERE carts.user_id = $1
        AND carts.status = 'OPEN'
      GROUP BY carts.id
      LIMIT 1`,
      [userId],
    )
      .then((res) => res.rows[0] ?? null)
      .catch((err) => {
        console.error('Error fetching cart:', err);
        return null;
      });

    if (!row) return null;

    return {
      ...row,
      created_at: Number(row.created_at),
      updated_at: Number(row.updated_at),
      items: (row.items as Array<{ product_id: string; count: number }>).map(
        ({ product_id, count }) => ({
          product: { id: product_id, title: '', description: '', price: 0 },
          count,
        }),
      ),
    };
  }

  async createByUserId(user_id: string): Promise<Cart> {
    const id = randomUUID();

    const row = await this.db
      .query(
        `INSERT INTO carts (id, user_id, created_at, updated_at, status)
         VALUES ($1, $2, NOW(), NOW(), 'OPEN')
         RETURNING id, user_id,
           EXTRACT(EPOCH FROM created_at) * 1000 AS created_at,
           EXTRACT(EPOCH FROM updated_at) * 1000 AS updated_at,
           status`,
        [id, user_id],
      )
      .then((res) => res.rows[0]);

    return {
      ...row,
      created_at: Number(row.created_at),
      updated_at: Number(row.updated_at),
      status: CartStatuses.OPEN,
      items: [],
    };
  }

  async findOrCreateByUserId(userId: string): Promise<Cart> {
    const userCart = await this.findByUserId(userId);

    if (userCart) {
      return userCart;
    }

    return this.createByUserId(userId);
  }

  async updateByUserId(userId: string, payload: PutCartPayload): Promise<Cart | null> {
    const userCart = await this.findOrCreateByUserId(userId);

    if (payload.count === 0) {
      await this.db.query(
        `DELETE FROM cart_items WHERE cart_id = $1 AND product_id = $2`,
        [userCart.id, payload.product.id],
      );
    } else {
      await this.db.query(
        `INSERT INTO cart_items (cart_id, product_id, count)
         VALUES ($1, $2, $3)
         ON CONFLICT (cart_id, product_id)
         DO UPDATE SET count = EXCLUDED.count`,
        [userCart.id, payload.product.id, payload.count],
      );
    }

    await this.db.query(
      `UPDATE carts SET updated_at = NOW() WHERE id = $1`,
      [userCart.id],
    );

    return this.findByUserId(userId);
  }

  async removeByUserId(userId: string): Promise<void> {
    await this.db.query(
      `UPDATE carts SET status = 'ORDERED', updated_at = NOW()
       WHERE user_id = $1 AND status = 'OPEN'`,
      [userId],
    );
  }
}

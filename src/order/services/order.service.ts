import { Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { Order } from '../models';
import { CreateOrderPayload, OrderStatus } from '../type';
import Database from 'src/db/database';

const ORDER_WITH_ITEMS_QUERY = `SELECT
  orders.*,
  COALESCE(
    json_agg(
      json_build_object(
        'productId', cart_items.product_id,
        'count', cart_items.count
      )
    ) FILTER (WHERE cart_items.product_id IS NOT NULL),
    '[]'
  ) AS items
FROM orders
LEFT JOIN cart_items ON orders.cart_id = cart_items.cart_id`;

function mapOrderFromDb(row: any): Order {
  return {
    id: row.id,
    userId: row.user_id,
    cartId: row.cart_id,
    items: Array.isArray(row.items)
      ? (row.items as Array<{ productId: string; count: number }>).map(({ productId, count }) => ({
        productId,
        count: Number(count),
      }))
      : [],
    payment: row.payment,
    delivery: row.delivery,
    comments: row.comments ?? null,
    status: row.status,
    total: Number(row.total),
  };
}

@Injectable()
export class OrderService {
  constructor(private readonly db: Database) { }

  async getAll(userId: string): Promise<Order[]> {
    try {
      const res = await this.db.query(
        `${ORDER_WITH_ITEMS_QUERY}
         WHERE orders.user_id = $1
         GROUP BY orders.id`,
        [userId],
      );
      return (res.rows || []).map(mapOrderFromDb);
    } catch (err) {
      console.error('Error fetching orders:', err);
      return [];
    }
  }

  async findById(orderId: string, userId?: string): Promise<Order | null> {
    try {
      const params = userId ? [orderId, userId] : [orderId];
      const res = await this.db.query(
        userId
          ? `${ORDER_WITH_ITEMS_QUERY}
             WHERE orders.id = $1 AND orders.user_id = $2
             GROUP BY orders.id
             LIMIT 1`
          : `${ORDER_WITH_ITEMS_QUERY}
             WHERE orders.id = $1
             GROUP BY orders.id
             LIMIT 1`,
        params,
      );
      return res.rows[0] ? mapOrderFromDb(res.rows[0]) : null;
    } catch (err) {
      console.error('Error fetching order:', err);
      return null;
    }
  }

  async create(data: CreateOrderPayload) {
    const id = randomUUID() as string;
    const order: Order = {
      id,
      userId: data.userId,
      cartId: data.cartId,
      items: data.items,
      payment: {
        type: 'card',
      },
      delivery: {
        type: 'delivery',
        address: data.address.address,
        firstName: data.address.firstName,
        lastName: data.address.lastName,
      },
      comments: data.address.comment || null,
      status: OrderStatus.Open,
      total: data.total,
    };

    try {
      await this.db.query('BEGIN');
      await this.db.query(
        `INSERT INTO orders (id, user_id, cart_id, payment, delivery, comments, status, total)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
        [
          order.id,
          order.userId,
          order.cartId,
          JSON.stringify(order.payment),
          JSON.stringify(order.delivery),
          order.comments,
          order.status,
          order.total,
        ],
      );
      await this.db.query(
        `UPDATE carts SET status = 'ORDERED', updated_at = NOW()
         WHERE id = $1 AND status = 'OPEN'`,
        [order.cartId],
      );
      await this.db.query('COMMIT');
    } catch (err) {
      await this.db.query('ROLLBACK');
      console.error('Error creating order:', err);
      throw new Error('Could not create order');
    }
    return order;
  }

  async update(orderId: string, data: Order) {
    const order = await this.findById(orderId);

    if (!order) {
      throw new Error('Order does not exist.');
    }

    try {
      await this.db.query(
        `UPDATE orders
         SET user_id = $1, cart_id = $2, payment = $3, delivery = $4, comments = $5, status = $6, total = $7
         WHERE id = $8`,
        [
          data.userId,
          data.cartId,
          JSON.stringify(data.payment),
          JSON.stringify(data.delivery),
          data.comments,
          data.status,
          data.total,
          orderId,
        ],
      );
    } catch (err) {
      console.error('Error updating order:', err);
      throw new Error('Could not update order');
    }
  }

  async deleteById(orderId: string) {
    try {
      await this.db.query('DELETE FROM orders WHERE id = $1', [orderId]);
    } catch (err) {
      console.error('Error deleting order:', err);
      throw new Error('Could not delete order');
    }
  }

  async updateStatusById(orderId: string, status: OrderStatus, comment = '') {
    const validStatuses = Object.values(OrderStatus) as string[];
    if (!validStatuses.includes(status)) {
      throw new Error(`Invalid status: ${status}`);
    }

    const order = await this.findById(orderId);

    if (!order) {
      throw new Error('Order does not exist.');
    }

    try {
      await this.db.query(
        `UPDATE orders SET status = $1, comments = $2 WHERE id = $3`,
        [status, comment || order.comments, orderId],
      );
    } catch (err) {
      console.error('Error updating order status:', err);
      throw new Error('Could not update order status');
    }
  }
}

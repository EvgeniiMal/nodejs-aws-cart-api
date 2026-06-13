import { Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { User } from '../models';
import Database from 'src/db/database';

@Injectable()
export class UsersService {
  constructor(private readonly db: Database) { }

  async findOne(username: string): Promise<User | null> {
    try {
      const row = await this.db.query(
        'SELECT id, username, password_hash AS password FROM users WHERE username = $1',
        [username],
      );
      return row.rows[0] || null;
    } catch (err) {
      console.error('Error fetching user:', err);
      throw err;
    }
  }

  async createOne({ id, username, password }: User): Promise<User> {
    const userId = id ?? randomUUID();
    const newUser = { id: userId, username, password };

    try {
      await this.db.query(
        'INSERT INTO users (id, username, password_hash, created_at) VALUES ($1, $2, $3, NOW())',
        [userId, username, password],
      );
      return newUser;
    } catch (err) {
      console.error('Error creating user:', err);
      throw err;
    }
  }
}

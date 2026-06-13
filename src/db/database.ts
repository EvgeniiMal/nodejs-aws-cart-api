import { Injectable } from '@nestjs/common';
import { Pool } from 'pg';

@Injectable()
export default class Database {
  private readonly pool: Pool;

  constructor() {
    this.pool = new Pool({
      host: process.env.PGHOST,
      user: process.env.PGUSER,
      password: process.env.PGPASSWORD,
      database: process.env.PGDATABASE,
      port: Number(process.env.PGPORT),
      ssl: { rejectUnauthorized: false },
      max: 2,
      connectionTimeoutMillis: 3000,
      idleTimeoutMillis: 10000,
    });
  }

  public query(text: string, values?: any[]) {
    return this.pool.query(text, values);
  }
}
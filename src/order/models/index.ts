import { Delivery, OrderStatus, Payment } from '../type';

export type Order = {
  id?: string;
  userId: string;
  cartId: string;
  items: Array<{ productId: string; count: number }>;
  payment: Payment;
  delivery: Delivery;
  comments: string | null;
  status: OrderStatus;
  total: number;
};

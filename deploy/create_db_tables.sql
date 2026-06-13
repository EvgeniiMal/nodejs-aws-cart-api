DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS cart_items CASCADE;
DROP TABLE IF EXISTS carts CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TYPE IF EXISTS order_status;
DROP TYPE IF EXISTS cart_status;
CREATE TYPE cart_status AS ENUM ('OPEN', 'ORDERED');
CREATE TYPE order_status AS ENUM (
  'OPEN',
  'APPROVED',
  'CONFIRMED',
  'SENT',
  'COMPLETED',
  'CANCELLED'
);
CREATE TABLE users (
  id uuid PRIMARY KEY,
  username text NOT NULL UNIQUE,
  password_hash text NOT NULL,
  created_at timestamp NOT NULL
);
CREATE TABLE carts (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  status cart_status NOT NULL,
  CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE cart_items (
  cart_id uuid NOT NULL,
  product_id uuid NOT NULL,
  count integer NOT NULL CHECK (count > 0),
  PRIMARY KEY (cart_id, product_id),
  CONSTRAINT fk_cart FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE
);
CREATE TABLE orders (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL,
  cart_id uuid NOT NULL,
  payment jsonb NOT NULL,
  delivery jsonb NOT NULL,
  comments text,
  status order_status NOT NULL,
  total numeric(10, 2) NOT NULL CHECK (total >= 0),
  CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_order_cart FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE RESTRICT
);
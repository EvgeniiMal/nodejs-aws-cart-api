DO $$ BEGIN IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'cart_status'
) THEN CREATE TYPE cart_status AS ENUM ('OPEN', 'ORDERED');
END IF;
END $$;
DO $$ BEGIN IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'order_status'
) THEN CREATE TYPE order_status AS ENUM ('CREATED', 'PAID', 'CANCELLED');
END IF;
END $$;
CREATE TABLE IF NOT EXISTS carts (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  status cart_status NOT NULL
);
CREATE TABLE IF NOT EXISTS cart_items (
  cart_id uuid NOT NULL,
  product_id uuid NOT NULL,
  count integer NOT NULL,
  PRIMARY KEY (cart_id, product_id),
  CONSTRAINT fk_cart FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL,
  cart_id uuid NOT NULL,
  payment jsonb NOT NULL,
  delivery jsonb NOT NULL,
  comments text,
  status order_status NOT NULL,
  total numeric(10, 2) NOT NULL,
  CONSTRAINT fk_order_cart FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE RESTRICT
);
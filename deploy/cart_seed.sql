INSERT INTO users (id, username, password_hash, created_at)
VALUES (
    '11111111-1111-1111-1111-111111111111',
    'john',
    'hash_john',
    NOW()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'kate',
    'hash_kate',
    NOW()
  );
INSERT INTO carts (id, user_id, created_at, updated_at, status)
VALUES (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '11111111-1111-1111-1111-111111111111',
    NOW(),
    NOW(),
    'OPEN'
  ),
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '11111111-1111-1111-1111-111111111111',
    NOW(),
    NOW(),
    'ORDERED'
  ),
  (
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '22222222-2222-2222-2222-222222222222',
    NOW(),
    NOW(),
    'ORDERED'
  );
INSERT INTO cart_items (cart_id, product_id, count)
VALUES (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '10101010-1010-1010-1010-101010101010',
    2
  ),
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '20202020-2020-2020-2020-202020202020',
    1
  ),
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '30303030-3030-3030-3030-303030303030',
    3
  ),
  (
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '40404040-4040-4040-4040-404040404040',
    1
  );
INSERT INTO orders (
    id,
    user_id,
    cart_id,
    payment,
    delivery,
    comments,
    status,
    total
  )
VALUES (
    'dddddddd-dddd-dddd-dddd-dddddddddddd',
    '11111111-1111-1111-1111-111111111111',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '{"type": "card", "status": "paid"}'::jsonb,
    '{"city": "Amsterdam", "address": "Main street 1"}'::jsonb,
    'Please call before delivery',
    'CONFIRMED',
    129.99
  ),
  (
    'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
    '22222222-2222-2222-2222-222222222222',
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '{"type": "cash", "status": "pending"}'::jsonb,
    '{"city": "Rotterdam", "address": "Market street 10"}'::jsonb,
    NULL,
    'OPEN',
    49.50
  );
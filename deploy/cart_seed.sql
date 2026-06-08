BEGIN;
TRUNCATE TABLE orders,
cart_items,
carts CASCADE;
INSERT INTO carts (id, user_id, created_at, updated_at, status)
VALUES (
    '11111111-1111-1111-1111-111111111111',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    NOW() - INTERVAL '10 days',
    NOW() - INTERVAL '9 days',
    'OPEN'
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    NOW() - INTERVAL '8 days',
    NOW() - INTERVAL '7 days',
    'ORDERED'
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    NOW() - INTERVAL '6 days',
    NOW() - INTERVAL '5 days',
    'OPEN'
  ),
  (
    '44444444-4444-4444-4444-444444444444',
    'dddddddd-dddd-dddd-dddd-dddddddddddd',
    NOW() - INTERVAL '5 days',
    NOW() - INTERVAL '4 days',
    'ORDERED'
  ),
  (
    '55555555-5555-5555-5555-555555555555',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    NOW() - INTERVAL '4 days',
    NOW() - INTERVAL '3 days',
    'OPEN'
  ),
  (
    '66666666-6666-6666-6666-666666666666',
    'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
    NOW() - INTERVAL '3 days',
    NOW() - INTERVAL '2 days',
    'ORDERED'
  ),
  (
    '77777777-7777-7777-7777-777777777777',
    'ffffffff-ffff-ffff-ffff-ffffffffffff',
    NOW() - INTERVAL '2 days',
    NOW() - INTERVAL '1 day',
    'OPEN'
  ),
  (
    '88888888-8888-8888-8888-888888888888',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    NOW() - INTERVAL '1 day',
    NOW(),
    'OPEN'
  ),
  (
    '99999999-9999-9999-9999-999999999999',
    '99999999-aaaa-bbbb-cccc-999999999999',
    NOW() - INTERVAL '12 hours',
    NOW() - INTERVAL '6 hours',
    'ORDERED'
  ),
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '11111111-aaaa-bbbb-cccc-111111111111',
    NOW() - INTERVAL '6 hours',
    NOW() - INTERVAL '2 hours',
    'OPEN'
  ),
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '22222222-aaaa-bbbb-cccc-222222222222',
    NOW() - INTERVAL '3 hours',
    NOW() - INTERVAL '1 hour',
    'OPEN'
  ),
  (
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '33333333-aaaa-bbbb-cccc-333333333333',
    NOW() - INTERVAL '2 hours',
    NOW(),
    'ORDERED'
  );
INSERT INTO cart_items (cart_id, product_id, count)
VALUES -- cart 1: OPEN
  (
    '11111111-1111-1111-1111-111111111111',
    '6a7c1f9e-8f3b-4a0b-9d71-2f2e7c5a1111',
    2
  ),
  (
    '11111111-1111-1111-1111-111111111111',
    '7b8d2a0f-9a4c-4b1c-8e82-3a3f8d6b2222',
    1
  ),
  (
    '11111111-1111-1111-1111-111111111111',
    '8c9e3b1a-0b5d-4c2d-9f93-4b4a9e7c3333',
    4
  ),
  -- cart 2: ORDERED
  (
    '22222222-2222-2222-2222-222222222222',
    '9d0f4c2b-1c6e-4d3e-a004-5c5b0f8d4444',
    1
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    '0e1a5d3c-2d7f-4e4f-b115-6d6c1a9e5555',
    2
  ),
  -- cart 3: OPEN
  (
    '33333333-3333-3333-3333-333333333333',
    '1f2b6e4d-3e8a-4f5a-c226-7e7d2b0f6666',
    3
  ),
  -- cart 4: ORDERED
  (
    '44444444-4444-4444-4444-444444444444',
    '2a3c7f5e-4f9b-406b-d337-8f8e3c1a7777',
    1
  ),
  (
    '44444444-4444-4444-4444-444444444444',
    '3b4d806f-5a0c-417c-e448-9a9f4d2b8888',
    1
  ),
  (
    '44444444-4444-4444-4444-444444444444',
    '4c5e917a-6b1d-428d-f559-0b0a5e3c9999',
    2
  ),
  (
    '44444444-4444-4444-4444-444444444444',
    '5d6f028b-7c2e-439e-a660-1c1b6f4d0000',
    5
  ),
  -- cart 5: OPEN
  (
    '55555555-5555-5555-5555-555555555555',
    '6a7c1f9e-8f3b-4a0b-9d71-2f2e7c5a1111',
    1
  ),
  (
    '55555555-5555-5555-5555-555555555555',
    '2a3c7f5e-4f9b-406b-d337-8f8e3c1a7777',
    2
  ),
  -- cart 6: ORDERED
  (
    '66666666-6666-6666-6666-666666666666',
    '7b8d2a0f-9a4c-4b1c-8e82-3a3f8d6b2222',
    6
  ),
  (
    '66666666-6666-6666-6666-666666666666',
    '8c9e3b1a-0b5d-4c2d-9f93-4b4a9e7c3333',
    2
  ),
  (
    '66666666-6666-6666-6666-666666666666',
    '9d0f4c2b-1c6e-4d3e-a004-5c5b0f8d4444',
    1
  ),
  -- cart 7: OPEN
  (
    '77777777-7777-7777-7777-777777777777',
    '0e1a5d3c-2d7f-4e4f-b115-6d6c1a9e5555',
    3
  ),
  (
    '77777777-7777-7777-7777-777777777777',
    '1f2b6e4d-3e8a-4f5a-c226-7e7d2b0f6666',
    1
  ),
  (
    '77777777-7777-7777-7777-777777777777',
    '3b4d806f-5a0c-417c-e448-9a9f4d2b8888',
    2
  ),
  -- cart 8: OPEN
  (
    '88888888-8888-8888-8888-888888888888',
    '4c5e917a-6b1d-428d-f559-0b0a5e3c9999',
    1
  ),
  (
    '88888888-8888-8888-8888-888888888888',
    '5d6f028b-7c2e-439e-a660-1c1b6f4d0000',
    4
  ),
  (
    '88888888-8888-8888-8888-888888888888',
    '6a7c1f9e-8f3b-4a0b-9d71-2f2e7c5a1111',
    2
  ),
  -- cart 9: ORDERED
  (
    '99999999-9999-9999-9999-999999999999',
    '7b8d2a0f-9a4c-4b1c-8e82-3a3f8d6b2222',
    1
  ),
  (
    '99999999-9999-9999-9999-999999999999',
    '2a3c7f5e-4f9b-406b-d337-8f8e3c1a7777',
    3
  ),
  -- cart 10: OPEN
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '8c9e3b1a-0b5d-4c2d-9f93-4b4a9e7c3333',
    2
  ),
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '4c5e917a-6b1d-428d-f559-0b0a5e3c9999',
    1
  ),
  -- cart 11: OPEN
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '0e1a5d3c-2d7f-4e4f-b115-6d6c1a9e5555',
    5
  ),
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '5d6f028b-7c2e-439e-a660-1c1b6f4d0000',
    1
  ),
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '1f2b6e4d-3e8a-4f5a-c226-7e7d2b0f6666',
    2
  ),
  -- cart 12: ORDERED
  (
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '6a7c1f9e-8f3b-4a0b-9d71-2f2e7c5a1111',
    1
  ),
  (
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '9d0f4c2b-1c6e-4d3e-a004-5c5b0f8d4444',
    2
  ),
  (
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '3b4d806f-5a0c-417c-e448-9a9f4d2b8888',
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
    '10000000-0000-0000-0000-000000000001',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '22222222-2222-2222-2222-222222222222',
    '{
      "type": "card",
      "address": "NL01 TEST 0123 4567 89",
      "creditCard": "**** **** **** 1111"
    }'::jsonb,
    '{
      "type": "delivery",
      "address": "Teststraat 10, Amsterdam",
      "phone": "+31611111111"
    }'::jsonb,
    'Please deliver after 18:00',
    'CREATED',
    249.99
  ),
  (
    '10000000-0000-0000-0000-000000000002',
    'dddddddd-dddd-dddd-dddd-dddddddddddd',
    '44444444-4444-4444-4444-444444444444',
    '{
      "type": "paypal",
      "email": "customer@example.com"
    }'::jsonb,
    '{
      "type": "pickup",
      "store": "Amsterdam Central"
    }'::jsonb,
    'Customer will pick up the order',
    'PAID',
    399.50
  ),
  (
    '10000000-0000-0000-0000-000000000003',
    'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
    '66666666-6666-6666-6666-666666666666',
    '{
      "type": "card",
      "address": "NL02 TEST 9876 5432 10",
      "creditCard": "**** **** **** 2222"
    }'::jsonb,
    '{
      "type": "delivery",
      "address": "Markt 5, Utrecht",
      "phone": "+31622222222"
    }'::jsonb,
    NULL,
    'PAID',
    179.90
  ),
  (
    '10000000-0000-0000-0000-000000000004',
    '99999999-aaaa-bbbb-cccc-999999999999',
    '99999999-9999-9999-9999-999999999999',
    '{
      "type": "card",
      "address": "NL03 TEST 1111 2222 33",
      "creditCard": "**** **** **** 3333"
    }'::jsonb,
    '{
      "type": "delivery",
      "address": "Stationsplein 1, Rotterdam",
      "phone": "+31633333333"
    }'::jsonb,
    'Ring the doorbell twice',
    'CREATED',
    129.75
  ),
  (
    '10000000-0000-0000-0000-000000000005',
    '33333333-aaaa-bbbb-cccc-333333333333',
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '{
      "type": "paypal",
      "email": "another.customer@example.com"
    }'::jsonb,
    '{
      "type": "delivery",
      "address": "Nieuweweg 25, Haarlem",
      "phone": "+31644444444"
    }'::jsonb,
    'Leave the package with neighbours if nobody is home',
    'CANCELLED',
    89.99
  );
COMMIT;
-- seed.sql
-- Test data for carts and cart_items.
-- Product ids are taken from selected.csv.
-- This script resets carts/cart_items data and inserts deterministic examples.

BEGIN;

TRUNCATE TABLE cart_items, carts CASCADE;

INSERT INTO carts (id, user_id, created_at, updated_at, status)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NOW() - INTERVAL '12 days', NOW() - INTERVAL '11 days', 'OPEN'),
  ('22222222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NOW() - INTERVAL '11 days', NOW() - INTERVAL '10 days', 'ORDERED'),
  ('33333333-3333-3333-3333-333333333333', 'cccccccc-cccc-cccc-cccc-cccccccccccc', NOW() - INTERVAL '10 days', NOW() - INTERVAL '9 days', 'OPEN'),
  ('44444444-4444-4444-4444-444444444444', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NOW() - INTERVAL '9 days', NOW() - INTERVAL '8 days', 'ORDERED'),
  ('55555555-5555-5555-5555-555555555555', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', NOW() - INTERVAL '8 days', NOW() - INTERVAL '7 days', 'OPEN'),
  ('66666666-6666-6666-6666-666666666666', 'ffffffff-ffff-ffff-ffff-ffffffffffff', NOW() - INTERVAL '7 days', NOW() - INTERVAL '6 days', 'ORDERED'),
  ('77777777-7777-7777-7777-777777777777', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NOW() - INTERVAL '6 days', NOW() - INTERVAL '5 days', 'OPEN'),
  ('88888888-8888-8888-8888-888888888888', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NOW() - INTERVAL '5 days', NOW() - INTERVAL '4 days', 'ORDERED'),
  ('99999999-9999-9999-9999-999999999999', 'cccccccc-cccc-cccc-cccc-cccccccccccc', NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days', 'OPEN'),
  ('aaaaaaaa-1111-2222-3333-aaaaaaaaaaaa', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NOW() - INTERVAL '3 days', NOW() - INTERVAL '2 days', 'OPEN'),
  ('bbbbbbbb-1111-2222-3333-bbbbbbbbbbbb', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day', 'ORDERED'),
  ('cccccccc-1111-2222-3333-cccccccccccc', 'ffffffff-ffff-ffff-ffff-ffffffffffff', NOW() - INTERVAL '1 day', NOW(), 'OPEN');

INSERT INTO cart_items (cart_id, product_id, count)
VALUES
  ('11111111-1111-1111-1111-111111111111', '6704a541-6572-4d9e-a146-6ba390d3a668', 1), -- Samsung Galaxy S24
  ('11111111-1111-1111-1111-111111111111', '8538be22-d939-497d-9fc6-45a7706802c4', 1), -- Microsoft Xbox Series X
  ('11111111-1111-1111-1111-111111111111', 'fff7636a-e85e-4b0f-a82f-2375f5eda1ba', 2), -- USB-C Docking Station
  ('22222222-2222-2222-2222-222222222222', 'ef4bebf1-c519-4b8d-a47b-5b28748f8da2', 2), -- Kindle Paperwhite
  ('22222222-2222-2222-2222-222222222222', '6722b579-dd07-453b-a07f-0eac78903de6', 1), -- Dell UltraSharp U2723QE
  ('33333333-3333-3333-3333-333333333333', 'a205eee9-fc09-4cce-a780-6fbec6fc36e3', 1), -- Fitbit Charge 5
  ('33333333-3333-3333-3333-333333333333', '27f24a63-b601-4558-9f8e-264dc3edcb1e', 3), -- Amazon Echo Dot 4th Gen
  ('33333333-3333-3333-3333-333333333333', '93d024bb-702b-4046-91a4-713c5cfb44c8', 2), -- Webcam Full HD
  ('33333333-3333-3333-3333-333333333333', 'ac835675-a981-4176-945a-67a305f580d8', 1), -- Nintendo Switch OLED
  ('44444444-4444-4444-4444-444444444444', '79a6cb3c-641c-4162-8ec2-087a732e7dc7', 1), -- DJI Mavic Air 2
  ('44444444-4444-4444-4444-444444444444', 'a02d3803-1228-4f10-85e3-a41fcf88bc6b', 2), -- External SSD 1TB
  ('44444444-4444-4444-4444-444444444444', 'cface253-2f73-4925-bd84-06aa1c1534ab', 1), -- Apple MacBook Air M4
  ('55555555-5555-5555-5555-555555555555', '8467aee4-014b-4c77-b721-90b546cf886f', 2), -- Bose QuietComfort 45
  ('55555555-5555-5555-5555-555555555555', 'a327fc2b-5640-4df9-9ff9-dd3ed18c4892', 1), -- GoPro HERO9 Black
  ('66666666-6666-6666-6666-666666666666', '4aba55ff-1464-4b9f-aeca-7bd4c2c0c8cc', 1), -- Apple iPhone 15
  ('66666666-6666-6666-6666-666666666666', '937784a4-432a-4bd7-8858-5b10e46db844', 2), -- Apple AirPods Pro
  ('66666666-6666-6666-6666-666666666666', '12e912e3-b778-466c-9acd-13e69157c4bd', 1), -- Sony WH-1000XM5
  ('77777777-7777-7777-7777-777777777777', 'b4189390-d0f5-4d09-82e2-cb541b3e7a7b', 1), -- Logitech MX Master 3S
  ('77777777-7777-7777-7777-777777777777', '697e00b1-5bc8-454b-8009-3629c2f6647e', 1), -- Mechanical Keyboard RGB
  ('77777777-7777-7777-7777-777777777777', '367ab7ea-71ad-4beb-b259-eaf3d62fb8f1', 2), -- Samsung Galaxy Buds Pro
  ('88888888-8888-8888-8888-888888888888', 'ca5ec981-42d9-4850-9aa2-ff7835fd1554', 3), -- Roku Streaming Stick+
  ('88888888-8888-8888-8888-888888888888', '6347bd25-c6af-4bcb-bc27-f462bf54af93', 1), -- GoPro HERO10 Black
  ('99999999-9999-9999-9999-999999999999', '02bd16e7-c968-4656-a6a5-2cd9a7c510d9', 1), -- Sony PlayStation 5
  ('99999999-9999-9999-9999-999999999999', '6704a541-6572-4d9e-a146-6ba390d3a668', 1), -- Samsung Galaxy S24
  ('99999999-9999-9999-9999-999999999999', '6722b579-dd07-453b-a07f-0eac78903de6', 2), -- Dell UltraSharp U2723QE
  ('99999999-9999-9999-9999-999999999999', 'ac835675-a981-4176-945a-67a305f580d8', 1), -- Nintendo Switch OLED
  ('aaaaaaaa-1111-2222-3333-aaaaaaaaaaaa', 'fff7636a-e85e-4b0f-a82f-2375f5eda1ba', 2), -- USB-C Docking Station
  ('aaaaaaaa-1111-2222-3333-aaaaaaaaaaaa', '27f24a63-b601-4558-9f8e-264dc3edcb1e', 1), -- Amazon Echo Dot 4th Gen
  ('aaaaaaaa-1111-2222-3333-aaaaaaaaaaaa', 'a02d3803-1228-4f10-85e3-a41fcf88bc6b', 1), -- External SSD 1TB
  ('aaaaaaaa-1111-2222-3333-aaaaaaaaaaaa', '4aba55ff-1464-4b9f-aeca-7bd4c2c0c8cc', 1), -- Apple iPhone 15
  ('bbbbbbbb-1111-2222-3333-bbbbbbbbbbbb', '8538be22-d939-497d-9fc6-45a7706802c4', 1), -- Microsoft Xbox Series X
  ('bbbbbbbb-1111-2222-3333-bbbbbbbbbbbb', 'a205eee9-fc09-4cce-a780-6fbec6fc36e3', 2), -- Fitbit Charge 5
  ('bbbbbbbb-1111-2222-3333-bbbbbbbbbbbb', '79a6cb3c-641c-4162-8ec2-087a732e7dc7', 1), -- DJI Mavic Air 2
  ('bbbbbbbb-1111-2222-3333-bbbbbbbbbbbb', 'a327fc2b-5640-4df9-9ff9-dd3ed18c4892', 1), -- GoPro HERO9 Black
  ('cccccccc-1111-2222-3333-cccccccccccc', 'ef4bebf1-c519-4b8d-a47b-5b28748f8da2', 1), -- Kindle Paperwhite
  ('cccccccc-1111-2222-3333-cccccccccccc', '93d024bb-702b-4046-91a4-713c5cfb44c8', 2), -- Webcam Full HD
  ('cccccccc-1111-2222-3333-cccccccccccc', 'cface253-2f73-4925-bd84-06aa1c1534ab', 1), -- Apple MacBook Air M4
  ('cccccccc-1111-2222-3333-cccccccccccc', '937784a4-432a-4bd7-8858-5b10e46db844', 1), -- Apple AirPods Pro
  ('cccccccc-1111-2222-3333-cccccccccccc', '367ab7ea-71ad-4beb-b259-eaf3d62fb8f1', 2); -- Samsung Galaxy Buds Pro

COMMIT;
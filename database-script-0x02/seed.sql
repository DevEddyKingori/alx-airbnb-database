-- ====================================
-- ✅ Enabling UUID Extension (only once)
-- ====================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ====================================
-- ✅ Inserting Users (guests, host, admin)
-- ====================================
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES 
(uuid_generate_v4(), 'Alice', 'Walker', 'alice@example.com', 'hashed_password1', '254700111111', 'guest'),
(uuid_generate_v4(), 'Bob', 'Miller', 'bob@example.com', 'hashed_password2', '254700222222', 'guest'),
(uuid_generate_v4(), 'Charlie', 'Hostman', 'charlie@example.com', 'hashed_password3', '254700333333', 'host'),
(uuid_generate_v4(), 'Diana', 'Adminson', 'admin@example.com', 'hashed_password4', '254700444444', 'admin');

-- ====================================
-- ✅ Inserting Properties (owned by Charlie)
-- ====================================
INSERT INTO properties (property_id, host_id, name, description, location, pricepernight)
VALUES
(uuid_generate_v4(), 
 (SELECT user_id FROM users WHERE email = 'charlie@example.com'), 
 'Cozy Apartment', 
 'A modern apartment in downtown Nairobi.', 
 'Nairobi, Kenya', 45.00),

(uuid_generate_v4(), 
 (SELECT user_id FROM users WHERE email = 'charlie@example.com'), 
 'Beachfront Villa', 
 'Luxurious beachfront property with stunning ocean views.', 
 'Diani Beach, Kenya', 120.00);

-- ====================================
-- ✅ Inserting Bookings (by Alice and Bob)
-- ====================================
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
(uuid_generate_v4(), 
 (SELECT property_id FROM properties WHERE name = 'Cozy Apartment'), 
 (SELECT user_id FROM users WHERE email = 'alice@example.com'), 
 '2025-07-01', '2025-07-05', 180.00, 'confirmed'),

(uuid_generate_v4(), 
 (SELECT property_id FROM properties WHERE name = 'Beachfront Villa'), 
 (SELECT user_id FROM users WHERE email = 'bob@example.com'), 
 '2025-08-15', '2025-08-20', 600.00, 'pending');

-- ====================================
-- ✅ Inserting Payment (only confirmed booking)
-- ====================================
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
VALUES
(uuid_generate_v4(), 
 (SELECT booking_id FROM bookings WHERE status = 'confirmed' AND total_price = 180.00), 
 180.00, 'stripe');

-- ====================================
-- ✅ Inserting Reviews
-- ====================================
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
VALUES
(uuid_generate_v4(), 
 (SELECT property_id FROM properties WHERE name = 'Cozy Apartment'), 
 (SELECT user_id FROM users WHERE email = 'alice@example.com'), 
 5, 'The apartment was clean and in a great location!'),

(uuid_generate_v4(), 
 (SELECT property_id FROM properties WHERE name = 'Beachfront Villa'), 
 (SELECT user_id FROM users WHERE email = 'bob@example.com'), 
 4, 'Beautiful views but the Wi-Fi was a bit slow.');

-- ====================================
-- ✅ Inserting Messages (guest ↔ host)
-- ====================================
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
VALUES
(uuid_generate_v4(),
 (SELECT user_id FROM users WHERE email = 'alice@example.com'),
 (SELECT user_id FROM users WHERE email = 'charlie@example.com'),
 'Hi Charlie, is the apartment available for early check-in on July 1st?'),

(uuid_generate_v4(),
 (SELECT user_id FROM users WHERE email = 'charlie@example.com'),
 (SELECT user_id FROM users WHERE email = 'alice@example.com'),
 'Hi Alice, yes early check-in at 11am is okay!');

-- ✅ User Table

CREATE TYPE user_role AS ENUM ('guest', 'host', 'admin');

CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR UNIQUE NOT NULL,
    password_hash VARCHAR NOT NULL,
    phone_number VARCHAR,
    role user_role NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_user_id ON users(user_id);


-- ✅ Property Table

CREATE TABLE properties (
    property_id UUID PRIMARY KEY,
    host_id UUID REFERENCES users(user_id),
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR NOT NULL,
    pricepernight DECIMAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_properties_property_id ON properties(property_id);

-- ✅ Booking Table

CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');

CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY,
    property_id UUID REFERENCES properties(property_id),
    user_id UUID REFERENCES users(user_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    status booking_status NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_bookings_booking_id ON bookings(booking_id);

--✅ Payment Table

CREATE TYPE payment_method_enum AS ENUM ('credit_card', 'paypal', 'stripe');

CREATE TABLE payments (
    payment_id UUID PRIMARY KEY,
    booking_id UUID REFERENCES bookings(booking_id),
    amount DECIMAL NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method payment_method_enum NOT NULL
);

CREATE INDEX idx_payments_payment_id ON payments(payment_id);


--✅ Review Table

CREATE TABLE reviews (
    review_id UUID PRIMARY KEY,
    property_id UUID REFERENCES properties(property_id),
    user_id UUID REFERENCES users(user_id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reviews_review_id ON reviews(review_id);


-- ✅ Message Table.

CREATE TABLE messages (
    message_id UUID PRIMARY KEY,
    sender_id UUID REFERENCES users(user_id),
    recipient_id UUID REFERENCES users(user_id),
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_messages_message_id ON messages(message_id);

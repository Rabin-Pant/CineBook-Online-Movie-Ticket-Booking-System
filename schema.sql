-- ================================================
-- CineBook Database Schema (Final)
-- Online Movie Ticket Booking System
-- Version: 2.0
-- ================================================

CREATE DATABASE IF NOT EXISTS cinebook;
USE cinebook;

-- ================================================
-- TABLE: admins
-- ================================================
CREATE TABLE IF NOT EXISTS admins (
    admin_id       INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(100) NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    password       VARCHAR(255) NOT NULL,
    phone          VARCHAR(15),
    role           VARCHAR(50) DEFAULT 'admin',
    permissions    TEXT,
    last_login_ip  VARCHAR(45),
    last_login_at  TIMESTAMP NULL,
    is_active      BOOLEAN DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================
-- TABLE: customers
-- ================================================
CREATE TABLE IF NOT EXISTS customers (
    customer_id      INT AUTO_INCREMENT PRIMARY KEY,
    full_name        VARCHAR(100) NOT NULL,
    email            VARCHAR(100) NOT NULL UNIQUE,
    password         VARCHAR(255) NOT NULL,
    phone            VARCHAR(15) DEFAULT NULL,
    is_active        TINYINT(1) DEFAULT 1,
    profile_picture  VARCHAR(255) DEFAULT NULL,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ================================================
-- TABLE: movies
-- ================================================
CREATE TABLE IF NOT EXISTS movies (
    movie_id     INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(150) NOT NULL,
    description  TEXT,
    genre        VARCHAR(50),
    duration     INT NOT NULL,                -- in minutes
    language     VARCHAR(30),
    rating       DECIMAL(3,1),               -- e.g. 8.5
    poster_url   VARCHAR(255),               -- stored in cinebook_uploads folder
    status       ENUM('now_showing','coming_soon') DEFAULT 'now_showing',
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================
-- TABLE: showtimes
-- ================================================
CREATE TABLE IF NOT EXISTS showtimes (
    showtime_id  INT AUTO_INCREMENT PRIMARY KEY,
    movie_id     INT NOT NULL,
    show_date    DATE NOT NULL,
    show_time    TIME NOT NULL,
    hall         VARCHAR(50) NOT NULL,
    total_seats  INT NOT NULL DEFAULT 60,
    price        DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
        ON DELETE CASCADE
);

-- ================================================
-- TABLE: seats
-- Auto generated when showtime is added
-- Rows A-F, 10 seats each = 60 seats max
-- ================================================
CREATE TABLE IF NOT EXISTS seats (
    seat_id      INT AUTO_INCREMENT PRIMARY KEY,
    showtime_id  INT NOT NULL,
    seat_number  VARCHAR(10) NOT NULL,        -- e.g. A1, B5
    is_booked    BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (showtime_id) REFERENCES showtimes(showtime_id)
        ON DELETE CASCADE
);

-- ================================================
-- TABLE: bookings
-- ================================================
CREATE TABLE IF NOT EXISTS bookings (
    booking_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id       INT NOT NULL,
    showtime_id       INT NOT NULL,
    total_amount      DECIMAL(10,2) NOT NULL,
    booking_status    ENUM('confirmed','cancelled') DEFAULT 'confirmed',

    -- eSewa Payment fields
    payment_method    VARCHAR(50) DEFAULT 'esewa',
    payment_status    ENUM('pending','completed','failed') DEFAULT 'pending',
    transaction_id    VARCHAR(100) NULL,
    payment_amount    DECIMAL(10,2) NULL,

    -- Cancellation & Refund fields (8% cancellation fee)
    refund_amount     DECIMAL(10,2) NULL,
    cancellation_fee  DECIMAL(10,2) NULL,
    refund_status     ENUM('none','pending','completed') DEFAULT 'none',
    cancelled_at      TIMESTAMP NULL,

    booked_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE,
    FOREIGN KEY (showtime_id) REFERENCES showtimes(showtime_id)
        ON DELETE CASCADE
);

-- ================================================
-- TABLE: booking_seats
-- Maps bookings to individual seats
-- ================================================
CREATE TABLE IF NOT EXISTS booking_seats (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    booking_id  INT NOT NULL,
    seat_id     INT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
        ON DELETE CASCADE
);

-- ================================================
-- DEFAULT ADMIN USER
-- Email: admin@cinebook.com
-- Password: password123 (BCrypt hashed)
-- ================================================
INSERT INTO admins (
    full_name, email, password, phone, role, is_active
) VALUES (
    'Super Admin',
    'admin@cinebook.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    '9800000001',
    'super_admin',
    TRUE
);
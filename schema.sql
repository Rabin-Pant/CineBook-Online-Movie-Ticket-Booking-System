-- ================================================
-- CineBook Database Schema
-- Online Movie Ticket Booking System
-- ================================================

CREATE DATABASE IF NOT EXISTS cinebook;
USE cinebook;

-- ================================================
-- TABLE: admins
-- ================================================
CREATE TABLE admins (
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
CREATE TABLE customers (
    customer_id  INT AUTO_INCREMENT PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    password     VARCHAR(255) NOT NULL,
    phone        VARCHAR(15),
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================
-- TABLE: movies
-- ================================================
CREATE TABLE movies (
    movie_id     INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(150) NOT NULL,
    description  TEXT,
    genre        VARCHAR(50),
    duration     INT NOT NULL,
    language     VARCHAR(30),
    rating       DECIMAL(3,1),
    poster_url   VARCHAR(255),
    status       ENUM('now_showing', 'coming_soon') DEFAULT 'now_showing',
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================
-- TABLE: showtimes
-- ================================================
CREATE TABLE showtimes (
    showtime_id  INT AUTO_INCREMENT PRIMARY KEY,
    movie_id     INT NOT NULL,
    show_date    DATE NOT NULL,
    show_time    TIME NOT NULL,
    hall         VARCHAR(50) NOT NULL,
    total_seats  INT NOT NULL DEFAULT 60,
    price        DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE: seats
-- ================================================
CREATE TABLE seats (
    seat_id      INT AUTO_INCREMENT PRIMARY KEY,
    showtime_id  INT NOT NULL,
    seat_number  VARCHAR(10) NOT NULL,
    is_booked    BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (showtime_id) REFERENCES showtimes(showtime_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE: bookings
-- ================================================
CREATE TABLE bookings (
    booking_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id       INT NOT NULL,
    showtime_id       INT NOT NULL,
    total_amount      DECIMAL(10,2) NOT NULL,
    booking_status    ENUM('confirmed', 'cancelled') DEFAULT 'confirmed',
    payment_method    VARCHAR(50) DEFAULT 'esewa',
    payment_status    ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    transaction_id    VARCHAR(100) NULL,
    payment_amount    DECIMAL(10,2) NULL,
    refund_amount     DECIMAL(10,2) NULL,
    cancellation_fee  DECIMAL(10,2) NULL,
    refund_status     ENUM('none', 'pending', 'completed') DEFAULT 'none',
    cancelled_at      TIMESTAMP NULL,
    booked_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (showtime_id) REFERENCES showtimes(showtime_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE: booking_seats
-- ================================================
CREATE TABLE booking_seats (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    booking_id  INT NOT NULL,
    seat_id     INT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id)    REFERENCES seats(seat_id)    ON DELETE CASCADE
);

-- ================================================
-- DEFAULT ADMIN USER
-- Password: password123 (BCrypt hashed)
-- ================================================
INSERT INTO admins (full_name, email, password, phone, role, is_active)
VALUES (
    'Super Admin',
    'admin@cinebook.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    '9800000001',
    'super_admin',
    TRUE
);
# 🎬 CineBook — Online Movie Ticket Booking System

A full-stack web-based movie booking system built with Java JSP/Servlets, JDBC, and MySQL.

## Tech Stack
- Java JSP & Servlets
- Apache Tomcat 10.1
- MySQL Database
- Maven Build Tool
- eSewa Payment Gateway (Sandbox)
- BCrypt Password Hashing

## Setup Instructions

### 1. Database Setup
- Create database and run `schema.sql` in phpMyAdmin or MySQL Workbench
- Default admin: `admin@cinebook.com` / `password123`

### 2. Project Setup
- Import as Maven project in Eclipse
- Update DB credentials in `DBConnection.java`
- Add Tomcat 10.1 server
- Run on server

## Features
### Customer
- Register & Login
- Browse Movies (Now Showing / Coming Soon)
- Select Seats visually
- Pay via eSewa
- View Booking History
- Cancel Booking (8% fee)
- Update Profile & Password

### Admin
- Manage Movies (Add/Edit/Delete)
- Add Showtimes with auto seat generation
- View All Bookings
- Manage Customers
- Revenue Reports including cancellation fees

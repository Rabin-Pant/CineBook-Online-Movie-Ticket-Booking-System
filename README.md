# 🎬 CineBook — Online Movie Ticket Booking System

<div align="center">

![CineBook Banner](https://img.shields.io/badge/CineBook-Movie%20Booking%20System-e94560?style=for-the-badge&logo=film&logoColor=white)
![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=for-the-badge&logo=mysql&logoColor=white)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1-yellow?style=for-the-badge&logo=apache&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-3.x-red?style=for-the-badge&logo=apachemaven&logoColor=white)

**A full-stack web-based movie ticket booking system built with Java JSP/Servlets, JDBC, and MySQL.**

[Features](#-features) • [Tech Stack](#-tech-stack) • [Setup](#-setup-instructions) • [Payment](#-esewa-payment)

</div>

---

## 📋 Table of Contents

- [About](#-about)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Setup Instructions](#-setup-instructions)
- [Database Schema](#-database-schema)
- [eSewa Payment](#-esewa-payment)
- [Default Credentials](#-default-credentials)
- [Architecture](#-architecture)
- [Security Features](#-security-features)
- [Future Enhancements](#-future-enhancements)

---

## 📖 About

CineBook is a full-stack online movie ticket booking system developed as a college project. It allows customers to browse movies, select showtimes, choose seats interactively, and pay securely via eSewa payment gateway. Administrators can manage movies, showtimes, bookings, and customers through a dedicated admin panel with revenue analytics.

---

## ✨ Features

### 👤 Customer Features
| Feature | Description |
|---|---|
| 🔐 Register & Login | Secure BCrypt password hashing |
| 🎬 Browse Movies | Filter by genre, language, status |
| 🔍 Movie Search | Search by title, genre, language |
| 🕐 View Showtimes | Only future showtimes shown |
| 💺 Seat Selection | Interactive live seat map |
| 💳 eSewa Payment | Secure sandbox payment gateway |
| 🎟️ Booking History | View all past and current bookings |
| ❌ Cancel Booking | 8% cancellation fee, refund within 24hrs |
| 🖨️ Print Ticket | Download booking as PDF ticket |
| 👤 Profile Management | Update name, phone, profile picture |
| 🔑 Change Password | Secure password update |

### 🔧 Admin Features
| Feature | Description |
|---|---|
| 📊 Dashboard | Revenue charts, booking stats |
| 🎬 Manage Movies | Add, edit, delete movies with poster |
| 🕐 Manage Showtimes | Add showtimes with auto seat generation |
| 🎟️ View Bookings | All bookings with payment details |
| 👥 Manage Customers | Block/unblock customer accounts |
| 📈 Revenue Reports | Confirmed revenue + cancellation fees |
| 📉 Charts | Line chart, doughnut chart, bar chart |

---

## 🛠️ Tech Stack

### Backend
- **Java 17** — Core programming language
- **Jakarta Servlets** — HTTP request handling
- **JSP (JavaServer Pages)** — Server-side rendering
- **JDBC** — Database connectivity
- **BCrypt (jBCrypt 0.4)** — Password hashing
- **iText PDF 5.5.13** — PDF ticket generation

### Frontend
- **HTML5 & CSS3** — Structure and styling
- **JavaScript (Vanilla)** — Interactive UI
- **Chart.js 4.4** — Revenue analytics charts
- **Font Awesome 6** — Icons

### Database
- **MySQL** — Relational database
- **XAMPP** — Local MySQL server

### Server & Build
- **Apache Tomcat 10.1** — Web server
- **Maven** — Dependency management
- **Eclipse IDE** — Development environment

### Payment
- **eSewa Sandbox** — Payment gateway integration

---

## 📁 Project Structure

```
CineBook/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/cinebook/
│       │       ├── controller/       ← Servlets (HTTP handlers)
│       │       ├── dao/              ← Database access layer
│       │       ├── service/          ← Business logic layer
│       │       ├── model/            ← POJO classes
│       │       ├── filter/           ← Auth & guest filters
│       │       └── utils/            ← Helper utilities
│       └── webapp/
│           ├── components/           ← Reusable JSP components
│           ├── css/                  ← Stylesheets
│           ├── WEB-INF/
│           │   ├── pages/
│           │   │   ├── customer/     ← Customer JSP pages
│           │   │   └── admin/        ← Admin JSP pages
│           │   ├── lib/              ← Runtime JAR files
│           │   └── web.xml
│           ├── index.jsp
│           ├── customer-login.jsp
│           ├── customer-register.jsp
│           └── admin-login.jsp
├── schema.sql                        ← Database schema
├── pom.xml                           ← Maven dependencies
└── README.md
```

## ⚙️ Setup Instructions

### Prerequisites
- Java JDK 17+
- Apache Tomcat 10.1
- MySQL (via XAMPP or standalone)
- Eclipse IDE for Enterprise Java
- Maven 3.x

### Step 1 — Clone Repository
```bash
git clone https://github.com/Rabin-Pant/CineBook-Online-Movie-Ticket-Booking-System
cd CineBook
```

### Step 2 — Database Setup
1. Start MySQL via XAMPP or MySQL Server
2. Open **phpMyAdmin** or **MySQL Workbench**
3. Create database:

```sql
CREATE DATABASE cinebook;
USE cinebook;
```

4. Import `schema.sql`:
```bash
mysql -u root -p cinebook < schema.sql
```

### Step 3 — Configure Database Connection
Open `src/main/java/com/cinebook/utils/DBConnection.java`:

```java
private static final String URL      = "jdbc:mysql://localhost:3306/cinebook";
private static final String USER     = "root";
private static final String PASSWORD = ""; // your MySQL password
```

### Step 4 — Import Project in Eclipse
1. **File → Import → Maven → Existing Maven Projects**
2. Select the `CineBook` folder
3. Click **Finish**
4. Right click project → **Maven → Update Project**

### Step 5 — Configure Tomcat
1. **Window → Preferences → Server → Runtime Environments**
2. Add **Apache Tomcat 10.1**
3. Right click project → **Run As → Run on Server**

### Step 6 — Access Application
Customer:  http://localhost:8080/CineBook/

Admin:     http://localhost:8080/CineBook/admin/login

---

## 🗄️ Database Schema

### Tables Overview
| Table | Description |
|---|---|
| `admins` | Admin accounts with roles |
| `customers` | Customer accounts with block/unblock |
| `movies` | Movie details with poster upload |
| `showtimes` | Movie schedules per hall |
| `seats` | Auto-generated seats per showtime |
| `bookings` | Booking records with payment info |
| `booking_seats` | Seat-booking mapping |

### Key Relationships
movies ──< showtimes ──< seats
│
customers ──< bookings ──< booking_seats

---

## 💚 eSewa Payment

CineBook uses **eSewa Sandbox** for payment processing.

### Payment Flow

Select Seats
↓
Proceed to Payment
↓
Redirect to eSewa Sandbox
↓
Login with test credentials
↓
Payment Confirmed
↓
Booking Confirmed ✅

### Sandbox Test Credentials
| Field | Value |
|---|---|
| eSewa ID | `9806800001` |
| Password | `Nepal@123` |
| OTP/Token | `123456` |

> ⚠️ Sandbox only — no real money involved

### Cancellation Policy
- 8% cancellation fee deducted
- Remaining 92% refunded to eSewa within 24 hours

---

## 🔑 Default Credentials

### Admin Account
| Field | Value |
|---|---|
| Email | `admin@cinebook.com` |
| Password | `password123` |

### Customer Account
Register at `/customer/register` with any email and password.

---

## 🏗️ Architecture

CineBook follows **MVC (Model-View-Controller)** architecture:

Browser Request
↓
Filter (Auth Check)
↓
Controller (Servlet)
↓
Service (Business Logic)
↓
DAO (Database Query)
↓
MySQL Database
↓
Model (POJO)
↓
JSP View (Response)

---

## 🔒 Security Features

- ✅ BCrypt password hashing
- ✅ Session-based authentication
- ✅ Role-based access control (Admin/Customer)
- ✅ Auth filters on all protected routes
- ✅ Guest filter prevents logged-in access to auth pages
- ✅ SQL injection prevention via PreparedStatements
- ✅ File type validation for uploads
- ✅ Customer block/unblock by admin

---

## 📦 Dependencies

### Runtime JARs (in WEB-INF/lib)
```
itextpdf-5.5.13.3.jar
mysql-connector-j-8.3.0.jar
jakarta.servlet.jsp.jstl-3.0.1.jar
jakarta.servlet.jsp.jstl-api-3.0.0.jar
jbcrypt-0.4.jar
```

### Maven Dependencies (pom.xml)
```xml
<!-- Servlet API — provided by Tomcat -->
jakarta.servlet:jakarta.servlet-api:6.0.0

<!-- JSP API — provided by Tomcat -->
jakarta.servlet.jsp:jakarta.servlet.jsp-api:3.1.0

<!-- JSTL -->
jakarta.servlet.jsp.jstl:jakarta.servlet.jsp.jstl-api:3.0.0
org.glassfish.web:jakarta.servlet.jsp.jstl:3.0.1

<!-- MySQL Connector -->
com.mysql:mysql-connector-j:8.3.0

<!-- BCrypt -->
org.mindrot:jbcrypt:0.4

<!-- iText PDF -->
com.itextpdf:itextpdf:5.5.13.3
```

---

## 🚀 Future Enhancements

- [ ] Email notifications for booking confirmation
- [ ] QR code ticket generation
- [ ] Mobile application (Android/iOS)
- [ ] Real eSewa/Khalti payment integration
- [ ] Movie trailer YouTube embed
- [ ] Movie ratings and reviews by customers
- [ ] Promo/discount code system
- [ ] Export reports to Excel/PDF
- [ ] Multi-language support (Nepali/English)
- [ ] AI-based movie recommendations

---

## 👨‍💻 Developer

**Rabin Pant**
- 📧 rabinpant194@gmail.com
- 🌐 GitHub: [Rabin Pant](https://github.com/Rabin-Pant)

---

## 📄 License

This project is developed for educational purposes.

---

<div align="center">
Made with ❤️ by Rabin Pant
</div>

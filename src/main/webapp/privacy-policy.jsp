<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Privacy Policy" />
<c:set var="extraCSS" value="auth.css" />

<%@ include file="components/header.jsp" %>
<%@ include file="components/navbar.jsp" %>

<style>
    .policy-wrapper {
        max-width: 860px;
        margin: 3rem auto;
        padding: 0 1.5rem 4rem;
    }
    .policy-hero {
        text-align: center;
        margin-bottom: 2.5rem;
    }
    .policy-hero h1 {
        font-size: 2.2rem;
        font-weight: 700;
        color: #ffffff;
        margin-bottom: 0.5rem;
    }
    .policy-hero h1 span {
        color: #e94560;
    }
    .policy-hero p {
        color: #aaa;
        font-size: 0.95rem;
    }
    .policy-card {
        background: #16213e;
        border-radius: 16px;
        padding: 2.5rem;
        margin-bottom: 1.5rem;
        border: 1px solid rgba(233,69,96,0.12);
    }
    .policy-card h2 {
        font-size: 1.15rem;
        font-weight: 600;
        color: #e94560;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .policy-card p, .policy-card li {
        color: #ccc;
        font-size: 0.92rem;
        line-height: 1.8;
    }
    .policy-card ul {
        padding-left: 1.25rem;
        margin-top: 0.5rem;
    }
    .policy-card li {
        margin-bottom: 0.4rem;
    }
    .policy-back {
        text-align: center;
        margin-top: 2rem;
    }
    .policy-back a {
        color: #e94560;
        text-decoration: none;
        font-weight: 500;
        font-size: 0.95rem;
    }
    .policy-back a:hover { text-decoration: underline; }
    .last-updated {
        text-align: center;
        color: #666;
        font-size: 0.8rem;
        margin-bottom: 2rem;
    }
</style>

<div class="policy-wrapper">
    <div class="policy-hero">
        <h1><i class="fas fa-shield-alt"></i> Privacy <span>Policy</span></h1>
        <p>Your privacy matters to us. Here's how we handle your data.</p>
    </div>
    <p class="last-updated">Last updated: May 2026</p>

    <div class="policy-card">
        <h2><i class="fas fa-info-circle"></i> 1. Information We Collect</h2>
        <p>When you register and use CineBook, we collect the following information:</p>
        <ul>
            <li>Full name, email address, and phone number (provided during registration)</li>
            <li>Booking history including movies, showtimes, seats, and payment records</li>
            <li>Profile picture (if you choose to upload one)</li>
            <li>Login activity and IP address for security purposes</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-cogs"></i> 2. How We Use Your Information</h2>
        <p>We use your information solely to provide and improve CineBook services:</p>
        <ul>
            <li>To process and confirm your movie ticket bookings</li>
            <li>To send booking confirmations and important account notifications</li>
            <li>To manage your account and provide customer support</li>
            <li>To prevent fraud and ensure platform security</li>
            <li>To improve our services based on usage patterns</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-share-alt"></i> 3. Information Sharing</h2>
        <p>We do <strong style="color:#fff;">not</strong> sell, trade, or rent your personal information to third parties. Your data may only be shared in the following limited circumstances:</p>
        <ul>
            <li>With payment processors (eSewa/Khalti) solely to complete your transactions</li>
            <li>When required by law or valid legal process</li>
            <li>To protect the rights and safety of CineBook and its users</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-lock"></i> 4. Data Security</h2>
        <p>We take the security of your data seriously:</p>
        <ul>
            <li>Passwords are stored using BCrypt hashing — never in plain text</li>
            <li>All sensitive data is transmitted over secure connections</li>
            <li>Access to personal data is restricted to authorized personnel only</li>
            <li>We regularly review our security practices to protect your information</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-user-cog"></i> 5. Your Rights</h2>
        <p>You have full control over your personal data:</p>
        <ul>
            <li>Access and update your profile information at any time from your account</li>
            <li>Request deletion of your account and associated data</li>
            <li>Contact us to correct any inaccurate information</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-cookie-bite"></i> 6. Cookies & Sessions</h2>
        <p>CineBook uses session cookies to keep you logged in during your visit. These cookies are temporary and are removed when you log out or close your browser. We do not use tracking or advertising cookies.</p>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-envelope"></i> 7. Contact Us</h2>
        <p>If you have any questions or concerns about this Privacy Policy, please reach out to us through our <a href="${pageContext.request.contextPath}/contact" style="color:#e94560;">Contact page</a> or email us at <a href="mailto:support@cinebook.com" style="color:#e94560;">support@cinebook.com</a>.</p>
    </div>

    <div class="policy-back">
        <a href="${pageContext.request.contextPath}/customer/register">
            <i class="fas fa-arrow-left"></i> Back to Register
        </a>
        &nbsp;&nbsp;|&nbsp;&nbsp;
        <a href="${pageContext.request.contextPath}/">
            <i class="fas fa-home"></i> Back to Home
        </a>
    </div>
</div>

<%@ include file="components/footer.jsp" %>

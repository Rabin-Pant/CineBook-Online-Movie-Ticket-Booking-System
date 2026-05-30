<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Terms of Service" />
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
        <h1><i class="fas fa-file-contract"></i> Terms of <span>Service</span></h1>
        <p>Please read these terms carefully before using CineBook.</p>
    </div>
    <p class="last-updated">Last updated: May 2026</p>

    <div class="policy-card">
        <h2><i class="fas fa-handshake"></i> 1. Acceptance of Terms</h2>
        <p>By creating an account and using CineBook, you confirm that you have read, understood, and agree to be bound by these Terms of Service. If you do not agree, please do not use our platform.</p>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-user-check"></i> 2. Account Eligibility</h2>
        <p>To use CineBook you must:</p>
        <ul>
            <li>Provide accurate and truthful registration information</li>
            <li>Maintain a single account — multiple accounts per person are not allowed</li>
            <li>Keep your login credentials confidential and not share them with others</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-ticket-alt"></i> 3. Booking & Payments</h2>
        <ul>
            <li>All bookings are subject to seat availability at the time of purchase</li>
            <li>Ticket prices are set by CineBook and may vary by movie, showtime, and hall</li>
            <li>Payments are processed securely through eSewa or Khalti</li>
            <li>A booking confirmation will be issued upon successful payment</li>
            <li>CineBook reserves the right to cancel bookings in cases of technical error or fraud</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-undo-alt"></i> 4. Cancellation & Refund Policy</h2>
        <ul>
            <li>Bookings may be cancelled before the showtime begins</li>
            <li>A cancellation fee of <strong style="color:#fff;">8%</strong> of the total booking amount will be deducted</li>
            <li>The remaining amount will be refunded to your original payment method</li>
            <li>No refunds will be issued after the showtime has started</li>
            <li>CineBook is not responsible for refunds on payments made outside our platform</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-ban"></i> 5. Prohibited Conduct</h2>
        <p>You agree not to:</p>
        <ul>
            <li>Use CineBook for any unlawful purpose</li>
            <li>Attempt to gain unauthorized access to any part of our system</li>
            <li>Resell or transfer tickets purchased on CineBook</li>
            <li>Submit false, misleading, or fraudulent information</li>
            <li>Interfere with the proper functioning of the platform</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-exclamation-triangle"></i> 6. Limitation of Liability</h2>
        <p>CineBook is not liable for:</p>
        <ul>
            <li>Show cancellations or changes made by the cinema management</li>
            <li>Technical issues beyond our reasonable control (internet outages, payment gateway failures)</li>
            <li>Any indirect or consequential losses arising from use of our platform</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-edit"></i> 7. Changes to Terms</h2>
        <p>CineBook reserves the right to update these Terms of Service at any time. Continued use of the platform after changes are posted constitutes your acceptance of the new terms. We encourage you to review this page periodically.</p>
    </div>

    <div class="policy-card">
        <h2><i class="fas fa-envelope"></i> 8. Contact Us</h2>
        <p>For any questions about these Terms, please contact us via our <a href="${pageContext.request.contextPath}/contact" style="color:#e94560;">Contact page</a> or email <a href="mailto:support@cinebook.com" style="color:#e94560;">support@cinebook.com</a>.</p>
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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Booking Cancelled" />
<c:set var="extraCSS" value="booking-confirmation.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="container">
    <div class="confirmation-wrapper">

        <div class="confirmation-icon">✅</div>
        <h1>Booking Cancelled</h1>
        <p class="confirmation-subtitle">
            Your booking has been cancelled successfully.
        </p>

        <div class="ticket-card">
            <div class="ticket-header">
                <h2>🎬 ${booking.movieTitle}</h2>
                <span class="booking-id">Booking #${booking.bookingId}</span>
            </div>

            <div class="ticket-details">
                <div class="ticket-row">
                    <span class="label">💰 Amount Paid</span>
                    <span class="value">Rs. ${booking.totalAmount}</span>
                </div>
                <div class="ticket-row">
                    <span class="label">🔻 Cancellation Fee (8%)</span>
                    <span class="value" style="color:#e94560;">
                        - Rs. <fmt:formatNumber value="${booking.totalAmount * 0.08}"
                                               pattern="#,##0.00"/>
                    </span>
                </div>
                <div class="ticket-row total">
                    <span class="label">💚 Refund Amount</span>
                    <span class="value" style="color:green;">
                        Rs. ${booking.refundAmount}
                    </span>
                </div>
                <div class="ticket-row">
                    <span class="label">📋 Refund Status</span>
                    <span class="badge badge-warning">Pending</span>
                </div>
            </div>

            <div class="ticket-footer">
                💚 Rs. ${booking.refundAmount} will be credited to your
                eSewa wallet within <strong>24 hours</strong>
            </div>
        </div>

        <div class="confirmation-actions">
            <a href="${pageContext.request.contextPath}/customer/bookings"
               class="btn btn-primary">My Bookings</a>
            <a href="${pageContext.request.contextPath}/customer/movies"
               class="btn btn-secondary">Browse Movies</a>
        </div>

    </div>
</div>

<%@ include file="/components/footer.jsp" %>
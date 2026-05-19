<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Cancel Booking" />
<c:set var="extraCSS" value="booking-confirmation.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="container">
    <div class="confirmation-wrapper">

        <div class="confirmation-icon">⚠️</div>
        <h1 style="color:#e94560;">Cancel Booking?</h1>
        <p class="confirmation-subtitle">
            Please review the cancellation policy before proceeding.
        </p>

        <div class="ticket-card">
            <div class="ticket-header">
                <h2>🎬 ${booking.movieTitle}</h2>
                <span class="booking-id">Booking #${booking.bookingId}</span>
            </div>

            <div class="ticket-details">
                <div class="ticket-row">
                    <span class="label">📅 Show Date</span>
                    <span class="value">${booking.showDate}</span>
                </div>
                <div class="ticket-row">
                    <span class="label">💺 Seats</span>
                    <span class="value">${booking.seatNumbers}</span>
                </div>
                <div class="ticket-row">
                    <span class="label">💰 Amount Paid</span>
                    <span class="value">Rs. ${booking.totalAmount}</span>
                </div>

                <hr style="border-color:#eee; margin:8px 0;">

                <div class="ticket-row">
                    <span class="label">🔻 Cancellation Fee (8%)</span>
                    <span class="value" style="color:#e94560;">
                        - Rs. ${cancellationFee}
                    </span>
                </div>
                <div class="ticket-row total">
                    <span class="label">💚 Refund to eSewa</span>
                    <span class="value" style="color:green;">
                        Rs. ${refundAmount}
                    </span>
                </div>
            </div>

            <div class="ticket-footer">
                ⏱ Refund will be credited to your eSewa wallet within 24 hours
            </div>
        </div>

        <!-- Confirm Cancellation Form -->
        <form action="${pageContext.request.contextPath}/customer/cancel-booking"
              method="post">
            <input type="hidden" name="bookingId" value="${booking.bookingId}" />
            <div class="confirmation-actions">
                <button type="submit" class="btn btn-primary"
                        style="background:#e94560;">
                    Yes, Cancel Booking
                </button>
                <a href="${pageContext.request.contextPath}/customer/bookings"
                   class="btn btn-secondary">
                    No, Keep Booking
                </a>
            </div>
        </form>

    </div>
</div>

<%@ include file="/components/footer.jsp" %>
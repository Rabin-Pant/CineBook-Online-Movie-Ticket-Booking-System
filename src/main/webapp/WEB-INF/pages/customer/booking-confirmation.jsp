<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Booking Confirmed!" />
<c:set var="extraCSS" value="booking-confirmation.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="container">
    <div class="confirmation-wrapper">

        <div class="confirmation-icon">✅</div>
        <h1>Booking Confirmed!</h1>
        <p class="confirmation-subtitle">Your tickets have been booked successfully.</p>

        <div class="ticket-card">
            <div class="ticket-header">
                <h2>🎬 ${booking.movieTitle}</h2>
                <span class="booking-id">Booking #${booking.bookingId}</span>
            </div>

            <div class="ticket-details">
                <div class="ticket-row">
                    <span class="label">📅 Date</span>
                    <span class="value">${booking.showDate}</span>
                </div>
                <div class="ticket-row">
                    <span class="label">🕐 Time</span>
                    <span class="value">${booking.showTime}</span>
                </div>
                <div class="ticket-row">
                    <span class="label">🎭 Hall</span>
                    <span class="value">${booking.hall}</span>
                </div>
                <div class="ticket-row">
                    <span class="label">💺 Seats</span>
                    <span class="value">${booking.seatNumbers}</span>
                </div>
                <div class="ticket-row total">
                    <span class="label">💰 Total Paid</span>
                    <span class="value">Rs. ${booking.totalAmount}</span>
                </div>
                <div class="ticket-row">
                    <span class="label">📋 Status</span>
                    <span class="badge badge-success">${booking.bookingStatus}</span>
                </div>
            </div>

            <div class="ticket-footer">
                <p>Booked on: ${booking.bookedAt}</p>
            </div>
        </div>

        <div class="confirmation-actions">
    <a href="${pageContext.request.contextPath}/customer/print-ticket?bookingId=${booking.bookingId}"
       class="btn btn-primary">
        🖨️ Download Ticket PDF
    </a>
    <a href="${pageContext.request.contextPath}/customer/bookings"
       class="btn btn-secondary">My Bookings</a>
    <a href="${pageContext.request.contextPath}/customer/movies"
       class="btn btn-secondary">Browse More Movies</a>
</div>

    </div>
</div>

<%@ include file="/components/footer.jsp" %>
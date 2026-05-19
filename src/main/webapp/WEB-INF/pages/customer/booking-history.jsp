<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="My Bookings" />
<c:set var="extraCSS" value="customer-dashboard.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="container">

    <h1 class="page-title">🎟 My Bookings</h1>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">${param.success}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-error">${param.error}</div>
    </c:if>

    <div class="section-card">
        <c:choose>
            <c:when test="${not empty bookings}">
                <div class="table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Movie</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Hall</th>
                                <th>Seats</th>
                                <th>Amount</th>
                                <th>Payment</th>
                                <th>Status</th>
                                <th>Refund</th>
                                <th>Ticket</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookings}">
                               <tr>
    <td>#${booking.bookingId}</td>
    <td><strong>${booking.movieTitle}</strong></td>
    <td>${booking.showDate}</td>
    <td>${booking.showTime}</td>
    <td>${booking.hall}</td>
    <td>${booking.seatNumbers}</td>
    <td>Rs. ${booking.totalAmount}</td>
    <td>
        <c:choose>
            <c:when test="${not empty booking.paymentMethod}">
                <span class="badge badge-success">
                    ${booking.paymentMethod}
                </span>
            </c:when>
            <c:otherwise>
                <span class="badge badge-warning">N/A</span>
            </c:otherwise>
        </c:choose>
    </td>
    <td>
        <span class="badge ${booking.bookingStatus == 'confirmed' ? 'badge-success' : 'badge-danger'}">
            ${booking.bookingStatus}
        </span>
    </td>
    <td>
        <c:choose>
            <c:when test="${booking.bookingStatus == 'cancelled' && not empty booking.refundAmount}">
                <span style="color:green; font-size:0.82rem;">
                    💚 Rs. ${booking.refundAmount}
                    <br/>
                    <small style="color:#888;">within 24hrs</small>
                </span>
            </c:when>
            <c:otherwise>
                <span style="color:#aaa; font-size:0.82rem;">-</span>
            </c:otherwise>
        </c:choose>
    </td>

    <%-- ✅ Ticket column — Print only --%>
    <td>
        <c:if test="${booking.bookingStatus == 'confirmed'}">
            <a href="${pageContext.request.contextPath}/customer/print-ticket?bookingId=${booking.bookingId}"
               class="btn-action btn-edit"
               title="Download PDF Ticket">
                 Print
            </a>
        </c:if>
        <c:if test="${booking.bookingStatus == 'cancelled'}">
            <span style="color:#aaa; font-size:0.82rem;">-</span>
        </c:if>
    </td>

    <%-- ✅ Action column — Cancel only --%>
    <td>
        <c:if test="${booking.bookingStatus == 'confirmed'}">
            <a href="${pageContext.request.contextPath}/customer/cancel-booking?bookingId=${booking.bookingId}"
               class="btn-action btn-delete"
               title="Cancel Booking">
                 Cancel
            </a>
        </c:if>
        <c:if test="${booking.bookingStatus == 'cancelled'}">
            <span style="color:#aaa; font-size:0.82rem;">Cancelled</span>
        </c:if>
    </td>
</tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <p>🎟 You have no bookings yet.</p>
                    <a href="${pageContext.request.contextPath}/customer/movies"
                       class="btn btn-primary">Book Now</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<%@ include file="/components/footer.jsp" %>
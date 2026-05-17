<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Manage Bookings" />
<c:set var="extraCSS" value="admin.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/admin-navbar.jsp" %>

<div class="admin-wrapper">

    <%@ include file="/components/admin-sidebar.jsp" %>

    <main class="admin-main">

        <div class="admin-topbar">
            <h2>Manage Bookings</h2>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <div class="admin-card">
            <div class="admin-card-header">
                <h3>All Bookings (${not empty bookings ? bookings.size() : 0})</h3>
            </div>

            <c:choose>
                <c:when test="${not empty bookings}">
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Customer</th>
                                    <th>Movie</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Hall</th>
                                    <th>Seats</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <td>#${booking.bookingId}</td>
                                        <td>${booking.customerName}</td>
                                        <td>${booking.movieTitle}</td>
                                        <td>${booking.showDate}</td>
                                        <td>${booking.showTime}</td>
                                        <td>${booking.hall}</td>
                                        <td>${booking.seatNumbers}</td>
                                        <td>Rs. ${booking.totalAmount}</td>
                                        <td>
                                            <span class="badge ${booking.bookingStatus == 'confirmed' ? 'badge-success' : 'badge-danger'}">
                                                ${booking.bookingStatus}
                                            </span>
                                        </td>
                                       
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state"><p>No bookings found.</p></div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</div>

<%@ include file="/components/footer.jsp" %>
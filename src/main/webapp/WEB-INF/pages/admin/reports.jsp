<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Reports" />
<c:set var="extraCSS" value="admin.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/admin-navbar.jsp" %>

<div class="admin-wrapper">

    <%@ include file="/components/admin-sidebar.jsp" %>

    <main class="admin-main">

        <div class="admin-topbar">
            <h2>📈 Reports</h2>
        </div>

        <!-- ===== SUMMARY STATS ===== -->
        <div class="admin-stats">
            <div class="admin-stat-card highlight">
                <div class="stat-icon-admin">💰</div>
                <div class="stat-details">
                    <h3>Rs. ${totalActualRevenue}</h3>
                    <p>Total Actual Revenue</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon-admin">🎟</div>
                <div class="stat-details">
                    <h3>${totalBookings}</h3>
                    <p>Confirmed Bookings</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon-admin">✂️</div>
                <div class="stat-details">
                    <h3>Rs. ${cancellationFeeRevenue}</h3>
                    <p>Cancellation Fees</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon-admin">👥</div>
                <div class="stat-details">
                    <h3>${totalCustomers}</h3>
                    <p>Total Customers</p>
                </div>
            </div>
        </div>

        <!-- ===== REVENUE BREAKDOWN ===== -->
<div class="admin-card" style="margin-bottom:24px;">
    <div class="admin-card-header">
        <h3>Revenue Breakdown</h3>
    </div>
    <div class="table-wrapper">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Source</th>
                    <th>Amount</th>
                    <th>Note</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>✅ Confirmed Bookings</td>
                    <td><strong>Rs. ${totalRevenue}</strong></td>
                    <td style="color:#888; font-size:0.85rem;">
                        Full ticket amount
                    </td>
                </tr>
                <tr>
                    <td>✂️ Cancellation Fees</td>
                    <td><strong style="color:#e94560;">
                        Rs. ${cancellationFeeRevenue}
                    </strong></td>
                    <td style="color:#888; font-size:0.85rem;">
                        8% of cancelled bookings
                    </td>
                </tr>
                <tr style="background:#f8f9fa;">
                    <td><strong>💰 Total Actual Revenue</strong></td>
                    <td><strong style="color:#e94560; font-size:1.1rem;">
                        Rs. ${totalActualRevenue}
                    </strong></td>
                    <td style="color:#888; font-size:0.85rem;">
                        Confirmed + Cancellation fees
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

        <!-- ===== ALL BOOKINGS ===== -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h3>All Bookings Report
                    (${not empty bookings ? bookings.size() : 0})
                </h3>
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
                                    <th>Seats</th>
                                    <th>Amount</th>
                                    <th>Cancellation Fee</th>
                                    <th>Refund</th>
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
                                        <td>${booking.seatNumbers}</td>
                                        <td>Rs. ${booking.totalAmount}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty booking.cancellationFee}">
                                                    <span style="color:#e94560;">
                                                        Rs. ${booking.cancellationFee}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty booking.refundAmount}">
                                                    <span style="color:green;">
                                                        Rs. ${booking.refundAmount}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
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
                    <div class="empty-state">
                        <p>No bookings data available.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</div>

<%@ include file="/components/footer.jsp" %>
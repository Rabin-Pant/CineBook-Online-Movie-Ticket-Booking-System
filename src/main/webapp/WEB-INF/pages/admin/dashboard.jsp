<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Admin Dashboard" />
<c:set var="extraCSS" value="admin.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/admin-navbar.jsp" %>

<div class="admin-wrapper">

    <%@ include file="/components/admin-sidebar.jsp" %>

    <main class="admin-main">

        <!-- Top Bar -->
        <div class="admin-topbar">
            <h2>Dashboard</h2>
            <span style="color:#888; font-size:0.9rem;">
                Welcome back, <strong>${sessionScope.loggedInAdmin.fullName}</strong> 👋
            </span>
        </div>

        <!-- ===== STATS ROW 1 ===== -->
        <div class="admin-stats">
            <div class="admin-stat-card highlight">
                <div class="stat-icon-admin">💰</div>
                <div class="stat-details">
                    <h3>Rs. ${stats.totalRevenue}</h3>
                    <p>Total Revenue</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon-admin">🎟</div>
                <div class="stat-details">
                    <h3>${stats.totalBookings}</h3>
                    <p>Total Bookings</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon-admin">👥</div>
                <div class="stat-details">
                    <h3>${stats.totalCustomers}</h3>
                    <p>Total Customers</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon-admin">✂️</div>
                <div class="stat-details">
                    <h3>Rs. ${stats.cancellationFeeRevenue}</h3>
                    <p>Cancellation Fees</p>
                </div>
            </div>
        </div>

        <!-- ===== STATS ROW 2 ===== -->
        <div class="admin-stats" style="margin-top:0;">
            <div class="admin-stat-card">
                <div class="stat-icon-admin">🎬</div>
                <div class="stat-details">
                    <h3>${stats.totalMovies}</h3>
                    <p>Total Movies</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon-admin">▶️</div>
                <div class="stat-details">
                    <h3>${stats.nowShowingCount}</h3>
                    <p>Now Showing</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon-admin">🕐</div>
                <div class="stat-details">
                    <h3>${stats.comingSoonCount}</h3>
                    <p>Coming Soon</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon-admin">👤</div>
                <div class="stat-details">
                    <h3>${stats.totalCustomers}</h3>
                    <p>Registered Users</p>
                </div>
            </div>
        </div>

        <!-- ===== CHARTS ROW ===== -->
        <div class="charts-row">

            <!-- Revenue Line Chart -->
            <div class="admin-card chart-card">
                <div class="admin-card-header">
                    <h3>📈 Revenue Last 7 Days</h3>
                </div>
                <canvas id="revenueChart" height="120"></canvas>
            </div>

            <!-- Booking Status Doughnut -->
            <div class="admin-card chart-card">
                <div class="admin-card-header">
                    <h3>🎟 Booking Status</h3>
                </div>
                <canvas id="statusChart" height="120"></canvas>
            </div>

        </div>

        <!-- Top Movies Bar Chart -->
        <div class="admin-card" style="margin-bottom:24px;">
            <div class="admin-card-header">
                <h3>🎬 Top 5 Most Booked Movies</h3>
            </div>
            <canvas id="moviesChart" height="80"></canvas>
        </div>

        <!-- ===== RECENT BOOKINGS TABLE ===== -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h3>Recent Bookings</h3>
                <a href="${pageContext.request.contextPath}/admin/bookings"
                   class="btn btn-secondary">View All</a>
            </div>

            <c:choose>
                <c:when test="${not empty stats.recentBookings}">
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Customer</th>
                                    <th>Movie</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Payment</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${stats.recentBookings}">
                                    <tr>
                                        <td>#${booking.bookingId}</td>
                                        <td>${booking.customerName}</td>
                                        <td>${booking.movieTitle}</td>
                                        <td>${booking.showDate}</td>
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
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>No bookings yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<script>
    // ===== REVENUE LINE CHART =====
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');

    const days = [<c:forEach var="day" items="${stats.chartDays}" varStatus="s">'${day}'<c:if test="${!s.last}">,</c:if></c:forEach>];
    const revenues = [<c:forEach var="rev" items="${stats.chartRevenues}" varStatus="s">${rev}<c:if test="${!s.last}">,</c:if></c:forEach>];

    new Chart(revenueCtx, {
        type: 'line',
        data: {
            labels: days,
            datasets: [{
                label: 'Revenue (Rs.)',
                data: revenues,
                borderColor: '#e94560',
                backgroundColor: 'rgba(233,69,96,0.08)',
                borderWidth: 2.5,
                pointBackgroundColor: '#e94560',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 5,
                pointHoverRadius: 7,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#1a1a2e',
                    titleColor: '#fff',
                    bodyColor: '#ccc',
                    callbacks: {
                        label: ctx => ' Rs. ' + ctx.parsed.y.toFixed(2)
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: { color: 'rgba(0,0,0,0.05)' },
                    ticks: {
                        callback: val => 'Rs. ' + val,
                        font: { size: 11 }
                    }
                },
                x: {
                    grid: { display: false },
                    ticks: { font: { size: 11 } }
                }
            }
        }
    });

    // ===== BOOKING STATUS DOUGHNUT =====
    const statusCtx = document.getElementById('statusChart').getContext('2d');

    const confirmedCount = ${stats.bookingsByStatus != null && stats.bookingsByStatus.containsKey('confirmed') ? stats.bookingsByStatus.get('confirmed') : 0};
    const cancelledCount = ${stats.bookingsByStatus != null && stats.bookingsByStatus.containsKey('cancelled') ? stats.bookingsByStatus.get('cancelled') : 0};

    new Chart(statusCtx, {
        type: 'doughnut',
        data: {
            labels: ['Confirmed', 'Cancelled'],
            datasets: [{
                data: [confirmedCount, cancelledCount],
                backgroundColor: ['#28a745', '#e94560'],
                borderWidth: 0,
                hoverOffset: 8
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 16,
                        font: { size: 12 },
                        usePointStyle: true
                    }
                },
                tooltip: {
                    backgroundColor: '#1a1a2e',
                    titleColor: '#fff',
                    bodyColor: '#ccc'
                }
            },
            cutout: '65%'
        }
    });

    // ===== TOP MOVIES BAR CHART =====
    const moviesCtx = document.getElementById('moviesChart').getContext('2d');

    const movieLabels = [<c:forEach var="entry" items="${stats.bookingsByMovie}" varStatus="s">'${entry.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
    const movieCounts = [<c:forEach var="entry" items="${stats.bookingsByMovie}" varStatus="s">${entry.value}<c:if test="${!s.last}">,</c:if></c:forEach>];

    new Chart(moviesCtx, {
        type: 'bar',
        data: {
            labels: movieLabels.length > 0 ? movieLabels : ['No Data'],
            datasets: [{
                label: 'Bookings',
                data: movieCounts.length > 0 ? movieCounts : [0],
                backgroundColor: [
                    'rgba(233,69,96,0.85)',
                    'rgba(15,52,96,0.85)',
                    'rgba(26,26,46,0.85)',
                    'rgba(255,107,107,0.85)',
                    'rgba(40,167,69,0.85)'
                ],
                borderRadius: 8,
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#1a1a2e',
                    titleColor: '#fff',
                    bodyColor: '#ccc',
                    callbacks: {
                        label: ctx => ' ' + ctx.parsed.y + ' bookings'
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1,
                        font: { size: 11 }
                    },
                    grid: { color: 'rgba(0,0,0,0.05)' }
                },
                x: {
                    grid: { display: false },
                    ticks: { font: { size: 11 } }
                }
            }
        }
    });
</script>

<%@ include file="/components/footer.jsp" %>
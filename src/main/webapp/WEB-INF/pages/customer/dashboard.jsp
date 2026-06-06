<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="My Dashboard" />
<c:set var="extraCSS" value="dashboard.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<script src="https://unpkg.com/feather-icons"></script>

<style>
    /* ===== BASE SETTINGS & VARIABLES ===== */
    :root {
        --color-navy: #1a1a2e;
        --color-navy-light: #16213e;
        --color-ruby: #e94560;
        --color-ruby-dark: #c73e56;
        --bg-main: #f4f7fb;
        --shadow-soft: 0 10px 30px -10px rgba(0, 0, 0, 0.08);
        --shadow-3d: 0 20px 40px -10px rgba(233, 69, 96, 0.15), 0 10px 20px -5px rgba(26, 26, 46, 0.1);
    }

    body {
        background-color: var(--bg-main);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }

    .container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 30px;
        min-height: calc(100vh - 70px);
        perspective: 1200px; /* Establishes 3D space */
    }
    
    /* ===== WELCOME BANNER (3D Floating Parallax) ===== */
    .welcome-banner {
        background: linear-gradient(135deg, var(--color-navy) 0%, var(--color-navy-light) 50%, #0f3460 100%);
        color: #fff;
        border-radius: 24px;
        padding: 40px 50px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 40px;
        animation: slideInLeft 0.8s cubic-bezier(0.165, 0.84, 0.44, 1);
        position: relative;
        overflow: hidden;
        box-shadow: 0 15px 35px -10px rgba(15, 52, 96, 0.4);
        transform-style: preserve-3d;
        transition: transform 0.5s ease;
    }

    .welcome-banner:hover {
        transform: translateY(-5px) rotateX(2deg);
    }
    
    .welcome-banner::before {
        content: '';
        position: absolute;
        right: -100px;
        bottom: -100px;
        width: 400px;
        height: 400px;
        background: radial-gradient(circle, rgba(233,69,96,0.15) 0%, transparent 70%);
        border-radius: 50%;
        pointer-events: none;
    }
    
    @keyframes slideInLeft {
        from { opacity: 0; transform: translateX(-40px) translateZ(-100px); }
        to { opacity: 1; transform: translateX(0) translateZ(0); }
    }
    
    .welcome-text h2 {
        font-size: 2rem;
        font-weight: 800;
        margin-bottom: 12px;
        background: linear-gradient(135deg, #ffffff, #f0f0f0);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        letter-spacing: -0.5px;
    }
    
    .welcome-text p {
        color: #a0aabf;
        font-size: 1.05rem;
        font-weight: 400;
    }
    
    /* ===== 3D STATS ROW ===== */
    .stats-row {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 25px;
        margin-bottom: 40px;
    }
    
    .stat-card {
        background: #fff;
        border-radius: 20px;
        padding: 25px;
        display: flex;
        align-items: center;
        gap: 20px;
        box-shadow: var(--shadow-soft);
        border: 1px solid rgba(26, 26, 46, 0.03);
        /* 3D Properties */
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        transform-style: preserve-3d;
        animation: fadeInUp 0.6s ease-out both;
    }
    
    .stat-card:nth-child(1) { animation-delay: 0.1s; }
    .stat-card:nth-child(2) { animation-delay: 0.2s; }
    .stat-card:nth-child(3) { animation-delay: 0.3s; }
    .stat-card:nth-child(4) { animation-delay: 0.4s; }
    
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(30px) translateZ(-50px); }
        to { opacity: 1; transform: translateY(0) translateZ(0); }
    }
    
    .stat-card:hover {
        transform: translateY(-10px) rotateX(5deg) rotateY(-5deg);
        box-shadow: var(--shadow-3d);
        border-color: rgba(233,69,96,0.1);
    }
    
    .stat-icon {
        width: 55px;
        height: 55px;
        border-radius: 14px;
        background: linear-gradient(135deg, rgba(233,69,96,0.1), rgba(26,26,46,0.05));
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--color-ruby);
        transition: transform 0.4s ease;
        transform: translateZ(20px); /* Pops out in 3D */
    }
    
    .stat-card:hover .stat-icon {
        transform: translateZ(30px) scale(1.1) rotate(10deg);
        background: var(--color-ruby);
        color: #fff;
        box-shadow: 0 10px 20px rgba(233,69,96,0.3);
    }
    
    .stat-info {
        transform: translateZ(10px);
    }

    .stat-info h3 {
        font-size: 2.2rem;
        font-weight: 800;
        color: var(--color-navy);
        margin-bottom: 2px;
        line-height: 1;
    }
    
    .stat-info p {
        color: #64748b;
        font-size: 0.85rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    /* ===== 3D SECTION CARDS ===== */
    .section-card {
        background: #fff;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 40px;
        box-shadow: var(--shadow-soft);
        border: 1px solid rgba(0,0,0,0.03);
        animation: fadeIn 0.8s ease-out 0.4s both;
        transform-style: preserve-3d;
        transition: transform 0.4s ease, box-shadow 0.4s ease;
    }
    
    .section-card:hover {
        box-shadow: 0 20px 40px rgba(0,0,0,0.06);
    }
    
    .section-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        padding-bottom: 20px;
        border-bottom: 1px solid #f1f5f9;
    }
    
    .section-card-header h3 {
        font-size: 1.25rem;
        font-weight: 700;
        color: var(--color-navy);
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .section-card-header h3 svg {
        color: var(--color-ruby);
    }
    
    /* ===== 3D MOVIES GRID ===== */
    .movies-grid-small {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
        gap: 25px;
    }
    
    .movie-card-small {
        display: flex;
        gap: 20px;
        align-items: center;
        background: #fff;
        border-radius: 20px;
        padding: 18px;
        transition: all 0.4s ease;
        cursor: pointer;
        border: 1px solid #f1f5f9;
        transform-style: preserve-3d;
        perspective: 1000px;
    }
    
    .movie-card-small:hover {
        transform: translateY(-5px) translateZ(10px);
        box-shadow: var(--shadow-3d);
        border-color: rgba(233,69,96,0.15);
    }
    
    .movie-poster-small {
        width: 85px;
        height: 120px;
        border-radius: 12px;
        background: linear-gradient(135deg, var(--color-navy), var(--color-navy-light));
        flex-shrink: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        transition: transform 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.5s ease;
        transform: translateZ(0);
    }
    
    .movie-card-small:hover .movie-poster-small {
        transform: translateZ(30px) rotateY(12deg) scale(1.05);
        box-shadow: -15px 15px 25px rgba(26,26,46,0.2);
    }
    
    .movie-poster-small img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    .no-poster-small {
        color: #fff;
        opacity: 0.5;
    }
    
    .movie-card-small-info {
        flex: 1;
        transform: translateZ(10px);
    }
    
    .movie-card-small-info h4 {
        font-size: 1.1rem;
        font-weight: 700;
        color: var(--color-navy);
        margin-bottom: 8px;
        transition: color 0.3s ease;
    }
    
    .movie-card-small:hover .movie-card-small-info h4 {
        color: var(--color-ruby);
    }
    
    .movie-card-small-info p {
        font-size: 0.8rem;
        color: #64748b;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 12px;
        font-weight: 500;
    }

    .movie-card-small-info p svg {
        width: 12px;
        height: 12px;
        color: #94a3b8;
    }
    
    .movie-card-small-info .rating {
        color: var(--color-ruby);
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 4px;
    }
    
    /* ===== MODERN TABLE ===== */
    .table-wrapper {
        overflow-x: auto;
        border-radius: 16px;
        border: 1px solid #f1f5f9;
    }
    
    .data-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.9rem;
    }
    
    .data-table th {
        background: #f8fafc;
        color: #475569;
        padding: 16px 20px;
        text-align: left;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.75rem;
        letter-spacing: 0.5px;
        border-bottom: 2px solid #e2e8f0;
    }
    
    .data-table td {
        padding: 16px 20px;
        border-bottom: 1px solid #f1f5f9;
        color: #334155;
        font-weight: 500;
        transition: background-color 0.2s ease;
    }
    
    .data-table tbody tr:hover td {
        background-color: #f8fafc;
    }
    
    /* ===== PROFESSIONAL BADGES ===== */
    .badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 12px;
        border-radius: 8px;
        font-size: 0.75rem;
        font-weight: 600;
        letter-spacing: 0.3px;
    }

    .badge svg {
        width: 12px;
        height: 12px;
    }
    
    .badge-success {
        background: #ecfdf5;
        color: #059669;
        border: 1px solid #d1fae5;
    }
    
    .badge-danger {
        background: #fef2f2;
        color: #dc2626;
        border: 1px solid #fee2e2;
    }
    
    /* ===== EMPTY STATE ===== */
    .empty-state, .empty-state-full {
        text-align: center;
        padding: 60px 20px;
        color: #94a3b8;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 15px;
    }

    .empty-state svg, .empty-state-full svg {
        width: 48px;
        height: 48px;
        color: #cbd5e1;
        margin-bottom: 10px;
    }
    
    .empty-state p {
        font-size: 1rem;
        font-weight: 500;
        margin-bottom: 15px;
    }
    
    /* ===== 3D BUTTONS ===== */
    .btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 12px 24px;
        border-radius: 12px;
        font-size: 0.9rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        border: none;
        text-decoration: none;
        /* 3D Button Setup */
        position: relative;
        transform: translateY(0);
    }

    .btn svg {
        width: 16px;
        height: 16px;
    }
    
    .btn-primary {
        background: var(--color-ruby);
        color: #fff;
        box-shadow: 0 4px 0 var(--color-ruby-dark), 0 10px 20px rgba(233,69,96,0.3);
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 0 var(--color-ruby-dark), 0 15px 25px rgba(233,69,96,0.4);
    }

    .btn-primary:active {
        transform: translateY(4px);
        box-shadow: 0 0 0 var(--color-ruby-dark), 0 5px 10px rgba(233,69,96,0.3);
    }
    
    .btn-secondary {
        background: #fff;
        color: var(--color-navy);
        border: 1px solid #e2e8f0;
        box-shadow: 0 4px 0 #cbd5e1;
    }
    
    .btn-secondary:hover {
        background: #f8fafc;
        transform: translateY(-2px);
        box-shadow: 0 6px 0 #cbd5e1, 0 10px 15px rgba(0,0,0,0.05);
    }

    .btn-secondary:active {
        transform: translateY(4px);
        box-shadow: 0 0 0 #cbd5e1;
    }
    
    .btn-sm {
        padding: 8px 16px;
        font-size: 0.8rem;
        box-shadow: 0 3px 0 var(--color-ruby-dark);
    }

    .btn-sm:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 0 var(--color-ruby-dark), 0 8px 15px rgba(233,69,96,0.3);
    }

    .btn-sm:active {
        transform: translateY(3px);
        box-shadow: 0 0 0 var(--color-ruby-dark);
    }
    
    /* ===== RESPONSIVE ===== */
    @media (max-width: 1100px) {
        .container { padding: 20px; }
        .movies-grid-small { grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); }
    }
    
    @media (max-width: 768px) {
        .welcome-banner {
            flex-direction: column;
            text-align: center;
            padding: 30px 20px;
            gap: 20px;
        }
        .stats-row { grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .movies-grid-small { grid-template-columns: 1fr; }
        .section-card { padding: 20px; }
        .data-table th, .data-table td { padding: 12px; }
    }
    
    @media (max-width: 480px) {
        .stats-row { grid-template-columns: 1fr; }
        .movie-poster-small { width: 75px; height: 105px; }
    }
</style>

<div class="container">

    <div class="welcome-banner">
        <div class="welcome-text">
            <h2>Welcome back, ${sessionScope.loggedInCustomer.fullName}!</h2>
            <p>What cinematic adventure awaits you today?</p>
        </div>
        <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-primary">
            <i data-feather="film"></i> Browse Movies
        </a>
    </div>

    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon"><i data-feather="monitor"></i></div>
            <div class="stat-info">
                <h3 class="stat-number">${totalBookings != null ? totalBookings : 0}</h3>
                <p>Total Bookings</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i data-feather="check-circle"></i></div>
            <div class="stat-info">
                <h3 class="stat-number">${confirmedBookings != null ? confirmedBookings : 0}</h3>
                <p>Confirmed</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i data-feather="x-circle"></i></div>
            <div class="stat-info">
                <h3 class="stat-number">${cancelledBookings != null ? cancelledBookings : 0}</h3>
                <p>Cancelled</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i data-feather="video"></i></div>
            <div class="stat-info">
                <h3 class="stat-number">${nowShowingCount != null ? nowShowingCount : 0}</h3>
                <p>Movies Available</p>
            </div>
        </div>
    </div>

    <div class="section-card">
        <div class="section-card-header">
            <h3><i data-feather="clipboard"></i> Recent Bookings</h3>
            <a href="${pageContext.request.contextPath}/customer/bookings" class="btn btn-secondary">
                View All <i data-feather="arrow-right"></i>
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty recentBookings}">
                <div class="table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Movie</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Seats</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${recentBookings}">
                                <tr>
                                    <td><strong>#${booking.bookingId}</strong></td>
                                    <td>${booking.movieTitle}</td>
                                    <td>${booking.showDate}</td>
                                    <td>${booking.showTime}</td>
                                    <td>${booking.seatNumbers}</td>
                                    <td><strong>Rs. ${booking.totalAmount}</strong></td>
                                    <td>
                                        <span class="badge ${booking.bookingStatus == 'confirmed' ? 'badge-success' : 'badge-danger'}">
                                            <i data-feather="${booking.bookingStatus == 'confirmed' ? 'check' : 'x'}"></i>
                                            ${booking.bookingStatus == 'confirmed' ? 'Confirmed' : 'Cancelled'}
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
                    <i data-feather="inbox"></i>
                    <p>No bookings yet. Start your movie journey!</p>
                    <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-primary">
                        <i data-feather="play"></i> Book Your First Movie
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="section-card">
        <div class="section-card-header">
            <h3><i data-feather="play-circle"></i> Now Showing</h3>
            <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-secondary">
                View All <i data-feather="arrow-right"></i>
            </a>
        </div>
        <div class="movies-grid-small">
            <c:choose>
                <c:when test="${not empty nowShowingMovies}">
                    <c:forEach var="movie" items="${nowShowingMovies}">
                        <div class="movie-card-small">
                            <div class="movie-poster-small">
                                <c:choose>
                                    <c:when test="${not empty movie.posterUrl}">
                                        <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}" alt="${movie.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-poster-small"><i data-feather="image"></i></div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="movie-card-small-info">
                                <h4>${movie.title}</h4>
                                <p>
                                    <span><i data-feather="tag"></i> ${movie.genre}</span>
                                    <span><i data-feather="clock"></i> ${movie.duration} mins</span>
                                </p>
                                <p class="rating">
                                    <i data-feather="star"></i> ${movie.rating != null ? movie.rating : 'N/A'}/10
                                </p>
                                <a href="${pageContext.request.contextPath}/customer/showtimes?movieId=${movie.movieId}"
                                   class="btn btn-primary btn-sm">
                                    <i data-feather="ticket"></i> Book Now
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state-full">
                        <i data-feather="film"></i>
                        <p>No movies currently showing. Check back soon!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        feather.replace();
    });
</script>

<%@ include file="/components/footer.jsp" %>
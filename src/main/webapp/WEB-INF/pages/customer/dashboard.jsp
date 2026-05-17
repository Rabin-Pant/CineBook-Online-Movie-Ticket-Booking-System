<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="My Dashboard" />
<c:set var="extraCSS" value="dashboard.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<style>
    /* ===== BASE CONTAINER  ===== */
    .container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 20px 30px;
        background: linear-gradient(135deg, #f8f9fa 0%, #f0f2f5 100%);
        min-height: calc(100vh - 70px);
    }
    
    /* ===== WELCOME BANNER ===== */
    .welcome-banner {
        background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
        color: #fff;
        border-radius: 24px;
        padding: 35px 40px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 35px;
        animation: slideInLeft 0.6s ease-out;
        position: relative;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    }
    
    .welcome-banner::before {
        content: '🎬';
        position: absolute;
        right: -30px;
        bottom: -30px;
        font-size: 150px;
        opacity: 0.08;
        pointer-events: none;
    }
    
    @keyframes slideInLeft {
        from {
            opacity: 0;
            transform: translateX(-40px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    
    .welcome-text h2 {
        font-size: 1.8rem;
        font-weight: 800;
        margin-bottom: 10px;
        background: linear-gradient(135deg, #fff, #e94560);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }
    
    .welcome-text p {
        color: #aaa;
        font-size: 1rem;
    }
    
    /* ===== STATS ROW ===== */
    .stats-row {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 25px;
        margin-bottom: 35px;
    }
    
    .stat-card {
        background: #fff;
        border-radius: 20px;
        padding: 22px 25px;
        display: flex;
        align-items: center;
        gap: 18px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        animation: fadeInUp 0.5s ease-out;
        animation-fill-mode: both;
        border: 1px solid rgba(233,69,96,0.08);
    }
    
    .stat-card:nth-child(1) { animation-delay: 0.1s; }
    .stat-card:nth-child(2) { animation-delay: 0.2s; }
    .stat-card:nth-child(3) { animation-delay: 0.3s; }
    .stat-card:nth-child(4) { animation-delay: 0.4s; }
    
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(25px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .stat-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 15px 35px rgba(233,69,96,0.12);
        border-color: rgba(233,69,96,0.2);
    }
    
    .stat-icon {
        font-size: 2.5rem;
        transition: transform 0.3s ease;
    }
    
    .stat-card:hover .stat-icon {
        transform: scale(1.1) rotate(5deg);
    }
    
    .stat-info h3 {
        font-size: 2rem;
        font-weight: 800;
        color: #1a1a2e;
        margin-bottom: 4px;
        background: linear-gradient(135deg, #1a1a2e, #e94560);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }
    
    .stat-info p {
        color: #888;
        font-size: 0.85rem;
        font-weight: 500;
        letter-spacing: 0.5px;
    }
    
    /* ===== SECTION CARD ===== */
    .section-card {
        background: #fff;
        border-radius: 24px;
        padding: 28px 30px;
        margin-bottom: 35px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        transition: all 0.3s ease;
        animation: fadeIn 0.5s ease-out 0.3s both;
        border: 1px solid rgba(0,0,0,0.04);
    }
    
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    
    .section-card:hover {
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    }
    
    .section-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f0f0f0;
    }
    
    .section-card-header h3 {
        font-size: 1.3rem;
        font-weight: 700;
        color: #1a1a2e;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    /* ===== MOVIES SMALL GRID  ===== */
    .movies-grid-small {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 25px;
    }
    
    .movie-card-small {
        display: flex;
        gap: 18px;
        align-items: center;
        background: #f8f9fa;
        border-radius: 18px;
        padding: 16px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        cursor: pointer;
        border: 1px solid rgba(233,69,96,0.05);
    }
    
    .movie-card-small:hover {
        transform: translateX(8px);
        background: #fff;
        box-shadow: 0 8px 25px rgba(233,69,96,0.12);
        border-color: rgba(233,69,96,0.2);
    }
    
    /* POSTER IMAGE - */
    .movie-poster-small {
        width: 80px;
        height: 110px;
        border-radius: 14px;
        background: linear-gradient(135deg, #1a1a2e, #0f3460);
        flex-shrink: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        box-shadow: 0 5px 12px rgba(0,0,0,0.15);
    }
    
    .movie-poster-small img {
        width: 100%;
        height: 100%;
        object-fit: contain;
        object-position: center;
        background: #1a1a2e;
        transition: all 0.3s ease;
    }
    
    /* CRITICAL: */
    .movie-card-small:hover .movie-poster-small img {
        transform: none;
        scale: 1;
    }
    
    .no-poster-small {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
        font-size: 2rem;
        color: #e94560;
    }
    
    .movie-card-small-info {
        flex: 1;
    }
    
    .movie-card-small-info h4 {
        font-size: 1.05rem;
        font-weight: 800;
        color: #1a1a2e;
        margin-bottom: 8px;
        transition: color 0.3s ease;
    }
    
    .movie-card-small:hover .movie-card-small-info h4 {
        color: #e94560;
    }
    
    .movie-card-small-info p {
        font-size: 0.8rem;
        color: #888;
        margin-bottom: 6px;
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: wrap;
    }
    
    .movie-card-small-info .rating {
        color: #e94560;
        font-weight: 700;
        font-size: 0.85rem;
    }
    
    .btn-sm {
        margin-top: 10px;
        padding: 8px 20px;
        font-size: 0.75rem;
    }
    
    /* ===== TABLE STYLES ===== */
    .table-wrapper {
        overflow-x: auto;
        border-radius: 16px;
    }
    
    .data-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.9rem;
    }
    
    .data-table th {
        background: linear-gradient(135deg, #1a1a2e, #16213e);
        color: #fff;
        padding: 14px 18px;
        text-align: left;
        font-weight: 700;
    }
    
    .data-table td {
        padding: 12px 18px;
        border-bottom: 1px solid #f0f0f0;
        color: #555;
        transition: all 0.2s ease;
    }
    
    .data-table tbody tr:hover {
        background: #fafafa;
        transform: scale(1.01);
    }
    
    /* ===== BADGES ===== */
    .badge {
        display: inline-block;
        padding: 5px 14px;
        border-radius: 25px;
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
    }
    
    .badge-success {
        background: linear-gradient(135deg, #d4edda, #c3e6cb);
        color: #155724;
    }
    
    .badge-danger {
        background: linear-gradient(135deg, #f8d7da, #f5c6cb);
        color: #721c24;
    }
    
    /* ===== EMPTY STATE ===== */
    .empty-state {
        text-align: center;
        padding: 60px;
        color: #888;
        animation: pulse 2s infinite;
    }
    
    @keyframes pulse {
        0%, 100% { opacity: 0.7; }
        50% { opacity: 1; }
    }
    
    .empty-state p {
        margin-bottom: 20px;
        font-size: 1rem;
    }
    
    .empty-state-full {
        text-align: center;
        padding: 60px;
        color: #888;
        grid-column: 1/-1;
    }
    
    /* ===== BUTTONS ===== */
    .btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 10px 24px;
        border-radius: 40px;
        font-size: 0.9rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        border: none;
        text-decoration: none;
        position: relative;
        overflow: hidden;
    }
    
    .btn::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255,255,255,0.3);
        transform: translate(-50%, -50%);
        transition: width 0.6s, height 0.6s;
    }
    
    .btn:hover::after {
        width: 200px;
        height: 200px;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #e94560, #c73e56);
        color: #fff;
        box-shadow: 0 4px 12px rgba(233,69,96,0.3);
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(233,69,96,0.4);
    }
    
    .btn-secondary {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: #fff;
    }
    
    .btn-secondary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(102,126,234,0.4);
    }
    
    .btn-sm {
        padding: 6px 16px;
        font-size: 0.75rem;
    }
    
    /* ===== RESPONSIVE ===== */
    @media (max-width: 1100px) {
        .container {
            padding: 20px;
        }
        
        .movies-grid-small {
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
        }
    }
    
    @media (max-width: 768px) {
        .container {
            padding: 15px;
        }
        
        .welcome-banner {
            flex-direction: column;
            text-align: center;
            padding: 25px;
        }
        
        .stats-row {
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        
        .stat-card {
            padding: 18px;
        }
        
        .stat-icon {
            font-size: 2rem;
        }
        
        .stat-info h3 {
            font-size: 1.5rem;
        }
        
        .movies-grid-small {
            grid-template-columns: 1fr;
        }
        
        .movie-card-small {
            max-width: 100%;
        }
        
        .section-card {
            padding: 20px;
        }
        
        .data-table th,
        .data-table td {
            padding: 10px 12px;
            font-size: 0.8rem;
        }
    }
    
    @media (max-width: 480px) {
        .stats-row {
            grid-template-columns: 1fr;
        }
        
        .welcome-text h2 {
            font-size: 1.3rem;
        }
        
        .movie-poster-small {
            width: 70px;
            height: 95px;
        }
    }
</style>
<div class="container">

    <!-- Welcome Banner -->
    <div class="welcome-banner">
        <div class="welcome-text">
            <h2>Welcome back, ${sessionScope.loggedInCustomer.fullName}! 🎬</h2>
            <p>✨ What cinematic adventure awaits you today?</p>
        </div>
        <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-primary">
            🎟️ Browse Movies
        </a>
    </div>

    <!-- Stats Row -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon">🎟️</div>
            <div class="stat-info">
                <h3 class="stat-number">${totalBookings != null ? totalBookings : 0}</h3>
                <p>Total Bookings</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">✅</div>
            <div class="stat-info">
                <h3 class="stat-number">${confirmedBookings != null ? confirmedBookings : 0}</h3>
                <p>Confirmed</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">❌</div>
            <div class="stat-info">
                <h3 class="stat-number">${cancelledBookings != null ? cancelledBookings : 0}</h3>
                <p>Cancelled</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">🎬</div>
            <div class="stat-info">
                <h3 class="stat-number">${nowShowingCount != null ? nowShowingCount : 0}</h3>
                <p>Movies Available</p>
            </div>
        </div>
    </div>

    <!-- Recent Bookings -->
    <div class="section-card">
        <div class="section-card-header">
            <h3>📋 Recent Bookings</h3>
            <a href="${pageContext.request.contextPath}/customer/bookings" class="btn btn-secondary">
                View All →
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
                                            ${booking.bookingStatus == 'confirmed' ? '✓ Confirmed' : '✗ Cancelled'}
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
                    <p>🎟️ No bookings yet. Start your movie journey!</p>
                    <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-primary">
                        🍿 Book Your First Movie
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Now Showing Quick View -->
    <div class="section-card">
        <div class="section-card-header">
            <h3>🍿 Now Showing</h3>
            <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-secondary">
                View All →
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
                                        <div class="no-poster-small">🎬</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="movie-card-small-info">
                                <h4>${movie.title}</h4>
                                <p>
                                    <span>🎭 ${movie.genre}</span> • 
                                    <span>⏱️ ${movie.duration} mins</span>
                                </p>
                                <p style="color: #e94560; font-weight: 600;">
                                    ⭐ ${movie.rating != null ? movie.rating : 'N/A'}/10
                                </p>
                                <a href="${pageContext.request.contextPath}/customer/showtimes?movieId=${movie.movieId}"
                                   class="btn btn-primary btn-sm">
                                    🎟️ Book Now
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state-full">
                        <p>🎬 No movies currently showing. Check back soon!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<%@ include file="/components/footer.jsp" %>
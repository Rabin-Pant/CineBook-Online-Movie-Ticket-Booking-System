<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Welcome to CineBook" />
<c:set var="extraCSS" value="index.css" />

<%@ include file="components/header.jsp" %>
<%@ include file="components/navbar.jsp" %>

<style>
    /* Additional animations and enhancements */
    .hero {
        animation: fadeIn 1s ease-out;
    }
    
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: scale(0.98);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }
    
    .feature-card {
        animation: slideUp 0.6s ease-out;
        animation-fill-mode: both;
    }
    
    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .feature-card:nth-child(1) { animation-delay: 0.1s; }
    .feature-card:nth-child(2) { animation-delay: 0.2s; }
    .feature-card:nth-child(3) { animation-delay: 0.3s; }
    .feature-card:nth-child(4) { animation-delay: 0.4s; }
    
    .movie-card {
        animation: fadeInUp 0.6s ease-out;
        animation-fill-mode: both;
    }
    
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .movie-card:nth-child(1) { animation-delay: 0.1s; }
    .movie-card:nth-child(2) { animation-delay: 0.15s; }
    .movie-card:nth-child(3) { animation-delay: 0.2s; }
    .movie-card:nth-child(4) { animation-delay: 0.25s; }
    
    /* Hero text animation */
    .hero-content h1 {
        animation: slideInLeft 0.8s ease-out;
    }
    
    @keyframes slideInLeft {
        from {
            opacity: 0;
            transform: translateX(-50px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    
    .hero-content p {
        animation: slideInLeft 0.8s ease-out 0.2s both;
    }
    
    .hero-buttons {
        animation: slideInLeft 0.8s ease-out 0.4s both;
    }
    
    .hero-image {
        animation: slideInRight 0.8s ease-out;
    }
    
    @keyframes slideInRight {
        from {
            opacity: 0;
            transform: translateX(50px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    
    /* Section title animations */
    .section-title {
        position: relative;
        display: inline-block;
        width: auto;
        margin-left: auto;
        margin-right: auto;
    }
    
    .section-title::before {
        content: '';
        position: absolute;
        top: 100%;
        left: 50%;
        transform: translateX(-50%);
        width: 0;
        height: 4px;
        background: #e94560;
        transition: width 0.5s ease;
    }
    
    .section-title:hover::before {
        width: 100%;
    }
    
    /* Floating animation for hero image */
    .hero-image img {
        animation: float 3s ease-in-out infinite;
    }
    
    @keyframes float {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-15px); }
    }
    
    /* Feature card enhancements */
    .feature-card {
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
    }
    
    .feature-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(233,69,96,0.1), transparent);
        transition: left 0.5s ease;
    }
    
    .feature-card:hover::before {
        left: 100%;
    }
    
    /* Movie card image zoom */
    .movie-poster img {
        transition: transform 0.5s ease;
    }
    
    .movie-card:hover .movie-poster img {
        transform: scale(1.08);
    }
    
    /* Overlay gradient */
    .movie-overlay {
        background: linear-gradient(135deg, rgba(0,0,0,0.6), rgba(233,69,96,0.3));
        transition: opacity 0.4s ease;
    }
    
    /* Coming badge bounce */
    .coming-badge {
        animation: bounce 0.5s ease;
    }
    
    @keyframes bounce {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-5px); }
    }
    
    /* View all button animation */
    .view-all {
        animation: fadeIn 0.8s ease-out 0.6s both;
    }
    
    /* Hover effects for section titles */
    .now-showing .section-title,
    .coming-soon .section-title,
    .features .section-title {
        transition: all 0.3s ease;
    }
    
    /* Smooth scroll behavior */
    html {
        scroll-behavior: smooth;
    }
    
    /* Responsive enhancements */
    @media (max-width: 768px) {
        .hero-content h1 {
            font-size: 1.8rem;
        }
        
        .feature-card {
            padding: 20px;
        }
        
        .movies-grid {
            gap: 15px;
        }
    }
    
    /* Loading shimmer for images */
    .movie-poster img {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
    }
    
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    
    .movie-poster img.loaded {
        animation: none;
        background: none;
    }
</style>

<!-- ===== HERO SECTION ===== -->
<section class="hero">
    <div class="hero-content">
        <h1>Book Your Movie Tickets <span>Online</span></h1>
        <p>✨ Experience the magic of cinema with CineBook — browse the latest movies, choose your seats, and book tickets instantly, anytime, anywhere.</p>
        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-primary">
                🎬 Browse Movies
            </a>
            <c:if test="${empty sessionScope.loggedInCustomer}">
                <a href="${pageContext.request.contextPath}/customer/register" class="btn btn-secondary">
                    🚀 Get Started
                </a>
            </c:if>
        </div>
    </div>
    <div class="hero-image">
        <img src="${pageContext.request.contextPath}/Public/images/hero-movie.png" alt="Movies" onerror="this.style.display='none'">
    </div>
</section>

<!-- ===== FEATURES SECTION ===== -->
<section class="features">
    <div class="container">
        <h2 class="section-title">Why Choose CineBook? 🎯</h2>
        <div class="features-grid">

            <div class="feature-card">
                <div class="feature-icon">🎬</div>
                <h3>Latest Movies</h3>
                <p>Stay updated with now showing and upcoming movies all in one place.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">💺</div>
                <h3>Seat Selection</h3>
                <p>Pick your favorite seat with our easy interactive seat map.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">⚡</div>
                <h3>Instant Booking</h3>
                <p>Book your tickets in seconds and get instant confirmation.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">📋</div>
                <h3>Booking History</h3>
                <p>View and manage all your past and upcoming bookings easily.</p>
            </div>

        </div>
    </div>
</section>

<!-- ===== NOW SHOWING SECTION ===== -->
<section class="now-showing">
    <div class="container">
        <h2 class="section-title">🍿 Now Showing</h2>
        <div class="movies-grid">
            <c:choose>
                <c:when test="${not empty nowShowingMovies}">
                    <c:forEach var="movie" items="${nowShowingMovies}">
                        <div class="movie-card">
                            <div class="movie-poster">
                                <c:choose>
                                    <c:when test="${not empty movie.posterUrl}">
                                        <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}" 
                                             alt="${movie.title}"
                                             onload="this.classList.add('loaded')">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-poster">🎬</div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="movie-overlay">
                                    <a href="${pageContext.request.contextPath}/customer/showtimes?movieId=${movie.movieId}" class="btn btn-primary">
                                        🎟️ Book Now
                                    </a>
                                </div>
                            </div>
                            <div class="movie-info">
                                <h3>${movie.title}</h3>
                                <p class="movie-genre">
                                    <c:choose>
                                        <c:when test="${movie.genre == 'Action'}">🔥</c:when>
                                        <c:when test="${movie.genre == 'Comedy'}">😄</c:when>
                                        <c:when test="${movie.genre == 'Drama'}">🎭</c:when>
                                        <c:when test="${movie.genre == 'Horror'}">👻</c:when>
                                        <c:when test="${movie.genre == 'Romance'}">💕</c:when>
                                        <c:otherwise>🎬</c:otherwise>
                                    </c:choose>
                                    ${movie.genre}
                                </p>
                                <p class="movie-duration">⏱️ ${movie.duration} mins • ${movie.language}</p>
                                <c:if test="${not empty movie.rating && movie.rating > 0}">
                                    <p class="movie-rating">
                                        <c:forEach begin="1" end="${movie.rating / 2}" step="1">⭐</c:forEach>
                                        ${movie.rating}/10
                                    </p>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-movies">
                        <p>🎬 No movies currently showing. Check back soon!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="view-all">
            <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-secondary">
                View All Movies →
            </a>
        </div>
    </div>
</section>

<!-- ===== COMING SOON SECTION ===== -->
<section class="coming-soon">
    <div class="container">
        <h2 class="section-title">⏰ Coming Soon</h2>
        <div class="movies-grid">
            <c:choose>
                <c:when test="${not empty comingSoonMovies}">
                    <c:forEach var="movie" items="${comingSoonMovies}">
                        <div class="movie-card coming">
                            <div class="movie-poster">
                                <c:choose>
                                    <c:when test="${not empty movie.posterUrl}">
                                        <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}" 
                                             alt="${movie.title}"
                                             onload="this.classList.add('loaded')">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-poster">🎬</div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="coming-badge">🔜 Coming Soon</div>
                            </div>
                            <div class="movie-info">
                                <h3>${movie.title}</h3>
                                <p class="movie-genre">
                                    <c:choose>
                                        <c:when test="${movie.genre == 'Action'}">🔥</c:when>
                                        <c:when test="${movie.genre == 'Comedy'}">😄</c:when>
                                        <c:when test="${movie.genre == 'Drama'}">🎭</c:when>
                                        <c:when test="${movie.genre == 'Horror'}">👻</c:when>
                                        <c:when test="${movie.genre == 'Romance'}">💕</c:when>
                                        <c:otherwise>🎬</c:otherwise>
                                    </c:choose>
                                    ${movie.genre}
                                </p>
                                <p class="movie-duration">⏱️ ${movie.duration} mins • ${movie.language}</p>
                                <c:if test="${not empty movie.rating && movie.rating > 0}">
                                    <p class="movie-rating">
                                        <c:forEach begin="1" end="${movie.rating / 2}" step="1">⭐</c:forEach>
                                        ${movie.rating}/10
                                    </p>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-movies">
                        <p>🎬 No upcoming movies at the moment. Stay tuned!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<script>
    // Image loading animation
    document.querySelectorAll('.movie-poster img').forEach(img => {
        if (img.complete) {
            img.classList.add('loaded');
        }
    });
    
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });
</script>

<%@ include file="components/footer.jsp" %>
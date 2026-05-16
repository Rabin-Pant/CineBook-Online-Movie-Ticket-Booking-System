<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Welcome to CineBook" />
<c:set var="extraCSS" value="index.css" />

<%@ include file="components/header.jsp" %>
<%@ include file="components/navbar.jsp" %>


<!-- ===== HERO SECTION ===== -->
<section class="hero-slider">

    <div class="slider-track" id="sliderTrack">

        <!-- ===== SLIDE 1: Welcome Slide ===== -->
        <div class="slide slide-welcome">
            <div class="slide-bg-overlay"></div>
            <div class="slide-content">
                <div class="slide-left">
                    <div class="hero-tag">
                        <span>🎬</span>
                        <span>NEPAL'S #1 MOVIE BOOKING</span>
                    </div>
                    <h1 class="hero-title">
                        Book Your Movie<br>
                        Tickets <span class="gradient-text">Online</span>
                    </h1>
                    <p class="hero-description">
                        Experience the magic of cinema with CineBook.
                        Browse latest movies, choose your seats, and
                        book tickets instantly — anytime, anywhere.
                    </p>
                    <div class="hero-features">
                        <div class="feature-pill">🎟️ Instant Booking</div>
                        <div class="feature-pill">💺 Live Seat Selection</div>
                        <div class="feature-pill">💳 eSewa Payment</div>
                    </div>
                    <div class="hero-buttons">
                        <a href="${pageContext.request.contextPath}/customer/movies"
                           class="btn-hero-primary">🎬 Browse Movies</a>
                        <c:if test="${empty sessionScope.loggedInCustomer}">
                            <a href="${pageContext.request.contextPath}/customer/register"
                               class="btn-hero-outline">✨ Get Started</a>
                        </c:if>
                    </div>
                </div>
                <div class="slide-right">
                    <div class="stats-grid">
                        <div class="stat-box">
                            <span class="stat-number">100+</span>
                            <span class="stat-label">Movies</span>
                        </div>
                        <div class="stat-box">
                            <span class="stat-number">50K+</span>
                            <span class="stat-label">Happy Users</span>
                        </div>
                        <div class="stat-box">
                            <span class="stat-number">3</span>
                            <span class="stat-label">Halls</span>
                        </div>
                        <div class="stat-box">
                            <span class="stat-number">24/7</span>
                            <span class="stat-label">Support</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===== MOVIE SLIDES ===== -->
        <c:forEach var="movie" items="${nowShowingMovies}">
            <div class="slide slide-movie">
                <div class="slide-movie-bg">
                    <c:if test="${not empty movie.posterUrl}">
                        <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}"
                             alt="${movie.title}" class="slide-bg-img"/>
                    </c:if>
                    <div class="slide-movie-overlay"></div>
                </div>
                <div class="slide-content">
                    <div class="slide-left">
                        <div class="hero-tag">
                            <span>🔥</span>
                            <span>NOW SHOWING</span>
                        </div>
                        <h1 class="hero-title movie-slide-title">
                            ${movie.title}
                        </h1>
                        <div class="movie-slide-meta">
                            <span class="meta-pill">🎭 ${movie.genre}</span>
                            <span class="meta-pill">🌐 ${movie.language}</span>
                            <span class="meta-pill">⏱️ ${movie.duration} mins</span>
                            <c:if test="${not empty movie.rating && movie.rating > 0}">
                                <span class="meta-pill">⭐ ${movie.rating}/10</span>
                            </c:if>
                        </div>
                        <p class="hero-description movie-slide-desc">
                            ${movie.description}
                        </p>
                        <div class="hero-buttons">
                            <a href="${pageContext.request.contextPath}/customer/showtimes?movieId=${movie.movieId}"
                               class="btn-hero-primary">🎟️ Book Now</a>
                            <a href="${pageContext.request.contextPath}/customer/movies"
                               class="btn-hero-outline">View All Movies</a>
                        </div>
                    </div>
                    <div class="slide-right">
                        <c:if test="${not empty movie.posterUrl}">
                            <div class="movie-poster-float">
                                <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}"
                                     alt="${movie.title}"/>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>

        <!-- ===== COMING SOON SLIDES ===== -->
        <c:forEach var="movie" items="${comingSoonMovies}">
            <div class="slide slide-coming">
                <div class="slide-movie-bg">
                    <c:if test="${not empty movie.posterUrl}">
                        <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}"
                             alt="${movie.title}" class="slide-bg-img"/>
                    </c:if>
                    <div class="slide-coming-overlay"></div>
                </div>
                <div class="slide-content">
                    <div class="slide-left">
                        <div class="hero-tag coming-tag">
                            <span>⏰</span>
                            <span>COMING SOON</span>
                        </div>
                        <h1 class="hero-title movie-slide-title">
                            ${movie.title}
                        </h1>
                        <div class="movie-slide-meta">
                            <span class="meta-pill">🎭 ${movie.genre}</span>
                            <span class="meta-pill">🌐 ${movie.language}</span>
                            <span class="meta-pill">⏱️ ${movie.duration} mins</span>
                        </div>
                        <p class="hero-description movie-slide-desc">
                            ${movie.description}
                        </p>
                        <div class="hero-buttons">
                            <span class="btn-hero-coming">🔜 Coming Soon</span>
                            <a href="${pageContext.request.contextPath}/customer/movies"
                               class="btn-hero-outline">View All Movies</a>
                        </div>
                    </div>
                    <div class="slide-right">
                        <c:if test="${not empty movie.posterUrl}">
                            <div class="movie-poster-float coming-poster">
                                <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}"
                                     alt="${movie.title}"/>
                                <div class="coming-soon-badge">Coming Soon</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>

        <!-- ===== INFO SLIDE: How It Works ===== -->
        <div class="slide slide-info">
            <div class="slide-bg-overlay info-overlay"></div>
            <div class="slide-content">
                <div class="slide-left">
                    <div class="hero-tag">
                        <span>💡</span>
                        <span>HOW IT WORKS</span>
                    </div>
                    <h1 class="hero-title">
                        Book in <span class="gradient-text">3 Easy Steps</span>
                    </h1>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-num">1</div>
                            <div class="step-info">
                                <h4>Browse Movies</h4>
                                <p>Find now showing or coming soon movies</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-num">2</div>
                            <div class="step-info">
                                <h4>Select Seats</h4>
                                <p>Pick your favorite seats from live seat map</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-num">3</div>
                            <div class="step-info">
                                <h4>Pay via eSewa</h4>
                                <p>Secure payment and instant confirmation</p>
                            </div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/customer/movies"
                       class="btn-hero-primary">🎬 Start Booking</a>
                </div>
                <div class="slide-right">
                    <div class="info-features">
                        <div class="info-feature-card">
                            <span class="info-icon">🎟️</span>
                            <h4>Instant Booking</h4>
                            <p>Get confirmed in seconds</p>
                        </div>
                        <div class="info-feature-card">
                            <span class="info-icon">💺</span>
                            <h4>60 Seats Per Hall</h4>
                            <p>3 halls available daily</p>
                        </div>
                        <div class="info-feature-card">
                            <span class="info-icon">🔒</span>
                            <h4>Secure Payment</h4>
                            <p>Powered by eSewa gateway</p>
                        </div>
                        <div class="info-feature-card">
                            <span class="info-icon">🖨️</span>
                            <h4>PDF Tickets</h4>
                            <p>Download and print anytime</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- ===== SLIDER CONTROLS ===== -->
    <button class="slider-btn slider-prev" id="sliderPrev">
        <svg width="24" height="24" viewBox="0 0 24 24"
             fill="none" stroke="currentColor" stroke-width="2.5">
            <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
    </button>
    <button class="slider-btn slider-next" id="sliderNext">
        <svg width="24" height="24" viewBox="0 0 24 24"
             fill="none" stroke="currentColor" stroke-width="2.5">
            <polyline points="9 18 15 12 9 6"></polyline>
        </svg>
    </button>

    <!-- ===== SLIDER DOTS ===== -->
    <div class="slider-dots" id="sliderDots"></div>

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
// ===== HERO SLIDER =====
const sliderTrack  = document.getElementById('sliderTrack');
const prevBtn      = document.getElementById('sliderPrev');
const nextBtn      = document.getElementById('sliderNext');
const dotsContainer = document.getElementById('sliderDots');

const slides     = document.querySelectorAll('.slide');
const totalSlides = slides.length;
let currentSlide  = 0;
let autoInterval;

// Create dots
function createDots() {
    dotsContainer.innerHTML = '';
    slides.forEach((_, i) => {
        const dot = document.createElement('button');
        dot.classList.add('slider-dot');
        if (i === currentSlide) dot.classList.add('active');
        dot.addEventListener('click', () => goToSlide(i));
        dotsContainer.appendChild(dot);
    });
}

// Update dots
function updateDots() {
    document.querySelectorAll('.slider-dot').forEach((dot, i) => {
        dot.classList.toggle('active', i === currentSlide);
    });
}

// Go to specific slide
function goToSlide(index) {
    currentSlide = index;
    // Use string concatenation instead of backticks/template literals
    sliderTrack.style.transform = 'translateX(-' + (currentSlide * 100) + '%)';
    updateDots();
}

// Next slide
function nextSlide() {
    currentSlide = (currentSlide + 1) % totalSlides;
    goToSlide(currentSlide);
}

// Prev slide
function prevSlide() {
    currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
    goToSlide(currentSlide);
}

// Auto slide
function startAuto() {
    autoInterval = setInterval(nextSlide, 3000);
}

function stopAuto() {
    clearInterval(autoInterval);
}

// Event listeners
prevBtn.addEventListener('click', () => { stopAuto(); prevSlide(); startAuto(); });
nextBtn.addEventListener('click', () => { stopAuto(); nextSlide(); startAuto(); });

// Pause on hover
const heroSlider = document.querySelector('.hero-slider');
heroSlider.addEventListener('mouseenter', stopAuto);
heroSlider.addEventListener('mouseleave', startAuto);

// Touch/swipe support
let touchStartX = 0;
heroSlider.addEventListener('touchstart', e => {
    touchStartX = e.touches[0].clientX;
});
heroSlider.addEventListener('touchend', e => {
    const diff = touchStartX - e.changedTouches[0].clientX;
    if (Math.abs(diff) > 50) {
        stopAuto();
        diff > 0 ? nextSlide() : prevSlide();
        startAuto();
    }
});

// Initialize
createDots();
startAuto();
</script>
<%@ include file="components/footer.jsp" %>
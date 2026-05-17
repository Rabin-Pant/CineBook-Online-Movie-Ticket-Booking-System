<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Browse Movies" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<style>
    /* Container - */
    .container {
        max-width: 1400px;
        width: 100%;
        margin: 0 auto;
        padding: 20px 40px;
    }
    
    /* ===== PAGE TITLE ===== */
    .page-title {
        font-size: 2rem;
        font-weight: 800;
        margin-bottom: 30px;
        background: linear-gradient(135deg, #1a1a2e, #e94560);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        display: inline-block;
        position: relative;
    }
    
    .page-title::after {
        content: '';
        position: absolute;
        bottom: -8px;
        left: 0;
        width: 60px;
        height: 4px;
        background: linear-gradient(90deg, #e94560, #ff6b6b);
        border-radius: 2px;
    }
    
    /* ===== FILTER BAR ===== */
    .filter-bar {
        background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
        border-radius: 20px;
        padding: 20px 25px;
        margin-bottom: 35px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        border: 1px solid rgba(233,69,96,0.1);
        animation: slideDown 0.5s ease-out;
    }
    
    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .filter-row {
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
        align-items: center;
    }
    
    .filter-select {
        padding: 12px 20px;
        border: 2px solid #e0e0e0;
        border-radius: 12px;
        font-size: 0.9rem;
        background: #fff;
        cursor: pointer;
        min-width: 150px;
        transition: all 0.3s ease;
        font-weight: 500;
        color: #333;
    }
    
    .filter-select:hover {
        border-color: #e94560;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(233,69,96,0.1);
    }
    
    .filter-select:focus {
        outline: none;
        border-color: #e94560;
        box-shadow: 0 0 0 3px rgba(233,69,96,0.1);
    }
    
    /* ===== SUB TITLE ===== */
    .sub-title {
        font-size: 1.8rem;
        color: #1a1a2e;
        font-weight: 800;
        margin-bottom: 25px;
        padding-bottom: 12px;
        border-bottom: 3px solid #e94560;
        display: inline-block;
        position: relative;
    }
    
    /* ===== MOVIES GRID ===== */
    .movies-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 25px;
        margin-bottom: 50px;
    }
    
    /* ===== MOVIE CARD ===== */
    .movie-card {
        background: #fff;
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border: 1px solid rgba(233,69,96,0.08);
        height: 100%;
        display: flex;
        flex-direction: column;
        animation: fadeInUp 0.5s ease-out;
        animation-fill-mode: both;
    }
    
    /* Stagger animation */
    .movie-card:nth-child(1) { animation-delay: 0.05s; }
    .movie-card:nth-child(2) { animation-delay: 0.1s; }
    .movie-card:nth-child(3) { animation-delay: 0.15s; }
    .movie-card:nth-child(4) { animation-delay: 0.2s; }
    .movie-card:nth-child(5) { animation-delay: 0.25s; }
    .movie-card:nth-child(6) { animation-delay: 0.3s; }
    .movie-card:nth-child(7) { animation-delay: 0.35s; }
    .movie-card:nth-child(8) { animation-delay: 0.4s; }
    
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
    
    .movie-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 15px 30px rgba(233,69,96,0.15);
        border-color: rgba(233,69,96,0.25);
    }
    
    /* ===== MOVIE POSTER ===== */
    .movie-poster {
        position: relative;
        width: 100%;
        height: 280px;
        background: linear-gradient(135deg, #1a1a2e, #0f3460);
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .movie-poster img {
        width: 100%;
        height: 100%;
        object-fit: contain;
        object-position: center;
        background: #1a1a2e;
        transition: all 0.3s ease;
    }
    
    /* NO ZOOM on hover */
    .movie-card:hover .movie-poster img {
        transform: none;
    }
    
    .no-poster {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
        font-size: 3rem;
        color: #e94560;
        background: linear-gradient(135deg, #1a1a2e, #0f3460);
    }
    
    /* Overlay */
    .movie-overlay {
        position: absolute;
        inset: 0;
        background: linear-gradient(135deg, rgba(0,0,0,0.7), rgba(233,69,96,0.3));
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.35s ease;
    }
    
    .movie-card:hover .movie-overlay {
        opacity: 1;
    }
    
    .movie-overlay .btn {
        transform: scale(0.9);
        transition: transform 0.3s ease;
    }
    
    .movie-card:hover .movie-overlay .btn {
        transform: scale(1);
    }
    
    /* Coming Soon Badge */
    .coming-badge {
        position: absolute;
        top: 12px;
        right: 12px;
        background: linear-gradient(135deg, #e94560, #c73e56);
        color: #fff;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 0.7rem;
        font-weight: 700;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        z-index: 2;
    }
    
    /* ===== MOVIE INFO ===== */
    .movie-info {
        padding: 15px;
        flex: 1;
        display: flex;
        flex-direction: column;
    }
    
    .movie-info h3 {
        font-size: 1rem;
        font-weight: 800;
        color: #1a1a2e;
        margin-bottom: 6px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        transition: color 0.3s ease;
    }
    
    .movie-card:hover .movie-info h3 {
        color: #e94560;
    }
    
    .movie-genre {
        font-size: 0.7rem;
        color: #e94560;
        font-weight: 600;
        margin-bottom: 8px;
        display: inline-block;
        padding: 3px 10px;
        background: rgba(233,69,96,0.1);
        border-radius: 20px;
        width: fit-content;
    }
    
    .movie-duration {
        font-size: 0.75rem;
        color: #888;
        margin-bottom: 5px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    
    .movie-rating {
        font-size: 0.8rem;
        font-weight: 700;
        color: #f5a623;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    
    .movie-desc {
        font-size: 0.7rem;
        color: #999;
        margin-top: 8px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        line-height: 1.4;
    }
    
    .book-btn {
        margin-top: 12px;
        padding: 8px 12px;
        font-size: 0.75rem;
        text-align: center;
        width: 100%;
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
        box-shadow: 0 2px 8px rgba(233,69,96,0.3);
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(233,69,96,0.4);
    }
    
    .btn-secondary {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: #fff;
    }
    
    .btn-secondary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(102,126,234,0.4);
    }
    
    /* ===== EMPTY STATE ===== */
    .empty-state-full {
        text-align: center;
        padding: 60px;
        color: #888;
        grid-column: 1/-1;
        background: linear-gradient(135deg, #f8f9fa, #fff);
        border-radius: 20px;
    }
    
    /* ===== RESPONSIVE GRID ===== */
    @media (max-width: 1200px) {
        .container {
            padding: 20px 30px;
        }
        
        .movies-grid {
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        
        .movie-poster {
            height: 260px;
        }
    }
    
    @media (max-width: 900px) {
        .container {
            padding: 15px 25px;
        }
        
        .filter-bar {
            padding: 15px 20px;
        }
        
        .filter-row {
            gap: 10px;
        }
        
        .filter-select {
            min-width: 100%;
            padding: 10px 16px;
        }
        
        .movies-grid {
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
        }
        
        .movie-poster {
            height: 240px;
        }
        
        .sub-title {
            font-size: 1.5rem;
        }
    }
    
    @media (max-width: 576px) {
        .container {
            padding: 12px 15px;
        }
        
        .page-title {
            font-size: 1.5rem;
        }
        
        .movies-grid {
            grid-template-columns: 1fr;
            gap: 16px;
        }
        
        .movie-poster {
            height: 280px;
        }
        
        .movie-info h3 {
            font-size: 0.95rem;
        }
        
        .btn {
            padding: 8px 16px;
            font-size: 0.8rem;
        }
    }
    
    /* ===== CUSTOM SCROLLBAR ===== */
    .filter-select::-webkit-scrollbar {
        width: 8px;
    }
    
    .filter-select::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }
    
    .filter-select::-webkit-scrollbar-thumb {
        background: linear-gradient(135deg, #e94560, #c73e56);
        border-radius: 10px;
    }
</style>
<div class="container">

    <h1 class="page-title">🎬 Browse Movies</h1>

    <!-- Filter Bar -->
    <div class="filter-bar">
        <form action="${pageContext.request.contextPath}/customer/movies" method="get" id="filterForm">
            <div class="filter-row">

                <select name="genre" class="filter-select" onchange="this.form.submit()">
                    <option value="">🎭 All Genres</option>
                    <option value="Action"    ${param.genre == 'Action'    ? 'selected' : ''}>🔥 Action</option>
                    <option value="Drama"     ${param.genre == 'Drama'     ? 'selected' : ''}>🎭 Drama</option>
                    <option value="Comedy"    ${param.genre == 'Comedy'    ? 'selected' : ''}>😄 Comedy</option>
                    <option value="Horror"    ${param.genre == 'Horror'    ? 'selected' : ''}>👻 Horror</option>
                    <option value="Romance"   ${param.genre == 'Romance'   ? 'selected' : ''}>💕 Romance</option>
                    <option value="Thriller"  ${param.genre == 'Thriller'  ? 'selected' : ''}>🔪 Thriller</option>
                    <option value="Sci-Fi"    ${param.genre == 'Sci-Fi'    ? 'selected' : ''}>🚀 Sci-Fi</option>
                    <option value="Animation" ${param.genre == 'Animation' ? 'selected' : ''}>🎨 Animation</option>
                </select>

                <select name="language" class="filter-select" onchange="this.form.submit()">
                    <option value="">🌐 All Languages</option>
                    <option value="English" ${param.language == 'English' ? 'selected' : ''}>🇺🇸 English</option>
                    <option value="Hindi"   ${param.language == 'Hindi'   ? 'selected' : ''}>🇮🇳 Hindi</option>
                    <option value="Nepali"  ${param.language == 'Nepali'  ? 'selected' : ''}>🇳🇵 Nepali</option>
                </select>

                <select name="status" class="filter-select" onchange="this.form.submit()">
                    <option value="">🎬 Now Showing</option>
                    <option value="coming_soon" ${param.status == 'coming_soon' ? 'selected' : ''}>⏰ Coming Soon</option>
                </select>

                <button type="submit" class="btn btn-primary">🎯 Apply Filters</button>
                <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-secondary">🔄 Reset</a>

            </div>
        </form>
    </div>

    <!-- Single Section Title based on status -->
    <h2 class="sub-title">
        <c:choose>
            <c:when test="${param.status == 'coming_soon'}">
                <span>⏰ Coming Soon</span>
            </c:when>
            <c:otherwise>
                <span>🎬 Now Showing</span>
            </c:otherwise>
        </c:choose>
    </h2>

    <!-- Movies Grid -->
    <div class="movies-grid">
        <c:choose>
            <c:when test="${not empty movies}">
                <c:forEach var="movie" items="${movies}">
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

                            <%-- Show Book Now only for now_showing --%>
                            <c:choose>
                                <c:when test="${movie.status == 'now_showing'}">
                                    <div class="movie-overlay">
                                        <a href="${pageContext.request.contextPath}/customer/showtimes?movieId=${movie.movieId}"
                                           class="btn btn-primary">🎟️ Book Now</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="coming-badge">⏰ Coming Soon</div>
                                </c:otherwise>
                            </c:choose>
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
                                    <c:when test="${movie.genre == 'Thriller'}">🔪</c:when>
                                    <c:when test="${movie.genre == 'Sci-Fi'}">🚀</c:when>
                                    <c:when test="${movie.genre == 'Animation'}">🎨</c:when>
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
                            <p class="movie-desc">${movie.description}</p>

                            <%-- Direct Book Now button --%>
                            <c:if test="${movie.status == 'now_showing'}">
                                <a href="${pageContext.request.contextPath}/customer/showtimes?movieId=${movie.movieId}"
                                   class="btn btn-primary book-btn">
                                    🎟️ Book Now
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state-full">
                    <p>🎬 No movies found. Check back later!</p>
                    <c:if test="${not empty param.genre or not empty param.language}">
                        <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-primary" style="margin-top: 20px;">
                            🔄 Clear Filters
                        </a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<script>
    // Smooth filter form submission
    document.querySelectorAll('.filter-select').forEach(select => {
        select.addEventListener('change', function() {
            this.form.submit();
        });
    });
    
    // Add loading animation for images
    document.querySelectorAll('.movie-poster img').forEach(img => {
        if (img.complete) {
            img.classList.add('loaded');
        }
    });
</script>

<%@ include file="/components/footer.jsp" %>
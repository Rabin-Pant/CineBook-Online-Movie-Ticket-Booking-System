<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Search Results" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<style>
    /* ===== SEARCH CONTAINER ===== */
    .container {
        max-width: 1400px;
        width: 100%;
        margin: 0 auto;
        padding: 20px 40px;
    }

    .search-info {
        margin-bottom: 25px;
        font-size: 1.1rem;
        color: #ddd;
    }

    /* ===== MOVIES GRID LAYOUT ===== */
    .movies-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 25px;
        margin-bottom: 50px;
    }
    
    /* ===== MOVIE CARD STRUCTURE ===== */
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
        animation: fadeInUp 0.5s ease-out both;
    }
    
    .movie-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 15px 30px rgba(233,69,96,0.15);
        border-color: rgba(233,69,96,0.25);
    }
    
    /* ===== MOVIE POSTER CONTAINER ===== */
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
        object-fit: cover;
        object-position: center;
    }
    
    .no-poster {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
        font-size: 3rem;
        color: #e94560;
    }
    
    /* Hover Overlay Effect */
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
    
    /* ===== MOVIE CONTENT DETAILS ===== */
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
    
    .movie-duration, .movie-rating {
        font-size: 0.75rem;
        color: #888;
        margin-bottom: 5px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    
    .movie-rating {
        font-weight: 700;
        color: #f5a623;
    }

    /* ===== GLOBAL MOVIE ACTION BUTTON ===== */
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
        text-decoration: none;
        border: none;
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

    .empty-state-full {
        text-align: center;
        padding: 60px;
        color: #888;
        grid-column: 1/-1;
        background: #fff;
        border-radius: 20px;
    }

    /* ===== RESPONSIVE BREAKPOINTS ===== */
    @media (max-width: 1200px) {
        .movies-grid { grid-template-columns: repeat(3, 1fr); gap: 20px; }
    }
    @media (max-width: 900px) {
        .movies-grid { grid-template-columns: repeat(2, 1fr); gap: 18px; }
    }
    @media (max-width: 576px) {
        .movies-grid { grid-template-columns: 1fr; gap: 16px; }
    }

    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<div class="container">

    <h1 class="page-title">🔍 Search Results</h1>

    <div class="search-info">
        <c:choose>
            <c:when test="${not empty results}">
                <p>Found <strong>${results.size()}</strong>
                   result(s) for "<strong>${keyword}</strong>"</p>
            </c:when>
            <c:otherwise>
                <p>No results found for "<strong>${keyword}</strong>"</p>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="movies-grid">
        <c:choose>
            <c:when test="${not empty results}">
                <c:forEach var="movie" items="${results}">
                    <div class="movie-card">
                        <div class="movie-poster"
                             style="height:300px; overflow:hidden; position:relative;">
                            <c:choose>
                                <c:when test="${not empty movie.posterUrl}">
                                    <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}"
                                         alt="${movie.title}"
                                         style="width:100%; height:100%; object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="no-poster">🎬</div>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${movie.status == 'now_showing'}">
                                    <div class="movie-overlay">
                                        <a href="${pageContext.request.contextPath}/customer/showtimes?movieId=${movie.movieId}"
                                           class="btn btn-primary">Book Now</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="coming-badge">Coming Soon</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="movie-info">
                            <h3>${movie.title}</h3>
                            <p class="movie-genre">${movie.genre}</p>
                            <p class="movie-duration">
                                ⏱ ${movie.duration} mins | ${movie.language}
                            </p>
                            <c:if test="${not empty movie.rating && movie.rating > 0}">
                                <p class="movie-rating">⭐ ${movie.rating}/10</p>
                            </c:if>
                            <c:if test="${movie.status == 'now_showing'}">
                                <a href="${pageContext.request.contextPath}/customer/showtimes?movieId=${movie.movieId}"
                                   class="btn btn-primary"
                                   style="margin-top:12px; display:inline-block;">
                                    Book Now
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state-full">
                    <p>😕 No movies found for "<strong>${keyword}</strong>"</p>
                    <a href="${pageContext.request.contextPath}/customer/movies"
                       class="btn btn-primary" style="margin-top:16px;">
                        Browse All Movies
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<%@ include file="/components/footer.jsp" %>
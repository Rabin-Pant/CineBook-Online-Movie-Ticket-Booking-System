<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Showtimes" />
<c:set var="extraCSS" value="showtimes.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="container">

    <a href="${pageContext.request.contextPath}/customer/movies" class="back-link">← Back to Movies</a>

    <!-- Movie Info Banner -->
    <div class="movie-banner">
        <div class="movie-banner-poster">
            <c:choose>
                <c:when test="${not empty movie.posterUrl}">
                    <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}" alt="${movie.title}">
                </c:when>
                <c:otherwise>
                    <div class="no-poster-lg">🎬</div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="movie-banner-info">
            <h1>${movie.title}</h1>
            <p class="movie-meta">
                <span class="tag">${movie.genre}</span>
                <span class="tag">${movie.language}</span>
                <span class="tag">⏱ ${movie.duration} mins</span>
                <c:if test="${not empty movie.rating}">
                    <span class="tag">⭐ ${movie.rating}/10</span>
                </c:if>
            </p>
            <p class="movie-desc-full">${movie.description}</p>
        </div>
    </div>

    <!-- Showtimes -->
    <h2 class="section-heading">Available Showtimes</h2>

    <c:choose>
        <c:when test="${not empty showtimes}">
            <div class="showtimes-grid">
                <c:forEach var="showtime" items="${showtimes}">
                    <div class="showtime-card">
                        <div class="showtime-date">
                            📅 ${showtime.showDate}
                        </div>
                        <div class="showtime-details">
                            <div class="showtime-time">🕐 ${showtime.showTime}</div>
                            <div class="showtime-hall">🎭 ${showtime.hall}</div>
                            <div class="showtime-price">💰 Rs. ${showtime.price}</div>
                            <div class="showtime-seats">
                                💺 ${showtime.availableSeats} seats available
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/customer/seats?showtimeId=${showtime.showtimeId}"
                           class="btn btn-primary btn-full">Select Seats</a>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <p>No showtimes available for this movie yet.</p>
                <a href="${pageContext.request.contextPath}/customer/movies" class="btn btn-secondary">Browse Other Movies</a>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/components/footer.jsp" %>
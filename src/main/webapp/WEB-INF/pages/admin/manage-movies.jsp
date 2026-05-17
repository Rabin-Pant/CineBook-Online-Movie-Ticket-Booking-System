<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Manage Movies" />
<c:set var="extraCSS" value="admin.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/admin-navbar.jsp" %>

<div class="admin-wrapper">

    <%@ include file="/components/admin-sidebar.jsp" %>

    <main class="admin-main">

        <div class="admin-topbar">
            <h2>
                <i class="fas fa-film"></i> Manage Movies
            </h2>
            <a href="${pageContext.request.contextPath}/admin/add-movie" class="btn btn-primary">
                <i class="fas fa-plus"></i> Add Movie
            </a>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>

        <div class="admin-card">
            <div class="admin-card-header">
                <h3>
                    <i class="fas fa-list"></i> All Movies (${not empty movies ? movies.size() : 0})
                </h3>
            </div>

            <c:choose>
                <c:when test="${not empty movies}">
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Poster</th>
                                    <th>Title</th>
                                    <th>Genre</th>
                                    <th>Duration</th>
                                    <th>Language</th>
                                    <th>Rating</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="movie" items="${movies}">
                                    <tr>
                                        <td>#${movie.movieId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty movie.posterUrl}">
                                                   <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}"
     alt="${movie.title}" class="table-poster">

                                                </c:when>
                                                <c:otherwise>
                                                    <div class="table-poster-placeholder">🎬</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><strong>${movie.title}</strong></td>
                                        <td>${movie.genre}</td>
                                        <td>${movie.duration} mins</td>
                                        <td>${movie.language}</td>
                                        <td>${not empty movie.rating ? movie.rating : '-'}</td>
                                        <td>
                                            <span class="badge ${movie.status == 'now_showing' ? 'badge-success' : 'badge-warning'}">
                                                ${movie.status == 'now_showing' ? 'Now Showing' : 'Coming Soon'}
                                            </span>
                                        </td>
                                        <td class="action-btns">
                                            <a href="${pageContext.request.contextPath}/admin/edit-movie?movieId=${movie.movieId}"
                                               class="btn-action btn-edit">
                                                <i class="fas fa-edit"></i> Edit
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/delete-movie?movieId=${movie.movieId}"
                                               class="btn-action btn-delete"
                                               onclick="return confirm('Are you sure you want to delete ${movie.title}?')">
                                                <i class="fas fa-trash"></i> Delete
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>🎬 No movies added yet.</p>
                        <a href="${pageContext.request.contextPath}/admin/add-movie" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add First Movie
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</div>

<%@ include file="/components/footer.jsp" %>
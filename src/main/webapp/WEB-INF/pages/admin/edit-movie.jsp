<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Edit Movie" />
<c:set var="extraCSS" value="admin.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/admin-navbar.jsp" %>
<style>
.current-poster-preview {
    width: 220px;
    height: 320px;
    object-fit: contain;
    border-radius: 10px;
    border: 2px solid #ddd;
    display: block;
    margin-top: 10px;
    background-color: #111;
}
</style>
<div class="admin-wrapper">

    <%@ include file="/components/admin-sidebar.jsp" %>

    <main class="admin-main">

        <div class="admin-topbar">
            <h2>Edit Movie</h2>
            <a href="${pageContext.request.contextPath}/admin/manage-movies" class="btn btn-secondary">← Back</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <div class="admin-card">
            <form action="${pageContext.request.contextPath}/admin/edit-movie"
                  method="post" enctype="multipart/form-data">

                <input type="hidden" name="movieId" value="${movie.movieId}" />

                <div class="form-row">
                    <div class="form-group">
                        <label>Movie Title *</label>
                        <input type="text" name="title" value="${movie.title}" required />
                    </div>
                    <div class="form-group">
                        <label>Genre *</label>
                        <select name="genre" required>
                            <option value="Action"    ${movie.genre == 'Action'    ? 'selected' : ''}>Action</option>
                            <option value="Drama"     ${movie.genre == 'Drama'     ? 'selected' : ''}>Drama</option>
                            <option value="Comedy"    ${movie.genre == 'Comedy'    ? 'selected' : ''}>Comedy</option>
                            <option value="Horror"    ${movie.genre == 'Horror'    ? 'selected' : ''}>Horror</option>
                            <option value="Romance"   ${movie.genre == 'Romance'   ? 'selected' : ''}>Romance</option>
                            <option value="Thriller"  ${movie.genre == 'Thriller'  ? 'selected' : ''}>Thriller</option>
                            <option value="Sci-Fi"    ${movie.genre == 'Sci-Fi'    ? 'selected' : ''}>Sci-Fi</option>
                            <option value="Animation" ${movie.genre == 'Animation' ? 'selected' : ''}>Animation</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Duration (minutes) *</label>
                        <input type="number" name="duration" value="${movie.duration}" min="1" required />
                    </div>
                    <div class="form-group">
                        <label>Language *</label>
                        <select name="language" required>
                            <option value="English" ${movie.language == 'English' ? 'selected' : ''}>English</option>
                            <option value="Hindi"   ${movie.language == 'Hindi'   ? 'selected' : ''}>Hindi</option>
                            <option value="Nepali"  ${movie.language == 'Nepali'  ? 'selected' : ''}>Nepali</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Rating (out of 10)</label>
                        <input type="number" name="rating" value="${movie.rating}"
                               min="0" max="10" step="0.1" />
                    </div>
                    <div class="form-group">
                        <label>Status *</label>
                        <select name="status" required>
                            <option value="now_showing" ${movie.status == 'now_showing' ? 'selected' : ''}>Now Showing</option>
                            <option value="coming_soon" ${movie.status == 'coming_soon' ? 'selected' : ''}>Coming Soon</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4">${movie.description}</textarea>
                </div>

                <div class="form-group">
                    <label>Current Poster</label>
                    <c:choose>
                        <c:when test="${not empty movie.posterUrl}">
                           <img src="${pageContext.request.contextPath}/uploads/${movie.posterUrl}"
     alt="Current Poster" class="current-poster-preview">
                        </c:when>
                        <c:otherwise>
                            <p style="color:#888;">No poster uploaded</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="form-group">
                    <label>Update Poster (optional)</label>
                    <input type="file" name="poster" accept="image/*" />
                    <small style="color:#888;">Leave empty to keep current poster</small>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Update Movie</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-movies"
                       class="btn btn-secondary">Cancel</a>
                </div>

            </form>
        </div>

    </main>
</div>

<%@ include file="/components/footer.jsp" %>
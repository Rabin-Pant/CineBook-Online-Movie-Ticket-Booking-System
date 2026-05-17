<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Add Movie" />
<c:set var="extraCSS" value="admin.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/admin-navbar.jsp" %>

<div class="admin-wrapper">

    <%@ include file="/components/admin-sidebar.jsp" %>

    <main class="admin-main">

        <div class="admin-topbar">
            <h2>Add New Movie</h2>
            <a href="${pageContext.request.contextPath}/admin/manage-movies" class="btn btn-secondary">← Back</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <div class="admin-card">
            <form action="${pageContext.request.contextPath}/admin/add-movie"
                  method="post" enctype="multipart/form-data">

                <div class="form-row">
                    <div class="form-group">
                        <label>Movie Title *</label>
                        <input type="text" name="title" placeholder="Enter movie title" required />
                    </div>
                    <div class="form-group">
                        <label>Genre *</label>
                        <select name="genre" required>
                            <option value="">Select Genre</option>
                            <option value="Action">Action</option>
                            <option value="Drama">Drama</option>
                            <option value="Comedy">Comedy</option>
                            <option value="Horror">Horror</option>
                            <option value="Romance">Romance</option>
                            <option value="Thriller">Thriller</option>
                            <option value="Sci-Fi">Sci-Fi</option>
                            <option value="Animation">Animation</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Duration (minutes) *</label>
                        <input type="number" name="duration" placeholder="e.g. 120" min="1" required />
                    </div>
                    <div class="form-group">
                        <label>Language *</label>
                        <select name="language" required>
                            <option value="">Select Language</option>
                            <option value="English">English</option>
                            <option value="Hindi">Hindi</option>
                            <option value="Nepali">Nepali</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Rating (out of 10)</label>
                        <input type="number" name="rating" placeholder="e.g. 8.5"
                               min="0" max="10" step="0.1" />
                    </div>
                    <div class="form-group">
                        <label>Status *</label>
                        <select name="status" required>
                            <option value="now_showing">Now Showing</option>
                            <option value="coming_soon">Coming Soon</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4"
                              placeholder="Enter movie description..."></textarea>
                </div>

                <div class="form-group">
                    <label>Movie Poster</label>
                    <input type="file" name="poster" accept="image/*" />
                    <small style="color:#888;">Accepted: JPG, PNG, WEBP (Max 5MB)</small>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Add Movie</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-movies"
                       class="btn btn-secondary">Cancel</a>
                </div>

            </form>
        </div>

    </main>
</div>

<%@ include file="/components/footer.jsp" %>
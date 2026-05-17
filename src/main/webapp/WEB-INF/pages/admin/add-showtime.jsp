<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Add Showtime" />
<c:set var="extraCSS" value="admin.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/admin-navbar.jsp" %>

<div class="admin-wrapper">

    <%@ include file="/components/admin-sidebar.jsp" %>

    <main class="admin-main">

        <div class="admin-topbar">
            <h2>Add New Showtime</h2>
            <a href="${pageContext.request.contextPath}/admin/manage-movies"
               class="btn btn-secondary">← Back</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <div class="admin-card">
            <form action="${pageContext.request.contextPath}/admin/add-showtime" method="post">

                <div class="form-group">
                    <label>Select Movie *</label>
                    <select name="movieId" required>
                        <option value="">-- Select Movie --</option>
                        <c:forEach var="movie" items="${movies}">
                            <option value="${movie.movieId}">${movie.title}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Show Date *</label>
                        <input type="date" name="showDate" required />
                    </div>
                    <div class="form-group">
                        <label>Show Time *</label>
                        <input type="time" name="showTime" required />
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Hall *</label>
                        <select name="hall" required>
                            <option value="Hall A">Hall A</option>
                            <option value="Hall B">Hall B</option>
                            <option value="Hall C">Hall C</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Total Seats *</label>
                        <input type="number" name="totalSeats"
                               value="60" min="10" max="60" required />
                    </div>
                </div>

                <div class="form-group">
                    <label>Ticket Price (Rs.) *</label>
                    <input type="number" name="price"
                           placeholder="e.g. 350" min="1" step="0.01" required />
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Add Showtime</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-movies"
                       class="btn btn-secondary">Cancel</a>
                </div>

            </form>
        </div>

    </main>
</div>

<%@ include file="/components/footer.jsp" %>
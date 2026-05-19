<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Payment Failed" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="container">
    <div class="confirmation-wrapper">
        <div class="confirmation-icon">❌</div>
        <h1 style="color:#e94560;">Payment Failed!</h1>
        <p class="confirmation-subtitle">
            Your payment was not completed. No amount has been deducted.
        </p>
        <div class="confirmation-actions">
            <a href="${pageContext.request.contextPath}/customer/movies"
               class="btn btn-primary">Try Again</a>
            <a href="${pageContext.request.contextPath}/customer/dashboard"
               class="btn btn-secondary">Go to Dashboard</a>
        </div>
    </div>
</div>

<%@ include file="/components/footer.jsp" %>
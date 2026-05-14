<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Customer Login" />
<c:set var="extraCSS" value="auth.css" />

<%@ include file="components/header.jsp" %>
<%@ include file="components/navbar.jsp" %>

<div class="auth-wrapper">
    <div class="auth-card">

        <div class="auth-header">
            <h2>
                <i class="fas fa-ticket-alt"></i> Welcome Back!
            </h2>
            <p>Login to book your favorite movie tickets instantly</p>
        </div>

        <%-- Error / Success Messages --%>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                ${error}
            </div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                ${param.success}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/customer/login" method="post">

            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope"></i> Email Address
                </label>
                <input type="email" id="email" name="email"
                       placeholder="Enter your email address"
                       value="${not empty param.email ? param.email : ''}"
                       required />
            </div>

            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock"></i> Password
                </label>
                <div class="password-wrapper">
                    <input type="password" id="password" name="password"
                           placeholder="Enter your password"
                           required />
                    <span class="toggle-password" onclick="togglePassword('password')">
                        <i class="fas fa-eye"></i>
                    </span>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-full">
                <i class="fas fa-sign-in-alt"></i> Login
            </button>

        </form>

        <div class="auth-footer">
            <p>
                <i class="fas fa-user-plus"></i> Don't have an account?
                <a href="${pageContext.request.contextPath}/customer/register">Register here</a>
            </p>
            <p>
                <i class="fas fa-crown"></i> Are you an admin?
                <a href="${pageContext.request.contextPath}/admin/login">Admin Login</a>
            </p>
            <p>
                <a href="${pageContext.request.contextPath}/">
                    <i class="fas fa-home"></i> ← Back to Home
                </a>
            </p>
        </div>

    </div>
</div>

<script>
    function togglePassword(fieldId) {
        const field = document.getElementById(fieldId);
        const icon = event.currentTarget.querySelector('i');
        
        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
    
    // Add Enter key submit
    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.querySelector('form').submit();
            }
        });
    });
</script>

<%@ include file="components/footer.jsp" %>
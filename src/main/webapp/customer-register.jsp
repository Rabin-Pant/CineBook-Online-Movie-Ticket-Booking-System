<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="Customer Register" />
<c:set var="extraCSS" value="auth.css" />

<%@ include file="components/header.jsp" %>
<%@ include file="components/navbar.jsp" %>

<div class="auth-wrapper">
    <div class="auth-card auth-card-wide">

        <div class="auth-header">
            <h2>
                <i class="fas fa-user-plus"></i> Create Account
            </h2>
            <p>Join CineBook and experience hassle-free movie ticket booking</p>
        </div>

        <%-- Error Message --%>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i>
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/customer/register" method="post">

            <%-- ROW 1: Side-by-Side Grid (Full Name & Phone Number) --%>
            <div class="form-row">
                <div class="form-group">
                    <label for="fullName">
                        <i class="fas fa-user"></i> Full Name
                    </label>
                    <input type="text" id="fullName" name="fullName"
                           placeholder="Enter your full name"
                           value="${not empty param.fullName ? param.fullName : ''}"
                           required />
                </div>

                <div class="form-group">
                    <label for="phone">
                        <i class="fas fa-phone"></i> Phone Number
                    </label>
                    <input type="text" id="phone" name="phone"
                           placeholder="98XXXXXXXX"
                           value="${not empty param.phone ? param.phone : ''}"
                           maxlength="10"
                           required />
                </div>
            </div>

            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope"></i> Email Address
                </label>
                <input type="email" id="email" name="email"
                       placeholder="yourname@gmail.com"
                       value="${not empty param.email ? param.email : ''}"
                       required />
                       <small style="color:#888;">
        Accepted: Gmail, Yahoo, Hotmail, Outlook
    </small>
            </div>

            <%-- ROW 3: Side-by-Side Grid (Password fields) --%>
            <div class="form-row">
                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i> Password
                    </label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password"
                               placeholder="Minimum 6 characters"
                               required />
                        <span class="toggle-password" onclick="togglePassword('password')">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                    <small style="color: #888; font-size: 0.75rem;">Password must be at least 6 characters</small>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fas fa-check-circle"></i> Confirm Password
                    </label>
                    <div class="password-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Repeat your password"
                               required />
                        <span class="toggle-password" onclick="togglePassword('confirmPassword')">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-full">
                <i class="fas fa-user-check"></i> Create Account
            </button>

        </form>

        <div class="auth-footer">
            <p>
                <i class="fas fa-sign-in-alt"></i> Already have an account?
                <a href="${pageContext.request.contextPath}/customer/login">Login here</a>
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
    
    // Real-time password match validation
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    
    function validatePasswordMatch() {
        if (password.value !== confirmPassword.value) {
            confirmPassword.setCustomValidity("Passwords do not match");
        } else {
            confirmPassword.setCustomValidity("");
        }
    }
    
    password.addEventListener('change', validatePasswordMatch);
    confirmPassword.addEventListener('keyup', validatePasswordMatch);
</script>

<%@ include file="components/footer.jsp" %>
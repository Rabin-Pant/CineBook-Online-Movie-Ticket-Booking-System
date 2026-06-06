<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<c:set var="pageTitle" value="My Profile" />
<c:set var="extraCSS" value="profile.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="dashboard-container">
    
    <%-- Header Section with Welcome Message --%>
    <div class="dashboard-header">
        <div>
            <h1>Welcome back, <span class="gradient-text">${sessionScope.loggedInCustomer.fullName}</span>!</h1>
            <p class="header-subtitle">Manage your account settings and preferences.</p>
        </div>
        <div class="profile-avatar-large">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInCustomer.profilePicture}">
                    <img src="${pageContext.request.contextPath}/uploads/${sessionScope.loggedInCustomer.profilePicture}" alt="Profile">
                </c:when>
                <c:otherwise>
                    <div class="avatar-placeholder">
                        ${fn:substring(sessionScope.loggedInCustomer.fullName, 0, 1)}
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- Tab Navigation --%>
    <div class="dashboard-tabs">
        <button class="tab-btn active" onclick="switchTab('profile')">Profile Settings</button>
        <button class="tab-btn" onclick="switchTab('security')">Security & Password</button>
    </div>

    <%-- Tab 1: Profile Settings --%>
    <div id="profileTab" class="tab-content active">
        <div class="content-card">
            <h3>Profile Information</h3>
            
            <%-- Success/Error Messages --%>
            <c:if test="${not empty success}">
                <div class="alert alert-success">✓ ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">⚠ ${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/customer/profile" method="post" enctype="multipart/form-data">
                <div class="form-row-2col">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" value="${sessionScope.loggedInCustomer.fullName}" required />
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" value="${sessionScope.loggedInCustomer.email}" disabled />
                    </div>
                </div>
                
                <div class="form-row-2col">
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" value="${sessionScope.loggedInCustomer.phone}" disabled />
                    </div>
                    <div class="form-group">
                        <label>Profile Picture</label>
                        <div class="pic-upload-wrapper">
                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedInCustomer.profilePicture}">
                                    <img src="${pageContext.request.contextPath}/uploads/${sessionScope.loggedInCustomer.profilePicture}" 
                                         id="picPreview" class="pic-preview-img"/>
                                </c:when>
                                <c:otherwise>
                                    <div id="picPreview" class="pic-preview-placeholder">👤 No photo</div>
                                </c:otherwise>
                            </c:choose>
                            <label for="profilePicture" class="pic-upload-btn">📷 Choose Photo</label>
                            <input type="file" id="profilePicture" name="profilePicture" accept="image/*" 
                                   onchange="previewPicture(this)" style="display: none;"/>
                            <small>JPG, PNG, WEBP (Max 5MB)</small>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary">Save Profile Changes</button>
            </form>
        </div>
    </div>

    <%-- Tab 2: Security & Password --%>
    <div id="securityTab" class="tab-content">
        <div class="content-card">
            <h3>Change Password</h3>
            <form action="${pageContext.request.contextPath}/customer/change-password" method="post">
                <div class="form-group">
                    <label>Current Password</label>
                    <input type="password" name="currentPassword" placeholder="Enter current password" required />
                </div>
                
                <div class="form-row-2col">
                    <div class="form-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" minlength="6" placeholder="At least 6 characters" required />
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" placeholder="Repeat new password" required />
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary">Update Password</button>
            </form>
        </div>
    </div>
    
</div>

<script>
    // Tab switching function
    function switchTab(tabName) {
        // Hide all tabs
        document.getElementById('profileTab').classList.remove('active');
        document.getElementById('securityTab').classList.remove('active');
        
        // Remove active class from all buttons
        const buttons = document.querySelectorAll('.tab-btn');
        buttons.forEach(btn => btn.classList.remove('active'));
        
        // Show selected tab
        if (tabName === 'profile') {
            document.getElementById('profileTab').classList.add('active');
            buttons[0].classList.add('active');
        } else if (tabName === 'security') {
            document.getElementById('securityTab').classList.add('active');
            buttons[1].classList.add('active');
        }
    }
    
    // Preview picture before upload
    function previewPicture(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('picPreview');
                if (preview.tagName === 'IMG') {
                    preview.src = e.target.result;
                } else {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.id = 'picPreview';
                    img.className = 'pic-preview-img';
                    preview.parentNode.replaceChild(img, preview);
                }
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>

<%@ include file="/components/footer.jsp" %>
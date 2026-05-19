<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="pageTitle" value="My Profile" />
<c:set var="extraCSS" value="profile.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="container" style="max-width: 1200px; margin: 0 auto; padding: 40px 20px;">

    <h1 class="page-title" style="text-align: center; margin-bottom: 40px; font-size: 2.5rem; background: linear-gradient(135deg, #e94560, #667eea); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">
        👤 My Profile
    </h1>

    <c:if test="${not empty success}">
        <div class="alert alert-success" style="background: linear-gradient(135deg, #d4edda, #c3e6cb); border-left: 4px solid #28a745; padding: 15px 20px; border-radius: 10px; margin-bottom: 20px;">
            <strong>✓ Success!</strong> ${success}
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error" style="background: linear-gradient(135deg, #f8d7da, #f5c6cb); border-left: 4px solid #dc3545; padding: 15px 20px; border-radius: 10px; margin-bottom: 20px;">
            <strong>⚠ Error!</strong> ${error}
        </div>
    </c:if>

    <div class="profile-wrapper">

        <div class="profile-card">
            <div class="profile-pic-wrapper">
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInCustomer.profilePicture}">
                        <img src="${pageContext.request.contextPath}/uploads/${sessionScope.loggedInCustomer.profilePicture}" alt="Profile Picture" class="profile-pic-img"/>
                    </c:when>
                    <c:otherwise>
                        <div class="profile-avatar">
                            <%
                                String fullName = ((com.cinebook.model.Customer) session.getAttribute("loggedInCustomer")).getFullName();
                                out.print(fullName.substring(0, 1).toUpperCase());
                            %>
                        </div>
                    </c:otherwise>
                </c:choose>

                <label for="quickPicUpload" class="profile-pic-overlay" title="Change Photo">
                    📷
                </label>
            </div>

            <h3>${sessionScope.loggedInCustomer.fullName}</h3>
            <p>${sessionScope.loggedInCustomer.email}</p>
            <p>📞 ${sessionScope.loggedInCustomer.phone}</p>
            <p class="member-since">
                Member since ${sessionScope.loggedInCustomer.createdAt}
            </p>
        </div>

        <div class="profile-form card">
            <h3>Update Profile</h3>

           <form action="${pageContext.request.contextPath}/customer/profile" method="post" enctype="multipart/form-data">
    
    <div class="form-group">
        <label>Profile Picture</label>
        <div class="pic-upload-area">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInCustomer.profilePicture}">
                    <img src="${pageContext.request.contextPath}/uploads/${sessionScope.loggedInCustomer.profilePicture}" alt="Current" id="picPreview" class="pic-preview-img"/>
                </c:when>
                <c:otherwise>
                    <div id="picPreview" class="pic-preview-placeholder">
                        👤 No photo uploaded
                    </div>
                </c:otherwise>
            </c:choose>
            <label for="profilePicture" class="pic-upload-btn">
                📷 Choose Photo
            </label>
            <input type="file" id="profilePicture" name="profilePicture" accept="image/*" onchange="previewPicture(this)"/>
            <small style="color:#888;">JPG, PNG, WEBP accepted (Max 5MB)</small>
        </div>
    </div>

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" value="${sessionScope.loggedInCustomer.fullName}" required />
                </div>

                <div class="form-group">
    <label>Phone Number</label>
    <input type="text" 
           value="${sessionScope.loggedInCustomer.phone}" 
           disabled />
    <small style="color:#888; display: block; margin-top: 4px;">
        Registered phone number cannot be changed.
    </small>
</div>

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" value="${sessionScope.loggedInCustomer.email}" disabled />
                    <small style="color:#888;">Email cannot be changed</small>
                </div>

                <button type="submit" class="btn btn-primary">
                    Update Profile
                </button>
            </form>

            <hr style="margin: 28px 0; border-color: #eee;">
            <h3>Change Password</h3>
            <form action="${pageContext.request.contextPath}/customer/change-password" method="post">
                <div class="form-group">
                    <label>Current Password</label>
                    <input type="password" name="currentPassword" required />
                </div>
                <div class="form-group">
                    <label>New Password</label>
                    <input type="password" name="newPassword" minlength="6" required />
                </div>
                <div class="form-group">
                    <label>Confirm New Password</label>
                    <input type="password" name="confirmPassword" required />
                </div>
                <button type="submit" class="btn btn-secondary">
                    Change Password
                </button>
            </form>
        </div>

    </div> </div> <script>
    // Preview picture before upload
    function previewPicture(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('picPreview');
                if (preview.tagName === 'IMG') {
                    preview.src = e.target.result;
                } else {
                    // Replace placeholder div with img
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
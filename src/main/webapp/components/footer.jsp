<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="footer">
    <div class="footer-container">

        <div class="footer-brand">
            <h3>🎬 CineBook</h3>
            <p>Your ultimate online movie ticket booking platform. Experience the magic of cinema with just a few clicks.</p>
            <p style="margin-top: 15px; font-size: 0.85rem;">⭐ Rated 4.8/5 by 10,000+ happy customers</p>
        </div>

        <div class="footer-links">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/">🏠 Home</a></li>
                <li><a href="${pageContext.request.contextPath}/customer/movies">🎬 Movies</a></li>
                <li><a href="${pageContext.request.contextPath}/customer/login">🔐 Login</a></li>
                <li><a href="${pageContext.request.contextPath}/customer/register">✨ Register</a></li>
            </ul>
        </div>

        <div class="footer-contact">
            <h4>Contact Us</h4>
            <p>📧 support@cinebook.com</p>
            <p>📞 +977-9800000000</p>
            <p>📍 Kathmandu, Nepal</p>
            <p>🕒 Mon-Sun: 9AM - 9PM</p>
            <div style="margin-top: 15px; display: flex; gap: 15px;">
                <a href="#" style="color: #ccc; font-size: 1.2rem;">📘</a>
                <a href="#" style="color: #ccc; font-size: 1.2rem;">📷</a>
                <a href="#" style="color: #ccc; font-size: 1.2rem;">🐦</a>
                <a href="#" style="color: #ccc; font-size: 1.2rem;">💬</a>
            </div>
        </div>

    </div>
    <div class="footer-bottom">
        <p>&copy; 2026 CineBook. All rights reserved.</p>
    </div>
</footer>

<script>
    // Add year automatically
    document.querySelector('.footer-bottom p').innerHTML = 
        document.querySelector('.footer-bottom p').innerHTML.replace('2026', new Date().getFullYear());
</script>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar">
    <div class="nav-container">

        <!-- Logo -->
        <a href="${pageContext.request.contextPath}/" class="nav-logo">
            🎬 CineBook
        </a>

      <!-- Search Bar -->
<div class="nav-search-wrapper">
    <form id="searchForm"
          action="${pageContext.request.contextPath}/customer/search"
          method="get"
          style="display: flex; align-items: center;">
        <div class="search-interactive" id="searchInteractive" style="display: flex; align-items: center;">
            <input type="text"
                   class="search-input"
                   id="searchInput"
                   name="q"
                   placeholder="Search movies..."
                   autocomplete="off"
                   value="${not empty param.q ? param.q : ''}"
                   style="width: 0; opacity: 0; border: none; outline: none; background: transparent; font-size: 0.95rem; color: #fff; padding: 0; margin: 0; transition: all 0.35s ease;" />
            <button class="clear-button" id="clearButton"
                    type="button" aria-label="Clear search"
                    style="display: none; background: transparent; border: none; color: rgba(255,255,255,0.6); cursor: pointer; padding: 5px;">
                ✕
            </button>
            <button class="search-icon-btn" id="searchIconBtn"
                    type="button" aria-label="Search"
                    style="background: #e94560; border: none; width: 42px; height: 42px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; color: white; font-size: 18px; flex-shrink: 0;">
                🔍
            </button>
        </div>
    </form>
</div>
        <!-- Nav Links -->
        <ul class="nav-links" id="navLinks">
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/customer/movies">Movies</a></li>

            <c:choose>
                <%-- Customer logged in --%>
                <c:when test="${not empty sessionScope.loggedInCustomer}">
                    <li>
                        <a href="${pageContext.request.contextPath}/customer/dashboard">
                            Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/customer/bookings">
                            My Bookings
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/customer/profile">
                            Profile
                        </a>
                    </li>
                    <li class="logout-li">
                        <a href="${pageContext.request.contextPath}/customer/logout"
                           class="btn-logout">
                            Logout (${sessionScope.loggedInCustomer.fullName})
                        </a>
                    </li>
                </c:when>

                <%-- Admin logged in --%>
                <c:when test="${not empty sessionScope.loggedInAdmin}">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            Admin Panel
                        </a>
                    </li>
                    <li class="logout-li">
                        <a href="${pageContext.request.contextPath}/admin/logout"
                           class="btn-logout">
                            Logout (${sessionScope.loggedInAdmin.fullName})
                        </a>
                    </li>
                </c:when>

                <%-- Guest --%>
                <c:otherwise>
                    <li>
                        <a href="${pageContext.request.contextPath}/customer/login"
                           class="btn-login">Login</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/customer/register"
                           class="btn-register">Register</a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>

        <!-- Hamburger -->
        <div class="hamburger" id="hamburger" onclick="toggleMenu()">
            <span></span>
            <span></span>
            <span></span>
        </div>

    </div>
</nav>

<script>
(function() {
    const searchInteractive = document.getElementById('searchInteractive');
    const searchInput = document.getElementById('searchInput');
    const searchIconBtn = document.getElementById('searchIconBtn');
    const clearButton = document.getElementById('clearButton');
    const searchForm = document.getElementById('searchForm');
    
    let isExpanded = false;
    
    // if there's a search query in the URL
    const urlParams = new URLSearchParams(window.location.search);
    const hasQuery = urlParams.get('q') && urlParams.get('q').trim() !== '';
    
    // If there's a query, expand immediately
    if (hasQuery) {
        expandSearch();
    }
    
    function expandSearch() {
        isExpanded = true;
        searchInput.style.width = '220px';
        searchInput.style.opacity = '1';
        searchInput.style.padding = '0 10px';
        searchInput.style.marginLeft = '10px';
        searchInput.focus();
        updateClearButton();
    }
    
    function collapseSearch() {
        if (searchInput.value.trim() === '') {
            isExpanded = false;
            searchInput.style.width = '0';
            searchInput.style.opacity = '0';
            searchInput.style.padding = '0';
            searchInput.style.marginLeft = '0';
            searchInput.blur();
            clearButton.style.display = 'none';
        }
    }
    
    function updateClearButton() {
        if (searchInput.value.trim() !== '') {
            clearButton.style.display = 'block';
        } else {
            clearButton.style.display = 'none';
        }
    }
    
    // Click on search icon
    searchIconBtn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        if (!isExpanded) {
            // Expand the search
            expandSearch();
        } else if (searchInput.value.trim() !== '') {
            // Submit the form
            searchForm.submit();
        } else {
            // Collapse
            collapseSearch();
        }
    });
    
    // Clear button
    clearButton.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        searchInput.value = '';
        updateClearButton();
        searchInput.focus();
    });
    
    // Typing in input
    searchInput.addEventListener('input', function() {
        updateClearButton();
    });
    
    // Enter key submits
    searchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && searchInput.value.trim() !== '') {
            e.preventDefault();
            searchForm.submit();
        }
        if (e.key === 'Escape') {
            searchInput.value = '';
            updateClearButton();
            collapseSearch();
        }
    });
    
    // Click outside collapses (if empty)
    document.addEventListener('click', function(e) {
        if (!searchInteractive.contains(e.target) && isExpanded && searchInput.value.trim() === '') {
            collapseSearch();
        }
    });
    
    console.log('Search bar ready!');
})();
</script>
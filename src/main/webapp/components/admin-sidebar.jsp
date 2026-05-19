<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<%-- Get current URI for active link detection --%>
<%
    String currentURI = request.getRequestURI();
    pageContext.setAttribute("currentURI", currentURI);
%>

<style>
    .admin-sidebar {
        width: 280px;
        background: linear-gradient(180deg, #1a1a2e 0%, #0f0f1a 100%);
        color: #fff;
        flex-shrink: 0;
        min-height: calc(100vh - 70px);
        padding: 25px 0;
        border-right: 1px solid rgba(233,69,96,0.1);
    }
    
    .sidebar-menu {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    
    .sidebar-menu li {
        margin: 8px 0;
    }
    
    .sidebar-menu li a {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 12px 24px;
        color: #aaa;
        text-decoration: none;
        transition: all 0.3s ease;
        font-size: 0.95rem;
        font-weight: 500;
        border-left: 3px solid transparent;
    }
    
    .sidebar-menu li a:hover {
        background: rgba(233, 69, 96, 0.08);
        color: #e94560;
        border-left-color: #e94560;
        padding-left: 28px;
    }
    
    .sidebar-menu li a.active {
        background: rgba(233, 69, 96, 0.12);
        color: #e94560;
        border-left-color: #e94560;
        font-weight: 600;
    }
    
    .sidebar-menu li a i {
        width: 24px;
        font-size: 1.2rem;
    }
    
    /* Sidebar Footer */
    .sidebar-footer {
        position: absolute;
        bottom: 20px;
        left: 0;
        right: 0;
        padding: 20px 24px;
        border-top: 1px solid rgba(255,255,255,0.05);
        font-size: 0.75rem;
        color: #666;
        text-align: center;
    }
    
    @media (max-width: 768px) {
        .admin-sidebar {
            width: 100%;
            min-height: auto;
            position: relative;
        }
        
        .sidebar-menu {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            padding: 10px;
        }
        
        .sidebar-menu li {
            margin: 0;
        }
        
        .sidebar-menu li a {
            padding: 8px 16px;
            border-radius: 30px;
            border-left: none;
        }
        
        .sidebar-menu li a:hover {
            padding-left: 16px;
        }
        
        .sidebar-footer {
            display: none;
        }
    }
</style>

<aside class="admin-sidebar">
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="${currentURI.contains('dashboard') ? 'active' : ''}">
                📊 Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/manage-movies"
               class="${currentURI.contains('movie') ? 'active' : ''}">
                🎬 Manage Movies
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/add-showtime"
               class="${currentURI.contains('showtime') ? 'active' : ''}">
                🕐 Add Showtime
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/bookings"
               class="${currentURI.contains('booking') ? 'active' : ''}">
                🎟️ Bookings
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/users"
               class="${currentURI.contains('user') ? 'active' : ''}">
                👥 Customers
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/reports"
               class="${currentURI.contains('report') ? 'active' : ''}">
                📈 Reports
            </a>
        </li>
    </ul>
    
    <div class="sidebar-footer">
        <p>CineBook v1.0</p>
        <p>© 2025 Admin Panel</p>
    </div>
</aside>
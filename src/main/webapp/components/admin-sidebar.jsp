<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<%-- Get current URI for active link detection --%>
<%
    String currentURI = request.getRequestURI();
    pageContext.setAttribute("currentURI", currentURI);
%>

<!-- Font Awesome 6 (Free) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    .admin-sidebar {
        width: 280px;
        background: linear-gradient(180deg, #0f0c29 0%, #1a1a2e 50%, #16213e 100%);
        color: #fff;
        flex-shrink: 0;
        min-height: calc(100vh - 70px);
        padding: 30px 0 20px 0;
        border-right: 1px solid rgba(233, 69, 96, 0.15);
        position: relative;
        transition: all 0.3s ease;
    }
    
    /* Sidebar Header / Brand */
    .sidebar-brand {
        padding: 0 24px 25px 24px;
        margin-bottom: 10px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }
    
    .sidebar-brand h4 {
        margin: 0;
        font-size: 1.25rem;
        font-weight: 600;
        background: linear-gradient(135deg, #fff 0%, #e94560 100%);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        letter-spacing: 0.5px;
    }
    
    .sidebar-brand p {
        margin: 8px 0 0 0;
        font-size: 0.7rem;
        color: rgba(255, 255, 255, 0.4);
        letter-spacing: 0.3px;
    }
    
    .sidebar-menu {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    
    .sidebar-menu li {
        margin: 4px 12px;
    }
    
    .sidebar-menu li a {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 12px 18px;
        color: rgba(255, 255, 255, 0.7);
        text-decoration: none;
        transition: all 0.25s ease;
        font-size: 0.9rem;
        font-weight: 500;
        border-radius: 12px;
        position: relative;
    }
    
    .sidebar-menu li a i {
        width: 22px;
        font-size: 1.1rem;
        text-align: center;
        transition: all 0.25s ease;
    }
    
    .sidebar-menu li a:hover {
        background: rgba(233, 69, 96, 0.12);
        color: #e94560;
        transform: translateX(4px);
    }
    
    .sidebar-menu li a:hover i {
        color: #e94560;
        transform: scale(1.05);
    }
    
    .sidebar-menu li a.active {
        background: linear-gradient(90deg, rgba(233, 69, 96, 0.18) 0%, rgba(233, 69, 96, 0.05) 100%);
        color: #e94560;
        font-weight: 600;
        box-shadow: inset 0 0 0 1px rgba(233, 69, 96, 0.2);
    }
    
    .sidebar-menu li a.active i {
        color: #e94560;
    }
    
    /* Badge for messages */
    .menu-badge {
        background: #e94560;
        color: white;
        padding: 2px 8px;
        border-radius: 20px;
        font-size: 0.7rem;
        font-weight: 600;
        margin-left: auto;
        box-shadow: 0 2px 6px rgba(233, 69, 96, 0.4);
    }
    
    /* Divider */
    .sidebar-divider {
        height: 1px;
        background: rgba(255, 255, 255, 0.06);
        margin: 20px 24px;
    }
    
    /* Sidebar Footer */
    .sidebar-footer {
        position: absolute;
        bottom: 20px;
        left: 0;
        right: 0;
        padding: 20px 24px;
        border-top: 1px solid rgba(255, 255, 255, 0.05);
        font-size: 0.7rem;
        color: rgba(255, 255, 255, 0.3);
        text-align: center;
    }
    
    .sidebar-footer i {
        margin-right: 6px;
        font-size: 0.7rem;
    }
    
    /* Tooltip style for collapsed state (if needed later) */
    .sidebar-menu li a .menu-text {
        transition: all 0.2s;
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .admin-sidebar {
            width: 100%;
            min-height: auto;
            position: relative;
            padding: 15px 0;
        }
        
        .sidebar-brand {
            display: none;
        }
        
        .sidebar-menu {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            padding: 0 12px;
        }
        
        .sidebar-menu li {
            margin: 0;
        }
        
        .sidebar-menu li a {
            padding: 8px 16px;
            border-radius: 30px;
            gap: 8px;
        }
        
        .sidebar-menu li a:hover {
            transform: none;
        }
        
        .sidebar-divider,
        .sidebar-footer {
            display: none;
        }
    }
    
    /* Scrollbar styling */
    .admin-sidebar::-webkit-scrollbar {
        width: 4px;
    }
    
    .admin-sidebar::-webkit-scrollbar-track {
        background: rgba(255, 255, 255, 0.05);
    }
    
    .admin-sidebar::-webkit-scrollbar-thumb {
        background: #e94560;
        border-radius: 4px;
    }
</style>

<aside class="admin-sidebar">
    <!-- Brand Section -->
    <div class="sidebar-brand">
        <h4>CineBook</h4>
        <p>Administrator Panel</p>
    </div>
    
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="${currentURI.contains('dashboard') ? 'active' : ''}">
                <i class="fas fa-chart-line"></i>
                <span class="menu-text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/manage-movies"
               class="${currentURI.contains('movie') ? 'active' : ''}">
                <i class="fas fa-film"></i>
                <span class="menu-text">Manage Movies</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/add-showtime"
               class="${currentURI.contains('showtime') ? 'active' : ''}">
                <i class="fas fa-clock"></i>
                <span class="menu-text">Add Showtime</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/bookings"
               class="${currentURI.contains('booking') ? 'active' : ''}">
                <i class="fas fa-ticket-alt"></i>
                <span class="menu-text">Bookings</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/users"
               class="${currentURI.contains('user') ? 'active' : ''}">
                <i class="fas fa-users"></i>
                <span class="menu-text">Customers</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/reports"
               class="${currentURI.contains('report') ? 'active' : ''}">
                <i class="fas fa-file-alt"></i>
                <span class="menu-text">Reports</span>
            </a>
        </li>
        
        <li>
            <%-- Instantiate the DAO directly inside the JSP to avoid compilation issues --%>
            <jsp:useBean id="sidebarMessageDAO" class="com.cinebook.dao.ContactMessageDAO" scope="page" />
            <c:set var="liveUnreadCount" value="${sidebarMessageDAO.unreadCount}" />

            <a href="${pageContext.request.contextPath}/admin/contact-messages"
               class="${currentURI.contains('contact') ? 'active' : ''}">
                <i class="fas fa-envelope"></i>
                <span class="menu-text">Messages</span>
                <c:if test="${liveUnreadCount > 0}">
                    <span class="menu-badge">${liveUnreadCount}</span>
                </c:if>
            </a>
        </li>
    </ul>
    
    <div class="sidebar-divider"></div>
    
    <div class="sidebar-footer">
        <i class="fas fa-shield-alt"></i> Secure Admin Access
    </div>
</aside>
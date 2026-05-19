<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    .admin-navbar {
        background: linear-gradient(90deg, #1a1a2e 0%, #16213e 100%);
        padding: 0 25px;
        position: sticky;
        top: 0;
        z-index: 1000;
        margin: 0;
        border-bottom: 1px solid rgba(233,69,96,0.2);
    }
    
    .admin-nav-container {
        max-width: 100%;
        margin: 0 auto;
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 60px;
    }
    
    .admin-nav-logo {
        font-size: 1.3rem;
        font-weight: 700;
        color: #e94560;
        text-decoration: none;
    }
    
    .admin-nav-logo span {
        font-size: 0.7rem;
        background: rgba(233,69,96,0.2);
        color: #e94560;
        padding: 2px 8px;
        border-radius: 20px;
        margin-left: 8px;
    }
    
    .admin-nav-right {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .admin-nav-right span {
        color: #fff;
        font-size: 0.85rem;
    }
    
    .btn-logout-admin {
        background: #dc3545;
        color: #fff;
        padding: 6px 16px;
        border-radius: 25px;
        text-decoration: none;
        font-size: 0.8rem;
        transition: all 0.3s ease;
    }
    
    .btn-logout-admin:hover {
        background: #c82333;
    }
    
    @media (max-width: 768px) {
        .admin-navbar {
            padding: 0 15px;
        }
        
        .admin-nav-container {
            height: 55px;
        }
        
        .admin-nav-logo {
            font-size: 1.1rem;
        }
        
        .admin-nav-right span {
            font-size: 0.75rem;
        }
        
        .btn-logout-admin {
            padding: 4px 12px;
            font-size: 0.7rem;
        }
    }
</style>

<nav class="admin-navbar">
    <div class="admin-nav-container">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-logo">
            🎬 CineBook <span>Admin</span>
        </a>
        <div class="admin-nav-right">
            <span>👤 ${sessionScope.loggedInAdmin.fullName}</span>
            <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout-admin">Logout</a>
        </div>
    </div>
</nav>
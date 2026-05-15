<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="CineBook - Book movie tickets online. Browse latest movies, select seats, and book instantly.">
    <meta name="keywords" content="movie tickets, online booking, cinema, cinebook">
    <meta name="author" content="CineBook">
    <title>CineBook - ${pageTitle != null ? pageTitle : 'Online Movie Booking'}</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.ico">
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Page-specific CSS -->
    <c:if test="${not empty extraCSS}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/${extraCSS}">
    </c:if>
    
    <style>
        /* Loading animation */
        .page-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: #1a1a2e;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            transition: opacity 0.5s ease;
        }
        
        .page-loader.hide {
            opacity: 0;
            pointer-events: none;
        }
        
        .loader-spinner {
            width: 50px;
            height: 50px;
            border: 3px solid rgba(233,69,96,0.3);
            border-top: 3px solid #e94560;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
    
    <script>
        // Hide loader when page loads
        window.addEventListener('load', function() {
            const loader = document.querySelector('.page-loader');
            if (loader) {
                setTimeout(() => {
                    loader.classList.add('hide');
                    setTimeout(() => loader.remove(), 500);
                }, 300);
            }
        });
    </script>
</head>
<body>

<!-- Page Loader -->
<div class="page-loader">
    <div class="loader-spinner"></div>
</div>
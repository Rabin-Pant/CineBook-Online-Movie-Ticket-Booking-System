package com.cinebook.utils;

import com.cinebook.model.Admin;
import com.cinebook.model.Customer;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {
    
    private static final String CUSTOMER_SESSION_KEY = "loggedInCustomer";
    private static final String ADMIN_SESSION_KEY = "loggedInAdmin";
    
    // ========== CUSTOMER SESSION METHODS ==========
    
    public static void setLoggedInCustomer(HttpServletRequest request, Customer customer) {
        HttpSession session = request.getSession();
        session.setAttribute(CUSTOMER_SESSION_KEY, customer);
        session.setMaxInactiveInterval(30 * 60); // 30 minutes
    }
    
    public static Customer getLoggedInCustomer(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (Customer) session.getAttribute(CUSTOMER_SESSION_KEY);
        }
        return null;
    }
    
    public static boolean isCustomerLoggedIn(HttpServletRequest request) {
        return getLoggedInCustomer(request) != null;
    }
    
    // ========== ADMIN SESSION METHODS ==========
    
    public static void setLoggedInAdmin(HttpServletRequest request, Admin admin) {
        HttpSession session = request.getSession();
        session.setAttribute(ADMIN_SESSION_KEY, admin);
        session.setMaxInactiveInterval(30 * 60); // 30 minutes
    }
    
    public static Admin getLoggedInAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (Admin) session.getAttribute(ADMIN_SESSION_KEY);
        }
        return null;
    }
    
    public static boolean isAdminLoggedIn(HttpServletRequest request) {
        return getLoggedInAdmin(request) != null;
    }
    
    // ========== GENERAL SESSION METHODS ==========
    
    /**
     * Check if ANY user (customer or admin) is logged in
     */
    public static boolean isAnyUserLoggedIn(HttpServletRequest request) {
        return isCustomerLoggedIn(request) || isAdminLoggedIn(request);
    }
    
    /**
     * Get the role of currently logged in user
     * Returns: "customer", "admin", or null if none logged in
     */
    public static String getUserRole(HttpServletRequest request) {
        if (isCustomerLoggedIn(request)) {
            return "customer";
        }
        if (isAdminLoggedIn(request)) {
            Admin admin = getLoggedInAdmin(request);
            return admin != null ? admin.getRole() : "admin";
        }
        return null;
    }
    
    /**
     * Logout customer
     */
    public static void logoutCustomer(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(CUSTOMER_SESSION_KEY);
        }
    }
    
    /**
     * Logout admin
     */
    public static void logoutAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(ADMIN_SESSION_KEY);
        }
    }
    
    /**
     * Logout all users (complete session invalidation)
     */
    public static void logoutAll(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
    
    // ========== HELPER METHODS ==========
    
    /**
     * Get customer ID if logged in
     */
    public static int getCurrentCustomerId(HttpServletRequest request) {
        Customer customer = getLoggedInCustomer(request);
        return customer != null ? customer.getCustomerId() : -1;
    }
    
    /**
     * Get admin ID if logged in
     */
    public static int getCurrentAdminId(HttpServletRequest request) {
        Admin admin = getLoggedInAdmin(request);
        return admin != null ? admin.getAdminId() : -1;
    }
}
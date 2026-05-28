package com.cinebook.controller;

import com.cinebook.model.Admin;
import com.cinebook.service.AdminService;
import com.cinebook.utils.DBConnection;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null) {
            request.setAttribute("error", "Please fill all fields");
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
            return;
        }

        // Check DB connection first
        if (!isDatabaseAvailable()) {
            request.setAttribute("error",
            		"⚠️ Service is temporarily unavailable. Please try again later.");
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
            return;
        }

        String ipAddress = request.getRemoteAddr();
        Admin admin = adminService.loginAdmin(email, password, ipAddress);

        if (admin != null) {
            SessionUtil.setLoggedInAdmin(request, admin);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
        }
    }

    private boolean isDatabaseAvailable() {
        try (Connection conn = DBConnection.getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (Exception e) {
            return false;
        }
    }
}
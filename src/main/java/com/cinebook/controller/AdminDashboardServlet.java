package com.cinebook.controller;

import com.cinebook.service.AdminService;
import com.cinebook.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private AdminService adminService;
    private BookingDAO   bookingDAO;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
        bookingDAO   = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all stats
        Map<String, Object> stats = adminService.getDashboardStats();

        // ✅ Fix total revenue — confirmed + cancellation fees
        BigDecimal confirmedRevenue = bookingDAO.getTotalRevenue();
        BigDecimal cancellationFees = bookingDAO.getTotalCancellationFees();
        BigDecimal totalActualRevenue = confirmedRevenue.add(cancellationFees);

        // Override with correct value
        stats.put("totalRevenue",           totalActualRevenue);
        stats.put("cancellationFeeRevenue", cancellationFees);

        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/pages/admin/dashboard.jsp")
               .forward(request, response);
    }
}
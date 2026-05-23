package com.cinebook.controller;

import com.cinebook.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/cancel-booking")
public class AdminCancelBookingServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            boolean cancelled = adminService.cancelBooking(bookingId);

            if (cancelled) {
                response.sendRedirect(request.getContextPath() +
                    "/admin/bookings?success=Booking cancelled successfully");
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/admin/bookings?error=Failed to cancel booking");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/bookings");
        }
    }
}
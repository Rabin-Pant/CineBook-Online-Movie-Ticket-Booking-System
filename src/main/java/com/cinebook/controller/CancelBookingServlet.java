package com.cinebook.controller;

import com.cinebook.dao.BookingDAO;
import com.cinebook.model.Booking;
import com.cinebook.model.Customer;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

@WebServlet("/customer/cancel-booking")
public class CancelBookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingId     = Integer.parseInt(request.getParameter("bookingId"));
            Booking booking   = bookingDAO.getBookingById(bookingId);
            Customer customer = SessionUtil.getLoggedInCustomer(request);

            if (booking == null || booking.getCustomerId() != customer.getCustomerId()) {
                response.sendRedirect(request.getContextPath() + "/customer/bookings");
                return;
            }

            BigDecimal totalAmount     = booking.getTotalAmount();
            BigDecimal cancellationFee = totalAmount.multiply(
                new BigDecimal("0.08")).setScale(2, RoundingMode.HALF_UP);
            BigDecimal refundAmount    = totalAmount.subtract(cancellationFee)
                .setScale(2, RoundingMode.HALF_UP);

            request.setAttribute("booking",         booking);
            request.setAttribute("cancellationFee", cancellationFee);
            request.setAttribute("refundAmount",    refundAmount);

            request.getRequestDispatcher("/WEB-INF/pages/customer/cancel-confirm.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingId     = Integer.parseInt(request.getParameter("bookingId"));
            Customer customer = SessionUtil.getLoggedInCustomer(request);
            Booking booking   = bookingDAO.getBookingById(bookingId);

            if (booking == null || booking.getCustomerId() != customer.getCustomerId()) {
                response.sendRedirect(request.getContextPath() + "/customer/bookings");
                return;
            }

            boolean cancelled = bookingDAO.cancelBooking(bookingId);

            if (cancelled) {
                Booking cancelledBooking = bookingDAO.getBookingById(bookingId);
                request.setAttribute("booking", cancelledBooking);
                request.getRequestDispatcher("/WEB-INF/pages/customer/cancel-success.jsp")
                       .forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/customer/bookings?error=Failed to cancel booking");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
        }
    }
}
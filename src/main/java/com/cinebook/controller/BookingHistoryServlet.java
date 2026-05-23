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
import java.util.List;

@WebServlet("/customer/bookings")
public class BookingHistoryServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Customer customer = SessionUtil.getLoggedInCustomer(request);

        // ✅ Use BookingDAO directly — includes all refund/cancel fields
        List<Booking> bookings = bookingDAO.getBookingsByCustomer(
            customer.getCustomerId());

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/WEB-INF/pages/customer/booking-history.jsp")
               .forward(request, response);
    }
}
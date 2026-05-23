package com.cinebook.controller;

import com.cinebook.dao.BookingDAO;
import com.cinebook.dao.CustomerDAO;
import com.cinebook.dao.MovieDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/reports")
public class ReportsServlet extends HttpServlet {

    private BookingDAO   bookingDAO;
    private CustomerDAO  customerDAO;
    private MovieDAO     movieDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO  = new BookingDAO();
        customerDAO = new CustomerDAO();
        movieDAO    = new MovieDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BigDecimal confirmedRevenue   = bookingDAO.getTotalRevenue();
        BigDecimal cancellationFees   = bookingDAO.getTotalCancellationFees();
        BigDecimal totalActualRevenue = confirmedRevenue.add(cancellationFees);

        request.setAttribute("totalBookings",          bookingDAO.getTotalBookingCount());
        request.setAttribute("totalRevenue",           confirmedRevenue);
        request.setAttribute("cancellationFeeRevenue", cancellationFees);
        request.setAttribute("totalActualRevenue",     totalActualRevenue);
        request.setAttribute("totalCustomers",         customerDAO.getTotalCustomerCount());
        request.setAttribute("totalMovies",            movieDAO.getAllMovies().size());
        request.setAttribute("bookings",               bookingDAO.getAllBookings());

        request.getRequestDispatcher("/WEB-INF/pages/admin/reports.jsp")
               .forward(request, response);
    }
}
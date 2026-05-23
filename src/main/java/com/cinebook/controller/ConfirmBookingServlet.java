package com.cinebook.controller;

import com.cinebook.model.Customer;
import com.cinebook.service.BookingService;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/customer/confirm-booking")
public class ConfirmBookingServlet extends HttpServlet {
    
    private BookingService bookingService;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Customer customer = SessionUtil.getLoggedInCustomer(request);
        int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
        String[] selectedSeats = request.getParameterValues("seats");
        
        if (selectedSeats == null || selectedSeats.length == 0) {
            response.sendRedirect(request.getContextPath() + "/customer/seats?showtimeId=" + showtimeId + "&error=Please select at least one seat");
            return;
        }
        
        List<Integer> seatIds = Arrays.stream(selectedSeats)
                .map(Integer::parseInt)
                .collect(Collectors.toList());
        
        int bookingId = bookingService.createBooking(customer.getCustomerId(), showtimeId, seatIds);
        
        if (bookingId > 0) {
            response.sendRedirect(request.getContextPath() + "/customer/booking-confirmation?bookingId=" + bookingId);
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/seats?showtimeId=" + showtimeId + "&error=Booking failed. Seats may have been taken.");
        }
    }
}
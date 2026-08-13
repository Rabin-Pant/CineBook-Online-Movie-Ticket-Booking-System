package com.cinebook.controller;

import com.cinebook.model.Customer;
import com.cinebook.model.Seat;
import com.cinebook.service.SeatService;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// Atomically claims a temporary hold on the requested seats before the user is sent
// to the payment gateway, so only one of two simultaneous buyers can proceed.
@WebServlet("/customer/check-seats")
public class CheckSeatsServlet extends HttpServlet {

    private SeatService seatService;

    @Override
    public void init() throws ServletException {
        seatService = new SeatService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Customer customer = SessionUtil.getLoggedInCustomer(request);
        if (customer == null) {
            response.getWriter().write("{\"allAvailable\":false,\"bookedSeats\":[],\"error\":\"Please log in to continue.\"}");
            return;
        }

        int showtimeId;
        try {
            showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"allAvailable\":false,\"bookedSeats\":[]}");
            return;
        }

        String seatIdsParam = request.getParameter("seatIds");
        if (seatIdsParam == null || seatIdsParam.trim().isEmpty()) {
            response.getWriter().write("{\"allAvailable\":true,\"bookedSeats\":[]}");
            return;
        }

        List<Integer> requestedIds = new ArrayList<>();
        for (String idStr : seatIdsParam.split(",")) {
            try {
                requestedIds.add(Integer.parseInt(idStr.trim()));
            } catch (NumberFormatException ignored) {
                // skip malformed entries
            }
        }

        boolean claimed = seatService.holdSeats(showtimeId, requestedIds, customer.getCustomerId());
        if (claimed) {
            response.getWriter().write("{\"allAvailable\":true,\"bookedSeats\":[]}");
            return;
        }

        // Find out which of the requested seats are actually unavailable right now
        List<Seat> currentSeats = seatService.getSeatsByShowtime(showtimeId, customer.getCustomerId());
        StringBuilder unavailableJson = new StringBuilder();
        for (Seat seat : currentSeats) {
            if (!requestedIds.contains(seat.getSeatId())) continue;
            if (seat.isBooked() || seat.isProcessing()) {
                if (unavailableJson.length() > 0) unavailableJson.append(",");
                String reason = seat.isBooked() ? "booked" : "processing";
                unavailableJson.append("{\"seatId\":").append(seat.getSeatId())
                               .append(",\"seatNumber\":\"").append(seat.getSeatNumber())
                               .append("\",\"reason\":\"").append(reason).append("\"}");
            }
        }

        response.getWriter().write(
            "{\"allAvailable\":false,\"bookedSeats\":[" + unavailableJson + "]}"
        );
    }
}

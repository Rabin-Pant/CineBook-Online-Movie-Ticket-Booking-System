package com.cinebook.controller;

import com.cinebook.model.Seat;
import com.cinebook.model.Showtime;
import com.cinebook.service.SeatService;
import com.cinebook.service.ShowtimeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/seats")
public class SeatSelectionServlet extends HttpServlet {
    
    private SeatService seatService;
    private ShowtimeService showtimeService;
    
    @Override
    public void init() throws ServletException {
        seatService = new SeatService();
        showtimeService = new ShowtimeService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
        
        Showtime showtime = showtimeService.getShowtimeById(showtimeId);
        List<Seat> seats = seatService.getSeatsByShowtime(showtimeId);
        
        request.setAttribute("showtime", showtime);
        request.setAttribute("seats", seats);
        
        request.getRequestDispatcher("/WEB-INF/pages/customer/seats.jsp").forward(request, response);
    }
}
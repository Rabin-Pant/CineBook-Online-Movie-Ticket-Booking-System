package com.cinebook.controller;

import com.cinebook.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/add-showtime")
public class AddShowtimeServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Pass all movies to select from
        request.setAttribute("movies", adminService.getAllMovies());
        request.getRequestDispatcher("/WEB-INF/pages/admin/add-showtime.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int movieId       = Integer.parseInt(request.getParameter("movieId"));
            String showDate   = request.getParameter("showDate");
            String showTime   = request.getParameter("showTime");
            String hall       = request.getParameter("hall");
            int totalSeats    = Integer.parseInt(request.getParameter("totalSeats"));
            double price      = Double.parseDouble(request.getParameter("price"));

            boolean added = adminService.addShowtime(movieId, showDate, showTime,
                                                     hall, totalSeats, price);

            if (added) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-movies");
            } else {
                request.setAttribute("error", "Failed to add showtime.");
                request.setAttribute("movies", adminService.getAllMovies());
                request.getRequestDispatcher("/WEB-INF/pages/admin/add-showtime.jsp")
                       .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.setAttribute("movies", adminService.getAllMovies());
            request.getRequestDispatcher("/WEB-INF/pages/admin/add-showtime.jsp")
                   .forward(request, response);
        }
    }
}
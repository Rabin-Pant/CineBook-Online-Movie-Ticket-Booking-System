package com.cinebook.controller;

import com.cinebook.model.Movie;
import com.cinebook.model.Showtime;
import com.cinebook.service.MovieService;
import com.cinebook.service.ShowtimeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/showtimes")
public class ShowtimesServlet extends HttpServlet {
    
    private ShowtimeService showtimeService;
    private MovieService movieService;
    
    @Override
    public void init() throws ServletException {
        showtimeService = new ShowtimeService();
        movieService = new MovieService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int movieId = Integer.parseInt(request.getParameter("movieId"));
        
        Movie movie = movieService.getMovieById(movieId);
        List<Showtime> showtimes = showtimeService.getShowtimesByMovie(movieId);
        
        request.setAttribute("movie", movie);
        request.setAttribute("showtimes", showtimes);
        
        request.getRequestDispatcher("/WEB-INF/pages/customer/showtimes.jsp").forward(request, response);
    }
}
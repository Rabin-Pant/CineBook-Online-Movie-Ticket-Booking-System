package com.cinebook.controller;

import com.cinebook.service.MovieService;
import com.cinebook.service.CustomerService;
import com.cinebook.model.Movie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/home", ""}, loadOnStartup = 1)
public class HomeServlet extends HttpServlet {

    private MovieService movieService;
    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        System.out.println("DEBUG init() started");
        movieService = new MovieService();
        System.out.println("DEBUG MovieService created");
        customerService = new CustomerService();
        System.out.println("DEBUG CustomerService created");
        System.out.println("DEBUG customers=" + customerService.getTotalCustomerCount());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("DEBUG doGet() triggered");

        List<Movie> nowShowing = movieService.getNowShowingMovies();
        List<Movie> comingSoon = movieService.getComingSoonMovies();
        List<Movie> allMovies  = movieService.getAllMovies();

        request.setAttribute("nowShowingMovies", nowShowing);
        request.setAttribute("comingSoonMovies", comingSoon);
        request.setAttribute("totalMovies",      allMovies != null ? allMovies.size() : 0);
        request.setAttribute("totalHalls",       3);
        request.setAttribute("totalCustomers",   customerService.getTotalCustomerCount());

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
package com.cinebook.controller;

import com.cinebook.model.Movie;
import com.cinebook.service.MovieService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/search")
public class MovieSearchServlet extends HttpServlet {

    private MovieService movieService;

    @Override
    public void init() throws ServletException {
        movieService = new MovieService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("q");

        // ✅ If empty show error message instead of redirecting
        if (keyword == null || keyword.trim().isEmpty()) {
            request.setAttribute("results", null);
            request.setAttribute("keyword", "");
            request.setAttribute("emptySearch", true);
            request.getRequestDispatcher("/WEB-INF/pages/customer/search-results.jsp")
                   .forward(request, response);
            return;
        }

        List<Movie> results = movieService.searchMovies(keyword.trim());
        request.setAttribute("results",  results);
        request.setAttribute("keyword",  keyword.trim());
        request.setAttribute("emptySearch", false);
        request.getRequestDispatcher("/WEB-INF/pages/customer/search-results.jsp")
               .forward(request, response);
    }
}
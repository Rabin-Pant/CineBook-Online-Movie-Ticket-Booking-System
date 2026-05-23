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

@WebServlet("/customer/movies")
public class BrowseMoviesServlet extends HttpServlet {
    
    private MovieService movieService;
    
    @Override
    public void init() throws ServletException {
        movieService = new MovieService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status   = request.getParameter("status");
        String genre    = request.getParameter("genre");
        String language = request.getParameter("language");

        List<Movie> movies;

        if ("coming_soon".equals(status)) {
            movies = movieService.getComingSoonMovies();
        } else {
            movies = movieService.getNowShowingMovies();
        }

        // Apply genre filter if selected
        if (genre != null && !genre.isEmpty()) {
            movies = movies.stream()
                           .filter(m -> genre.equals(m.getGenre()))
                           .collect(java.util.stream.Collectors.toList());
        }

        // Apply language filter if selected
        if (language != null && !language.isEmpty()) {
            movies = movies.stream()
                           .filter(m -> language.equals(m.getLanguage()))
                           .collect(java.util.stream.Collectors.toList());
        }

        request.setAttribute("movies", movies);
        request.getRequestDispatcher("/WEB-INF/pages/customer/movies.jsp")
               .forward(request, response);
    }}
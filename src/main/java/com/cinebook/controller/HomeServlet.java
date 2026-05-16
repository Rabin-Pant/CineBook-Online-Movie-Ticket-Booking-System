package com.cinebook.controller;

import com.cinebook.service.MovieService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("")
public class HomeServlet extends HttpServlet {

    private MovieService movieService;

    @Override
    public void init() throws ServletException {
        movieService = new MovieService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("nowShowingMovies", movieService.getNowShowingMovies());
        request.setAttribute("comingSoonMovies", movieService.getComingSoonMovies());
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
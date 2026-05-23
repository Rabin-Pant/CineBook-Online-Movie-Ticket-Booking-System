package com.cinebook.controller;

import com.cinebook.model.Movie;
import com.cinebook.service.AdminService;
import com.cinebook.utils.FileUploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;

@WebServlet("/admin/edit-movie")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                 maxFileSize       = 1024 * 1024 * 10,
                 maxRequestSize    = 1024 * 1024 * 50)
public class EditMovieServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            Movie movie = adminService.getMovieById(movieId);

            if (movie == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-movies");
                return;
            }

            request.setAttribute("movie", movie);
            request.getRequestDispatcher("/WEB-INF/pages/admin/edit-movie.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/manage-movies");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int movieId        = Integer.parseInt(request.getParameter("movieId"));
            String title       = request.getParameter("title");
            String description = request.getParameter("description");
            String genre       = request.getParameter("genre");
            String language    = request.getParameter("language");
            String status      = request.getParameter("status");

            int duration = 0;
            try { duration = Integer.parseInt(request.getParameter("duration")); }
            catch (NumberFormatException e) { duration = 0; }

            double rating = 0.0;
            String ratingStr = request.getParameter("rating");
            try {
                if (ratingStr != null && !ratingStr.trim().isEmpty())
                    rating = Double.parseDouble(ratingStr);
            } catch (NumberFormatException e) { rating = 0.0; }

            // Keep existing poster if no new file
            Movie existingMovie = adminService.getMovieById(movieId);
            String posterUrl = existingMovie != null ? existingMovie.getPosterUrl() : null;

            Part filePart = request.getPart("poster");
            if (filePart != null && filePart.getSize() > 0) {
            	posterUrl = FileUploadUtil.saveUploadedFile(filePart, null);
            }

            // ✅ Build Movie object — no individual parameters
            Movie movie = new Movie();
            movie.setMovieId(movieId);
            movie.setTitle(title);
            movie.setDescription(description);
            movie.setGenre(genre);
            movie.setDuration(duration);
            movie.setLanguage(language);
            movie.setRating(rating);
            movie.setPosterUrl(posterUrl);
            movie.setStatus(status);

            boolean updated = adminService.updateMovie(movie);

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-movies");
            } else {
                request.setAttribute("error", "Failed to update movie.");
                request.setAttribute("movie", movie);
                request.getRequestDispatcher("/WEB-INF/pages/admin/edit-movie.jsp")
                       .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/edit-movie.jsp")
                   .forward(request, response);
        }
    }
}
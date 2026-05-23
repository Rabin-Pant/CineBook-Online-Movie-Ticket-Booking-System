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

@WebServlet("/admin/add-movie")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                 maxFileSize       = 1024 * 1024 * 10,
                 maxRequestSize    = 1024 * 1024 * 50)
public class AddMovieServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/admin/add-movie.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String genre = request.getParameter("genre");
            String language = request.getParameter("language");
            String status = request.getParameter("status");

            // ===== VALIDATION =====

            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Movie title is required.");
                request.getRequestDispatcher("/WEB-INF/pages/admin/add-movie.jsp")
                        .forward(request, response);
                return;
            }

     int duration;

            try {
                duration = Integer.parseInt(request.getParameter("duration"));

                if (duration <= 0) {
                    request.setAttribute("error", "Duration must be greater than 0.");
                    request.getRequestDispatcher("/WEB-INF/pages/admin/add-movie.jsp")
                            .forward(request, response);
                    return;
                }

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid duration value.");
                request.getRequestDispatcher("/WEB-INF/pages/admin/add-movie.jsp")
                        .forward(request, response);
                return;
            }

    // ===== OPTIONAL RATING =====

            double rating = 0.0;

            try {
                String ratingStr = request.getParameter("rating");

                if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                    rating = Double.parseDouble(ratingStr);
                }

            } catch (NumberFormatException e) {
                rating = 0.0;
            }

     // ===== IMAGE UPLOAD =====

            String posterUrl = "default-movie.jpg";

            try {
                Part filePart = request.getPart("poster");

                if (filePart != null && filePart.getSize() > 0) {
                    posterUrl = FileUploadUtil.saveUploadedFile(filePart, null);
                }

            } catch (Exception e) {
                System.out.println("Poster upload failed: " + e.getMessage());
            }

    // ===== CREATE MOVIE =====

            Movie movie = new Movie();

            movie.setTitle(title.trim());
            movie.setDescription(description != null ? description.trim() : "");
            movie.setGenre(genre != null ? genre.trim() : "");
            movie.setDuration(duration);
            movie.setLanguage(language != null ? language.trim() : "");
            movie.setRating(rating);
            movie.setPosterUrl(posterUrl);
            movie.setStatus(status != null ? status : "now_showing");

            boolean added = adminService.addMovie(movie);

            if (added) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-movies?success=Movie Added Successfully");
            } else {
                request.setAttribute("error", "Database failed to save movie.");
                request.getRequestDispatcher("/WEB-INF/pages/admin/add-movie.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("error", "System Error: " + e.getMessage());

            request.getRequestDispatcher("/WEB-INF/pages/admin/add-movie.jsp")
                    .forward(request, response);
        }
    }

}
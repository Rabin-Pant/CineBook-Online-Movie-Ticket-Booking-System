package com.cinebook.controller;

import com.cinebook.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/delete-movie")
public class DeleteMovieServlet extends HttpServlet {
    
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
            boolean deleted = adminService.deleteMovie(movieId);

            if (deleted) {
                response.sendRedirect(request.getContextPath() +
                    "/admin/manage-movies?success=Movie deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/admin/manage-movies?error=Failed to delete movie");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/manage-movies");
        }
    }
}
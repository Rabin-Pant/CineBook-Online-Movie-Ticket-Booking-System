package com.cinebook.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/privacy-policy", "/terms"})
public class PolicyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.endsWith("/privacy-policy")) {
            request.getRequestDispatcher("/privacy-policy.jsp")
                   .forward(request, response);
        } else if (uri.endsWith("/terms")) {
            request.getRequestDispatcher("/terms.jsp")
                   .forward(request, response);
        }
    }
}
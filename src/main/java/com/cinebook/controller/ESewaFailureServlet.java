package com.cinebook.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;

@WebServlet("/customer/esewa-failure")
public class ESewaFailureServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Log all params eSewa sends back
        System.out.println("=== eSewa Failure Params ===");
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String param = params.nextElement();
            System.out.println(param + " = " + request.getParameter(param));
        }
        System.out.println("============================");

        request.getRequestDispatcher("/WEB-INF/pages/customer/esewa-failure.jsp")
               .forward(request, response);
    }
}
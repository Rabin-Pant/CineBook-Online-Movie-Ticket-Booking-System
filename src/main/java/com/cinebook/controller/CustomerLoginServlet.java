package com.cinebook.controller;

import com.cinebook.model.Customer;
import com.cinebook.service.CustomerService;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/customer/login")
public class CustomerLoginServlet extends HttpServlet {

    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        customerService = new CustomerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/customer-login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill all fields!");
            request.getRequestDispatcher("/customer-login.jsp")
                   .forward(request, response);
            return;
        }

        Customer customer = customerService.loginCustomer(
            email.trim(), password);

        if (customer == null) {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("/customer-login.jsp")
                   .forward(request, response);
            return;
        }

        // Check if blocked
        if (!customer.isActive()) {
            request.setAttribute("error",
                "Your account has been blocked. Please <a href='" +
                request.getContextPath() + "/contact' style='color:#c0392b; font-weight:700; text-decoration:underline;'>contact support</a> to appeal.");
            request.getRequestDispatcher("/customer-login.jsp").forward(request, response);
            return;
        }

        SessionUtil.setLoggedInCustomer(request, customer);
        response.sendRedirect(request.getContextPath() + "/customer/dashboard");
    }
}
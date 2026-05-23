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

@WebServlet("/customer/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        customerService = new CustomerService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Customer customer = SessionUtil.getLoggedInCustomer(request);

        String currentPassword  = request.getParameter("currentPassword");
        String newPassword      = request.getParameter("newPassword");
        String confirmPassword  = request.getParameter("confirmPassword");

        // Validate passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match!");
            request.getRequestDispatcher("/WEB-INF/pages/customer/profile.jsp")
                   .forward(request, response);
            return;
        }

        // Validate new password length
        if (newPassword.length() < 6) {
            request.setAttribute("error", "New password must be at least 6 characters!");
            request.getRequestDispatcher("/WEB-INF/pages/customer/profile.jsp")
                   .forward(request, response);
            return;
        }

        boolean changed = customerService.changePassword(
            customer.getEmail(), currentPassword, newPassword
        );

        if (changed) {
            request.setAttribute("success", "Password changed successfully!");
        } else {
            request.setAttribute("error", "Current password is incorrect!");
        }

        request.getRequestDispatcher("/WEB-INF/pages/customer/profile.jsp")
               .forward(request, response);
    }
}
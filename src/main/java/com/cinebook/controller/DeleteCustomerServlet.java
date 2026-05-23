package com.cinebook.controller;

import com.cinebook.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/delete-customer")
public class DeleteCustomerServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            boolean deleted = adminService.deleteCustomer(customerId);

            if (deleted) {
                response.sendRedirect(request.getContextPath() +
                    "/admin/users?success=Customer deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/admin/users?error=Failed to delete customer");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
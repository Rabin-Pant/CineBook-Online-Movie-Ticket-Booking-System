package com.cinebook.controller;

import com.cinebook.dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/block-customer")
public class BlockCustomerServlet extends HttpServlet {

    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String action  = request.getParameter("action"); // "block" or "unblock"

            boolean success = false;

            if ("block".equals(action)) {
                success = customerDAO.blockCustomer(customerId);
            } else if ("unblock".equals(action)) {
                success = customerDAO.unblockCustomer(customerId);
            }

            if (success) {
                String msg = "block".equals(action) ? "Customer blocked successfully"
                                                    : "Customer unblocked successfully";
                response.sendRedirect(request.getContextPath() +
                    "/admin/users?success=" + msg);
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/admin/users?error=Action failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
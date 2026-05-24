package com.cinebook.controller;

import com.cinebook.dao.ContactMessageDAO;
import com.cinebook.model.Customer;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/customer/my-messages")
public class CustomerMessagesServlet extends HttpServlet {

    private ContactMessageDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new ContactMessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Customer customer = SessionUtil.getLoggedInCustomer(request);
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/customer/login");
            return;
        }

        request.setAttribute("myMessages",
            dao.getMessagesByCustomerId(customer.getCustomerId()));

        request.getRequestDispatcher("/WEB-INF/pages/customer/my-messages.jsp")
               .forward(request, response);
    }
}
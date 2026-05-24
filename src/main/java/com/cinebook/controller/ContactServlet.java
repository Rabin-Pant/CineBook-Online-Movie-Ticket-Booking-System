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

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private ContactMessageDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new ContactMessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Load customer's previous messages if logged in
        Customer customer = SessionUtil.getLoggedInCustomer(request);
        if (customer != null) {
            request.setAttribute("myMessages",
                dao.getMessagesByCustomerId(customer.getCustomerId()));
        }

        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name    = request.getParameter("name");
        String email   = request.getParameter("email");
        String phone   = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            subject == null || subject.trim().isEmpty() ||
            message == null || message.trim().length() < 10) {
            response.setStatus(400);
            response.getWriter().write("invalid");
            return;
        }

        Customer customer  = SessionUtil.getLoggedInCustomer(request);
        int      customerId = (customer != null) ? customer.getCustomerId() : -1;

        int id = dao.saveMessage(
            name.trim(), email.trim(), phone.trim(),
            subject.trim(), message.trim(), customerId
        );

        if (id > 0) {
            response.setStatus(200);
            response.getWriter().write("ok");
        } else {
            response.setStatus(500);
            response.getWriter().write("error");
        }
    }
}
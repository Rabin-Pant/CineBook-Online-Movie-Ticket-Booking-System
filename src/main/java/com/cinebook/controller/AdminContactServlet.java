package com.cinebook.controller;

import com.cinebook.utils.ContactMessageStore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/contact-messages")
public class AdminContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("messages", ContactMessageStore.getAll());
        request.getRequestDispatcher("/WEB-INF/pages/admin/contact-messages.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action    = request.getParameter("action");
        String messageId = request.getParameter("messageId");
        String replyText = request.getParameter("replyText");

        if ("reply".equals(action) && messageId != null && replyText != null
                && !replyText.trim().isEmpty()) {
            ContactMessageStore.addReply(messageId, replyText.trim());
        } else if ("clear".equals(action)) {
            ContactMessageStore.clear();
        }

        response.sendRedirect(request.getContextPath() + "/admin/contact-messages");
    }
}
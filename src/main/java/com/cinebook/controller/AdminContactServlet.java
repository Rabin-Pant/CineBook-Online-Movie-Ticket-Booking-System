package com.cinebook.controller;

import com.cinebook.dao.ContactMessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/contact-messages")
public class AdminContactServlet extends HttpServlet {

    private ContactMessageDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new ContactMessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("messages", dao.getAllMessages());
        request.setAttribute("unreadCount", dao.getUnreadCount());

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
            dao.addReply(Integer.parseInt(messageId), replyText.trim());

        } else if ("markRead".equals(action) && messageId != null) {
            dao.markAsRead(Integer.parseInt(messageId));

        } else if ("clear".equals(action)) {
            dao.clearAll();
        }

        response.sendRedirect(request.getContextPath() + "/admin/contact-messages");
    }
}
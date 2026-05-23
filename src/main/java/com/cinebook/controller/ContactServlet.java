package com.cinebook.controller;

import com.cinebook.model.Customer;
import com.cinebook.utils.ContactMessageStore;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    // Load customer's previous messages if logged in
	    Customer customer = SessionUtil.getLoggedInCustomer(request);
	    if (customer != null) {
	        request.setAttribute("myMessages",
	            ContactMessageStore.getByCustomerId(customer.getCustomerId()));
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

        // Get customer ID from session
        Customer customer = SessionUtil.getLoggedInCustomer(request);
        int customerId = (customer != null) ? customer.getCustomerId() : -1;

        ContactMessageStore.add(
        	    name.trim(), email.trim(), phone.trim(),
        	    subject.trim(), message.trim(), customerId
        	);

        response.setStatus(200);
        response.getWriter().write("ok");
    }
}
package com.cinebook.controller;

import com.cinebook.service.CustomerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/customer/register")
public class CustomerRegisterServlet extends HttpServlet {
    
    private CustomerService customerService;
    
    @Override
    public void init() throws ServletException {
        customerService = new CustomerService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/customer-register.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName       = request.getParameter("fullName");
        String email          = request.getParameter("email");
        String phone          = request.getParameter("phone");
        String password       = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
     // Privacy policy agreement check
        String agreeTerms = request.getParameter("agreeTerms");
        if (agreeTerms == null) {
            request.setAttribute("error", "You must agree to the Privacy Policy and Terms of Service!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/customer-register.jsp").forward(request, response);
            return;
        }

        // Check empty fields
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/customer-register.jsp")
                   .forward(request, response);
            return;
        }

        // Validate real email format
        String[] allowedDomains = {
        	    "@gmail.com", "@yahoo.com", "@hotmail.com",
        	    "@outlook.com", "@icloud.com", "@live.com",
        	    "@protonmail.com", "@ymail.com"
        	};

        	boolean validDomain = false;
        	for (String domain : allowedDomains) {
        	    if (email.trim().toLowerCase().endsWith(domain)) {
        	        validDomain = true;
        	        break;
        	    }
        	}

        	if (!validDomain) {
        	    request.setAttribute("error",
        	        "Please use a valid email (Gmail, Yahoo, Hotmail, Outlook etc.)");
        	    request.setAttribute("fullName", fullName);
        	    request.setAttribute("phone", phone);
        	    request.getRequestDispatcher("/customer-register.jsp")
        	           .forward(request, response);
        	    return;
        	}


        // Validate Nepali phone number
        // Must be 10 digits starting with 98 or 97
        String phoneRegex = "^(98|97)\\d{8}$";
        if (!phone.trim().matches(phoneRegex)) {
            request.setAttribute("error",
                "Please enter a valid Nepali phone number (98XXXXXXXX or 97XXXXXXXX)!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/customer-register.jsp")
                   .forward(request, response);
            return;
        }

        // Password length check
        if (password.length() < 6) {
            request.setAttribute("error",
                "Password must be at least 6 characters!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/customer-register.jsp")
                   .forward(request, response);
            return;
        }

        // Password match check
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/customer-register.jsp")
                   .forward(request, response);
            return;
        }

        // Check email already exists
        if (customerService.emailExists(email.trim())) {
            request.setAttribute("error",
                "This email is already registered!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/customer-register.jsp")
                   .forward(request, response);
            return;
        }

        // Register customer
        boolean registered = customerService.registerCustomer(
        	    fullName.trim(),
        	    email.trim().toLowerCase(),
        	    password,
        	    phone.trim()
        	);

        if (registered) {
            response.sendRedirect(request.getContextPath() +
                "/customer/login?success=Registration successful! Please login.");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/customer-register.jsp")
                   .forward(request, response);
        }
    }
}
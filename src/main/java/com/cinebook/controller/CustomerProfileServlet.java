package com.cinebook.controller;

import com.cinebook.model.Customer;
import com.cinebook.service.CustomerService;
import com.cinebook.utils.FileUploadUtil;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;

@WebServlet("/customer/profile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                 maxFileSize       = 1024 * 1024 * 5,
                 maxRequestSize    = 1024 * 1024 * 10)
public class CustomerProfileServlet extends HttpServlet {

    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        customerService = new CustomerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/customer/profile.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Customer customer = SessionUtil.getLoggedInCustomer(request);

        try {
            String fullName = request.getParameter("fullName");
            String phone    = request.getParameter("phone"); // Will arrive as null
            
            // Clean inputs
            if (fullName != null) fullName = fullName.trim();

            // SAFE GUARD: If phone is disabled/null, retain the existing phone number
            if (phone == null || phone.trim().isEmpty()) {
                phone = customer.getPhone(); 
            } else {
                phone = phone.trim();
            }

            System.out.println("=== PROFILE UPDATE DEBUG ===");
            System.out.println("Customer ID: " + customer.getCustomerId());
            System.out.println("Full Name: " + fullName);
            System.out.println("Phone: " + phone);

            // BACKEND VALIDATION RULES
            if (fullName == null || fullName.isEmpty()) {
                request.setAttribute("error", "Full Name cannot be empty.");
                request.getRequestDispatcher("/WEB-INF/pages/customer/profile.jsp").forward(request, response);
                return;
            }

            // Handle profile picture upload
            Part filePart = request.getPart("profilePicture");

            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (contentType != null && contentType.startsWith("image/")) {
                    String picturePath = FileUploadUtil.saveProfilePicture(filePart, null);
                    customerService.updateProfilePicture(customer.getCustomerId(), picturePath);
                }
            }

            // This safely saves the updated name while preserving the original phone number
            customerService.updateProfile(customer.getCustomerId(), fullName, phone);

            Customer updatedCustomer = customerService.getCustomerById(customer.getCustomerId());
            SessionUtil.setLoggedInCustomer(request, updatedCustomer);
            request.setAttribute("success", "Profile updated successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/pages/customer/profile.jsp")
               .forward(request, response);
    }
}
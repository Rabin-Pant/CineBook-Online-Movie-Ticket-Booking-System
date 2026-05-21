package com.cinebook.service;

import com.cinebook.dao.BookingDAO;
import com.cinebook.dao.CustomerDAO;
import com.cinebook.model.Booking;
import com.cinebook.model.Customer;
import com.cinebook.utils.PasswordUtil;

import java.util.List;

public class CustomerService {
    
    private CustomerDAO customerDAO;
    private BookingDAO bookingDAO;
    
    public CustomerService() {
        this.customerDAO = new CustomerDAO();
        this.bookingDAO = new BookingDAO();
    }
    
    // ========== AUTHENTICATION ==========
    
    /**
     * Register a new customer
     */
    public boolean registerCustomer(String fullName, String email, String password, String phone) {
        // Validation
        if (fullName == null || fullName.trim().isEmpty()) return false;
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) return false;
        if (password == null || password.length() < 6) return false;
        if (phone == null || phone.trim().isEmpty()) return false;
        
        // Check if email already exists
        if (customerDAO.isEmailExists(email)) {
            return false;
        }
        
        // Create new customer
        Customer customer = new Customer();
        customer.setFullName(fullName.trim());
        customer.setEmail(email.trim().toLowerCase());
        customer.setPhone(phone.trim());
        
        return customerDAO.registerCustomer(customer, password);
    }
    
    /**
     * Login customer
     */
    public Customer loginCustomer(String email, String password) {
        if (email == null || password == null) return null;
        
        boolean isValid = customerDAO.validateCustomer(email.trim().toLowerCase(), password);
        if (isValid) {
            return customerDAO.findCustomerByEmail(email.trim().toLowerCase());
        }
        return null;
    }
    
    // ========== PROFILE MANAGEMENT ==========
    
    /**
     * Get customer by email
     */
    public Customer getCustomerByEmail(String email) {
        if (email == null) return null;
        return customerDAO.findCustomerByEmail(email.trim().toLowerCase());
    }
    
    /**
     * Get customer by ID
     */
    public Customer getCustomerById(int customerId) {
        if (customerId <= 0) return null;
        return customerDAO.getCustomerById(customerId);
    }
    
    /**
     * Update customer profile
     */
    public boolean updateCustomerProfile(String email, String fullName, String phone) {
        if (email == null || fullName == null || phone == null) return false;
        
        Customer customer = new Customer();
        customer.setEmail(email.trim().toLowerCase());
        customer.setFullName(fullName.trim());
        customer.setPhone(phone.trim());
        
        return customerDAO.updateCustomerProfile(customer);
    }
    
    /**
     * Change customer password
     */
    public boolean changePassword(String email, String oldPassword, String newPassword) {
        if (email == null || oldPassword == null || newPassword == null) return false;
        if (newPassword.length() < 6) return false;
        
        // Verify old password
        boolean isValid = customerDAO.validateCustomer(email, oldPassword);
        if (!isValid) return false;
        
        // Update to new password
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        return customerDAO.updateCustomerPassword(email, hashedPassword);
    }
    
    // ========== BOOKING HISTORY ==========
    
    /**
     * Get all bookings for a customer
     */
    public List<Booking> getCustomerBookings(int customerId) {
        if (customerId <= 0) return null;
        return bookingDAO.getBookingsByCustomer(customerId);
    }
    
    /**
     * Get recent bookings for a customer
     */
    public List<Booking> getRecentCustomerBookings(int customerId, int limit) {
        if (customerId <= 0) return null;
        List<Booking> allBookings = bookingDAO.getBookingsByCustomer(customerId);
        if (allBookings != null && allBookings.size() > limit) {
            return allBookings.subList(0, limit);
        }
        return allBookings;
    }
    
    /**
     * Cancel a booking (customer cancels their own booking)
     */
    public boolean cancelCustomerBooking(int bookingId, int customerId) {
        if (bookingId <= 0 || customerId <= 0) return false;
        
        // First verify this booking belongs to the customer
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null || booking.getCustomerId() != customerId) {
            return false;
        }
        
        // Cancel the booking
        return bookingDAO.cancelBooking(bookingId);
    }
    
    // ========== ADMIN METHODS (for managing customers) ==========
    
    /**
     * Get all customers (admin only)
     */
    public List<Customer> getAllCustomers() {
        return customerDAO.getAllCustomers();
    }
    
    /**
     * Get recent customers (admin only)
     */
    public List<Customer> getRecentCustomers(int limit) {
        return customerDAO.getRecentCustomers(limit);
    }
    
    /**
     * Delete customer (admin only)
     */
    public boolean deleteCustomer(int customerId) {
        if (customerId <= 0) return false;
        return customerDAO.deleteCustomer(customerId);
    }
    
    /**
     * Get total number of customers (admin only)
     */
    public int getTotalCustomerCount() {
        return customerDAO.getTotalCustomerCount();
    }
    
    /**
     * Check if email exists
     */
    public boolean isEmailExists(String email) {
        return customerDAO.isEmailExists(email);
    }
    
    // ========== VALIDATION HELPERS ==========
    
    /**
     * Validate email format
     */
    public boolean isValidEmail(String email) {
        if (email == null) return false;
        return email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
    
    /**
     * Validate phone number (basic validation)
     */
    public boolean isValidPhone(String phone) {
        if (phone == null) return false;
        return phone.matches("^[0-9]{10}$");
    }
    
    /**
     * Validate password strength
     */
    public boolean isValidPassword(String password) {
        if (password == null) return false;
        return password.length() >= 6;
    }
    
    public boolean updateProfilePicture(int customerId, String picturePath) {
        return customerDAO.updateProfilePicture(customerId, picturePath);
    }
    
    public boolean updateProfile(int customerId, String fullName, String phone) {
        return customerDAO.updateProfile(customerId, fullName, phone);
    }
    public boolean emailExists(String email) {
        return customerDAO.emailExists(email);
    }
}
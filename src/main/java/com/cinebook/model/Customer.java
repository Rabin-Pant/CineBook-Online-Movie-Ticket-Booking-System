package com.cinebook.model;

import java.sql.Timestamp;

public class Customer {
    
    private int customerId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private Timestamp createdAt;
    private boolean active;
    
    // Default constructor
    public Customer() {}
    
    // Parameterized constructor
    public Customer(int customerId, String fullName, String email, 
                    String password, String phone) {
        this.customerId = customerId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
    }
    
    // Getters and Setters
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
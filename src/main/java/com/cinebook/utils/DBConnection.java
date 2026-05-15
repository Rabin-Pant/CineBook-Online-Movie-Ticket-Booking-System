package com.cinebook.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    
    private static final String URL = "jdbc:mysql://localhost:3306/cinebook";
    private static final String USER = "root";
    private static final String PASSWORD = "";  // your XAMPP MySQL password
    
    public static Connection getConnection() throws SQLException {
        System.out.println("=== DB CONNECTION ===");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL Driver loaded");
            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connection successful!");
            return con;
        } catch (ClassNotFoundException e) {
            System.out.println("Driver NOT found: " + e.getMessage());
            throw new SQLException("MySQL Driver not found!", e);
        }
    }
}
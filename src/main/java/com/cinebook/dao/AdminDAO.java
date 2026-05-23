package com.cinebook.dao;

import com.cinebook.model.Admin;
import com.cinebook.utils.DBConnection;
import com.cinebook.utils.PasswordUtil;

import java.sql.*;

public class AdminDAO {
    
	public Admin findAdminByEmail(String email) {
	    String sql = "SELECT * FROM admins WHERE LOWER(email) = ? AND is_active = TRUE";
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setString(1, email.trim().toLowerCase()); // ← add this
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return extractAdmin(rs);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}

	public boolean validateAdmin(String email, String plainPassword) {
	    System.out.println("=== ADMIN LOGIN DEBUG ===");
	    System.out.println("Email: " + email);
	    System.out.println("Password entered: " + plainPassword);
	    
	    String sql = "SELECT password FROM admins WHERE email = ? AND is_active = TRUE";
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setString(1, email);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            String hashedPassword = rs.getString("password");
	            System.out.println("Stored hash: " + hashedPassword);
	            
	            boolean matches = PasswordUtil.checkPassword(plainPassword, hashedPassword);
	            System.out.println("Password matches: " + matches);
	            
	            return matches;
	        } else {
	            System.out.println("Admin NOT found with email: " + email);
	        }
	    } catch (SQLException e) {
	        System.out.println("SQL Error: " + e.getMessage());
	        e.printStackTrace();
	    }
	    return false;
	}
    
    public boolean updateLastLogin(int adminId, String ipAddress) {
        String sql = "UPDATE admins SET last_login_ip = ?, last_login_at = NOW() WHERE admin_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ipAddress);
            ps.setInt(2, adminId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean hasPermission(int adminId, String permission) {
        String sql = "SELECT permissions FROM admins WHERE admin_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String permissions = rs.getString("permissions");
                return permissions != null && permissions.contains(permission);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Admin extractAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setFullName(rs.getString("full_name"));
        admin.setEmail(rs.getString("email"));
        admin.setPassword(rs.getString("password"));
        admin.setPhone(rs.getString("phone"));
        admin.setRole(rs.getString("role"));
        admin.setPermissions(rs.getString("permissions"));
        admin.setLastLoginIp(rs.getString("last_login_ip"));
        admin.setLastLoginAt(rs.getTimestamp("last_login_at"));
        admin.setActive(rs.getBoolean("is_active"));
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        return admin;
    }
}
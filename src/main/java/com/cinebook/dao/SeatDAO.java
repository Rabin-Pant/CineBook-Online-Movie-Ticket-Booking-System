package com.cinebook.dao;

import com.cinebook.model.Seat;
import com.cinebook.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SeatDAO {
    
    public List<Seat> getSeatsByShowtime(int showtimeId) {
        List<Seat> seats = new ArrayList<>();
        String sql = "SELECT * FROM seats WHERE showtime_id = ? ORDER BY seat_number";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Seat seat = new Seat();
                seat.setSeatId(rs.getInt("seat_id"));
                seat.setShowtimeId(rs.getInt("showtime_id"));
                seat.setSeatNumber(rs.getString("seat_number"));
                seat.setBooked(rs.getBoolean("is_booked"));
                seats.add(seat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return seats;
    }
    
    public boolean bookSeats(int showtimeId, List<Integer> seatIds) {
        String sql = "UPDATE seats SET is_booked = TRUE WHERE seat_id = ? AND showtime_id = ? AND is_booked = FALSE";
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            ps = con.prepareStatement(sql);
            
            for (int seatId : seatIds) {
                ps.setInt(1, seatId);
                ps.setInt(2, showtimeId);
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            con.commit();
            
            for (int result : results) {
                if (result == 0) return false; // one seat already booked
            }
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
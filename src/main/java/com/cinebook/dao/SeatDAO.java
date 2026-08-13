package com.cinebook.dao;

import com.cinebook.model.Seat;
import com.cinebook.utils.DBConnection;

import java.sql.*;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class SeatDAO {

    private static final int HOLD_TTL_MINUTES = 5;

    public List<Seat> getSeatsByShowtime(int showtimeId) {
        return getSeatsByShowtime(showtimeId, 0);
    }

    // viewerCustomerId lets us mark seats held by *other* customers as "processing"
    public List<Seat> getSeatsByShowtime(int showtimeId, int viewerCustomerId) {
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

                int heldBy = rs.getInt("held_by_customer_id");
                Timestamp heldAt = rs.getTimestamp("held_at");
                boolean holdActive = !rs.wasNull() && heldAt != null &&
                        heldAt.toInstant().isAfter(Instant.now().minus(HOLD_TTL_MINUTES, ChronoUnit.MINUTES));
                seat.setProcessing(holdActive && heldBy != viewerCustomerId);

                seats.add(seat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return seats;
    }

    // Atomically claims a temporary hold on every seat, or none at all.
    // Succeeds if each seat is unbooked and either unheld, expired, or already held by this same customer.
    public boolean holdSeats(int showtimeId, List<Integer> seatIds, int customerId) {
        String sql = "UPDATE seats SET held_by_customer_id = ?, held_at = NOW() " +
                     "WHERE seat_id = ? AND showtime_id = ? AND is_booked = FALSE " +
                     "AND (held_by_customer_id IS NULL OR held_by_customer_id = ? " +
                     "     OR held_at < (NOW() - INTERVAL " + HOLD_TTL_MINUTES + " MINUTE))";
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                for (int seatId : seatIds) {
                    ps.setInt(1, customerId);
                    ps.setInt(2, seatId);
                    ps.setInt(3, showtimeId);
                    ps.setInt(4, customerId);
                    ps.addBatch();
                }

                int[] results = ps.executeBatch();
                for (int result : results) {
                    if (result == 0) {
                        con.rollback();
                        return false;
                    }
                }
                con.commit();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    // Releases every hold this customer has on this showtime, regardless of which seats.
    // Used when the customer lands back on seat-selection, since that unambiguously means
    // they're choosing fresh rather than mid-payment.
    public void releaseHold(int showtimeId, int customerId) {
        String sql = "UPDATE seats SET held_by_customer_id = NULL, held_at = NULL " +
                     "WHERE showtime_id = ? AND held_by_customer_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            ps.setInt(2, customerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Releases holds this customer no longer needs (payment failed/cancelled).
    public void releaseHold(int showtimeId, List<Integer> seatIds, int customerId) {
        String sql = "UPDATE seats SET held_by_customer_id = NULL, held_at = NULL " +
                     "WHERE seat_id = ? AND showtime_id = ? AND held_by_customer_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int seatId : seatIds) {
                ps.setInt(1, seatId);
                ps.setInt(2, showtimeId);
                ps.setInt(3, customerId);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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
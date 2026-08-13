package com.cinebook.dao;

import com.cinebook.model.Booking;
import com.cinebook.utils.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class BookingDAO {

    // ========== CREATE ==========

    public int createBooking(int customerId, int showtimeId,
                             BigDecimal totalAmount, List<Integer> seatIds) {
        String bookingSql     = "INSERT INTO bookings (customer_id, showtime_id, total_amount, booking_status) VALUES (?, ?, ?, 'confirmed')";
        String bookingSeatSql = "INSERT INTO booking_seats (booking_id, seat_id) VALUES (?, ?)";
        String updateSeatSql  = "UPDATE seats SET is_booked = TRUE, held_by_customer_id = NULL, held_at = NULL " +
                                "WHERE seat_id = ? AND is_booked = FALSE";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            PreparedStatement psBooking = con.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS);
            psBooking.setInt(1, customerId);
            psBooking.setInt(2, showtimeId);
            psBooking.setBigDecimal(3, totalAmount);
            psBooking.executeUpdate();

            ResultSet keys = psBooking.getGeneratedKeys();
            if (!keys.next()) throw new SQLException("No booking ID generated.");
            int bookingId = keys.getInt(1);

            PreparedStatement psSeats = con.prepareStatement(bookingSeatSql);
            for (int seatId : seatIds) {
                psSeats.setInt(1, bookingId);
                psSeats.setInt(2, seatId);
                psSeats.addBatch();
            }
            psSeats.executeBatch();

            PreparedStatement psUpdate = con.prepareStatement(updateSeatSql);
            for (int seatId : seatIds) {
                psUpdate.setInt(1, seatId);
                psUpdate.addBatch();
            }
            int[] results = psUpdate.executeBatch();
            for (int result : results) {
                if (result == 0) throw new SQLException("One or more seats already booked.");
            }

            con.commit();
            return bookingId;

        } catch (SQLException e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return -1;
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public int createBookingWithPayment(int customerId, int showtimeId,
                                        BigDecimal totalAmount, List<Integer> seatIds,
                                        String paymentMethod, String transactionId) {
        String bookingSql     = "INSERT INTO bookings (customer_id, showtime_id, total_amount, " +
                                "booking_status, payment_method, payment_status, transaction_id, payment_amount) " +
                                "VALUES (?, ?, ?, 'confirmed', ?, 'completed', ?, ?)";
        String bookingSeatSql = "INSERT INTO booking_seats (booking_id, seat_id) VALUES (?, ?)";
        String updateSeatSql  = "UPDATE seats SET is_booked = TRUE, held_by_customer_id = NULL, held_at = NULL " +
                                "WHERE seat_id = ? AND is_booked = FALSE";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            PreparedStatement psBooking = con.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS);
            psBooking.setInt(1, customerId);
            psBooking.setInt(2, showtimeId);
            psBooking.setBigDecimal(3, totalAmount);
            psBooking.setString(4, paymentMethod);
            psBooking.setString(5, transactionId);
            psBooking.setBigDecimal(6, totalAmount);
            psBooking.executeUpdate();

            ResultSet keys = psBooking.getGeneratedKeys();
            if (!keys.next()) throw new SQLException("No booking ID generated.");
            int bookingId = keys.getInt(1);

            PreparedStatement psSeats = con.prepareStatement(bookingSeatSql);
            for (int seatId : seatIds) {
                psSeats.setInt(1, bookingId);
                psSeats.setInt(2, seatId);
                psSeats.addBatch();
            }
            psSeats.executeBatch();

            PreparedStatement psUpdate = con.prepareStatement(updateSeatSql);
            for (int seatId : seatIds) {
                psUpdate.setInt(1, seatId);
                psUpdate.addBatch();
            }
            int[] results = psUpdate.executeBatch();
            for (int result : results) {
                if (result == 0) throw new SQLException("One or more seats already booked.");
            }

            con.commit();
            return bookingId;

        } catch (SQLException e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return -1;
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ========== READ ==========

    public Booking getBookingById(int bookingId) {
        String sql = "SELECT b.*, c.full_name as customer_name, " +
                     "m.title as movie_title, s.show_date, s.show_time, s.hall, " +
                     "GROUP_CONCAT(st.seat_number ORDER BY st.seat_number SEPARATOR ', ') as seat_numbers " +
                     "FROM bookings b " +
                     "JOIN customers c ON b.customer_id = c.customer_id " +
                     "JOIN showtimes s ON b.showtime_id = s.showtime_id " +
                     "JOIN movies m ON s.movie_id = m.movie_id " +
                     "LEFT JOIN booking_seats bs ON b.booking_id = bs.booking_id " +
                     "LEFT JOIN seats st ON bs.seat_id = st.seat_id " +
                     "WHERE b.booking_id = ? " +
                     "GROUP BY b.booking_id";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractFullBooking(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Booking> getBookingsByCustomer(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, " +
                     "m.title as movie_title, s.show_date, s.show_time, s.hall, " +
                     "GROUP_CONCAT(st.seat_number ORDER BY st.seat_number SEPARATOR ', ') as seat_numbers " +
                     "FROM bookings b " +
                     "JOIN customers c ON b.customer_id = c.customer_id " +
                     "JOIN showtimes s ON b.showtime_id = s.showtime_id " +
                     "JOIN movies m ON s.movie_id = m.movie_id " +
                     "LEFT JOIN booking_seats bs ON b.booking_id = bs.booking_id " +
                     "LEFT JOIN seats st ON bs.seat_id = st.seat_id " +
                     "WHERE b.customer_id = ? " +
                     "GROUP BY b.booking_id " +
                     "ORDER BY b.booked_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractFullBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getBookingsByShowtime(int showtimeId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, " +
                     "m.title as movie_title, s.show_date, s.show_time, s.hall, " +
                     "GROUP_CONCAT(st.seat_number ORDER BY st.seat_number SEPARATOR ', ') as seat_numbers " +
                     "FROM bookings b " +
                     "JOIN customers c ON b.customer_id = c.customer_id " +
                     "JOIN showtimes s ON b.showtime_id = s.showtime_id " +
                     "JOIN movies m ON s.movie_id = m.movie_id " +
                     "LEFT JOIN booking_seats bs ON b.booking_id = bs.booking_id " +
                     "LEFT JOIN seats st ON bs.seat_id = st.seat_id " +
                     "WHERE b.showtime_id = ? " +
                     "GROUP BY b.booking_id ORDER BY b.booked_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractFullBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, " +
                     "m.title as movie_title, s.show_date, s.show_time, s.hall, " +
                     "GROUP_CONCAT(st.seat_number ORDER BY st.seat_number SEPARATOR ', ') as seat_numbers " +
                     "FROM bookings b " +
                     "JOIN customers c ON b.customer_id = c.customer_id " +
                     "JOIN showtimes s ON b.showtime_id = s.showtime_id " +
                     "JOIN movies m ON s.movie_id = m.movie_id " +
                     "LEFT JOIN booking_seats bs ON b.booking_id = bs.booking_id " +
                     "LEFT JOIN seats st ON bs.seat_id = st.seat_id " +
                     "GROUP BY b.booking_id ORDER BY b.booked_at DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(extractFullBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getRecentBookings(int limit) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, " +
                     "m.title as movie_title, s.show_date, s.show_time, s.hall, " +
                     "GROUP_CONCAT(st.seat_number ORDER BY st.seat_number SEPARATOR ', ') as seat_numbers " +
                     "FROM bookings b " +
                     "JOIN customers c ON b.customer_id = c.customer_id " +
                     "JOIN showtimes s ON b.showtime_id = s.showtime_id " +
                     "JOIN movies m ON s.movie_id = m.movie_id " +
                     "LEFT JOIN booking_seats bs ON b.booking_id = bs.booking_id " +
                     "LEFT JOIN seats st ON bs.seat_id = st.seat_id " +
                     "GROUP BY b.booking_id ORDER BY b.booked_at DESC LIMIT ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractFullBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getBookingsByDateRange(Date startDate, Date endDate) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, " +
                     "m.title as movie_title, s.show_date, s.show_time, s.hall, " +
                     "GROUP_CONCAT(st.seat_number ORDER BY st.seat_number SEPARATOR ', ') as seat_numbers " +
                     "FROM bookings b " +
                     "JOIN customers c ON b.customer_id = c.customer_id " +
                     "JOIN showtimes s ON b.showtime_id = s.showtime_id " +
                     "JOIN movies m ON s.movie_id = m.movie_id " +
                     "LEFT JOIN booking_seats bs ON b.booking_id = bs.booking_id " +
                     "LEFT JOIN seats st ON bs.seat_id = st.seat_id " +
                     "WHERE DATE(b.booked_at) BETWEEN ? AND ? " +
                     "GROUP BY b.booking_id ORDER BY b.booked_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractFullBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ========== CANCEL ==========

    public boolean cancelBooking(int bookingId) {
        String getAmountSql = "SELECT total_amount FROM bookings WHERE booking_id = ?";
        String cancelSql    = "UPDATE bookings SET booking_status = 'cancelled', " +
                              "refund_amount = ?, cancellation_fee = ?, " +
                              "refund_status = 'pending', cancelled_at = NOW() " +
                              "WHERE booking_id = ? AND booking_status = 'confirmed'";
        String releaseSql   = "UPDATE seats s JOIN booking_seats bs ON s.seat_id = bs.seat_id " +
                              "SET s.is_booked = FALSE WHERE bs.booking_id = ?";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            PreparedStatement psGet = con.prepareStatement(getAmountSql);
            psGet.setInt(1, bookingId);
            ResultSet rs = psGet.executeQuery();
            if (!rs.next()) throw new SQLException("Booking not found");

            BigDecimal totalAmount     = rs.getBigDecimal("total_amount");
            BigDecimal cancellationFee = totalAmount.multiply(
                new BigDecimal("0.08")).setScale(2, RoundingMode.HALF_UP);
            BigDecimal refundAmount    = totalAmount.subtract(cancellationFee)
                .setScale(2, RoundingMode.HALF_UP);

            PreparedStatement psCancel = con.prepareStatement(cancelSql);
            psCancel.setBigDecimal(1, refundAmount);
            psCancel.setBigDecimal(2, cancellationFee);
            psCancel.setInt(3, bookingId);
            int rows = psCancel.executeUpdate();
            if (rows == 0) throw new SQLException("Already cancelled or not found.");

            PreparedStatement psRelease = con.prepareStatement(releaseSql);
            psRelease.setInt(1, bookingId);
            psRelease.executeUpdate();

            con.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ========== STATISTICS ==========

    public int getTotalBookingCount() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE booking_status = 'confirmed'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public BigDecimal getTotalActualRevenue() {

    	BigDecimal confirmedRevenue = getTotalRevenue();
        BigDecimal cancellationFees = getTotalCancellationFees();
        if (confirmedRevenue == null) confirmedRevenue = BigDecimal.ZERO;
        if (cancellationFees == null) cancellationFees = BigDecimal.ZERO;
        return confirmedRevenue.add(cancellationFees);
    }

    public BigDecimal getTotalRevenue() {
        // Only confirmed bookings
        String sql = "SELECT COALESCE(SUM(total_amount), 0) " +
                     "FROM bookings WHERE booking_status = 'confirmed'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }
    public BigDecimal getTotalCancellationFees() {
        String sql = "SELECT COALESCE(SUM(cancellation_fee), 0) FROM bookings " +
                     "WHERE booking_status = 'cancelled' AND cancellation_fee IS NOT NULL";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    public BigDecimal getRevenueByDateRange(Date startDate, Date endDate) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM bookings " +
                     "WHERE booking_status = 'confirmed' AND DATE(booked_at) BETWEEN ? AND ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    // ========== HELPERS ==========

    public boolean isSeatBooked(int showtimeId, int seatId) {
        String sql = "SELECT is_booked FROM seats WHERE seat_id = ? AND showtime_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, seatId);
            ps.setInt(2, showtimeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBoolean("is_booked");
        } catch (SQLException e) { e.printStackTrace(); }
        return true;
    }

    private Booking extractFullBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setCustomerId(rs.getInt("customer_id"));
        b.setShowtimeId(rs.getInt("showtime_id"));
        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setBookingStatus(rs.getString("booking_status"));
        b.setBookedAt(rs.getTimestamp("booked_at"));
        b.setCustomerName(rs.getString("customer_name"));
        b.setMovieTitle(rs.getString("movie_title"));
        b.setShowDate(rs.getDate("show_date"));
        b.setShowTime(rs.getTime("show_time"));
        b.setHall(rs.getString("hall"));
        b.setSeatNumbers(rs.getString("seat_numbers"));

        // Payment fields
        try { b.setPaymentMethod(rs.getString("payment_method")); } catch (SQLException e) {}
        try { b.setPaymentStatus(rs.getString("payment_status")); } catch (SQLException e) {}
        try { b.setTransactionId(rs.getString("transaction_id")); } catch (SQLException e) {}
        try { b.setPaymentAmount(rs.getBigDecimal("payment_amount")); } catch (SQLException e) {}

        // Refund fields
        try { b.setRefundAmount(rs.getBigDecimal("refund_amount")); } catch (SQLException e) {}
        try { b.setRefundStatus(rs.getString("refund_status")); } catch (SQLException e) {}
        try { b.setCancelledAt(rs.getTimestamp("cancelled_at")); } catch (SQLException e) {}
        try { b.setCancellationFee(rs.getBigDecimal("cancellation_fee")); } catch (SQLException e) {}

        return b;
    }
    
    public List<String> getLast7Days() {
        List<String> days = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(DATE_SUB(CURDATE(), " +
                     "INTERVAL seq DAY), '%b %d') as day_label " +
                     "FROM (SELECT 0 seq UNION SELECT 1 UNION SELECT 2 " +
                     "UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 " +
                     "UNION SELECT 6) days ORDER BY seq DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) days.add(rs.getString("day_label"));
        } catch (SQLException e) { e.printStackTrace(); }
        return days;
    }
    
    public List<BigDecimal> getRevenueForLast7Days() {
        List<BigDecimal> revenues = new ArrayList<>();
        String sql = "SELECT " +
                     "COALESCE(SUM(CASE WHEN DATE(booked_at) = " +
                     "DATE_SUB(CURDATE(), INTERVAL seq DAY) " +
                     "AND booking_status = 'confirmed' " +
                     "THEN total_amount ELSE 0 END), 0) as revenue " +
                     "FROM bookings, " +
                     "(SELECT 0 seq UNION SELECT 1 UNION SELECT 2 " +
                     "UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 " +
                     "UNION SELECT 6) days " +
                     "GROUP BY seq ORDER BY seq DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) revenues.add(rs.getBigDecimal("revenue"));
        } catch (SQLException e) { e.printStackTrace(); }
        return revenues;
    }
    
    public Map<String, Integer> getBookingsByStatus() {
        Map<String, Integer> statusMap = new HashMap<>();
        String sql = "SELECT booking_status, COUNT(*) as count " +
                     "FROM bookings GROUP BY booking_status";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                statusMap.put(rs.getString("booking_status"),
                             rs.getInt("count"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return statusMap;
    }
    
    public Map<String, Integer> getBookingsByMovie() {
        Map<String, Integer> movieMap = new LinkedHashMap<>();
        String sql = "SELECT m.title, COUNT(b.booking_id) as count " +
                     "FROM bookings b " +
                     "JOIN showtimes s ON b.showtime_id = s.showtime_id " +
                     "JOIN movies m ON s.movie_id = m.movie_id " +
                     "WHERE b.booking_status = 'confirmed' " +
                     "GROUP BY m.title ORDER BY count DESC LIMIT 5";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                movieMap.put(rs.getString("title"), rs.getInt("count"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return movieMap;
    }
}
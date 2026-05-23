package com.cinebook.dao;

import com.cinebook.model.Showtime;
import com.cinebook.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShowtimeDAO {

	public List<Showtime> getShowtimesByMovie(int movieId) {
	    List<Showtime> list = new ArrayList<>();
	    String sql = "SELECT s.*, m.title as movie_title FROM showtimes s " +
	                 "JOIN movies m ON s.movie_id = m.movie_id " +
	                 "WHERE s.movie_id = ? " +
	                 "AND s.show_date >= CURDATE() " +
	                 "ORDER BY s.show_date, s.show_time";
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setInt(1, movieId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) list.add(extractShowtime(rs));
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}

    public Showtime getShowtimeById(int showtimeId) {
        String sql = "SELECT s.*, m.title as movie_title FROM showtimes s " +
                     "JOIN movies m ON s.movie_id = m.movie_id " +
                     "WHERE s.showtime_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractShowtime(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addShowtime(int movieId, String showDate, String showTime,
                               String hall, int totalSeats, double price) {
        String sql = "INSERT INTO showtimes (movie_id, show_date, show_time, hall, total_seats, price) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, movieId);
            ps.setDate(2, Date.valueOf(showDate));
            ps.setTime(3, Time.valueOf(showTime + ":00"));
            ps.setString(4, hall);
            ps.setInt(5, totalSeats);
            ps.setDouble(6, price);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                // Auto-generate seats (A1-A10, B1-B10, etc.)
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    int showtimeId = keys.getInt(1);
                    generateSeats(con, showtimeId, totalSeats);
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private void generateSeats(Connection con, int showtimeId, int totalSeats) throws SQLException {
        String sql = "INSERT INTO seats (showtime_id, seat_number, is_booked) VALUES (?, ?, FALSE)";
        String[] rows = {"A", "B", "C", "D", "E", "F"};
        int seatsPerRow = 10;
        int count = 0;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            outer:
            for (String row : rows) {
                for (int i = 1; i <= seatsPerRow; i++) {
                    ps.setInt(1, showtimeId);
                    ps.setString(2, row + i);
                    ps.addBatch();
                    count++;
                    if (count >= totalSeats) break outer;
                }
            }
            ps.executeBatch();
        }
    }

    public boolean deleteShowtime(int showtimeId) {
        String sql = "DELETE FROM showtimes WHERE showtime_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getAvailableSeats(int showtimeId) {
        String sql = "SELECT COUNT(*) FROM seats WHERE showtime_id = ? AND is_booked = FALSE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Showtime extractShowtime(ResultSet rs) throws SQLException {
        Showtime st = new Showtime();
        st.setShowtimeId(rs.getInt("showtime_id"));
        st.setMovieId(rs.getInt("movie_id"));
        st.setMovieTitle(rs.getString("movie_title"));
        st.setShowDate(rs.getDate("show_date"));
        st.setShowTime(rs.getTime("show_time"));
        st.setHall(rs.getString("hall"));
        st.setTotalSeats(rs.getInt("total_seats"));
        st.setPrice(rs.getBigDecimal("price"));
        // Available seats calculated separately
        st.setAvailableSeats(getAvailableSeats(rs.getInt("showtime_id")));
        return st;
    }
}
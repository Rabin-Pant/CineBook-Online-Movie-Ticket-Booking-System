package com.cinebook.dao;

import com.cinebook.model.Movie;
import com.cinebook.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {
    
    public List<Movie> getAllMovies() {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM movies ORDER BY movie_id DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(extractMovie(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Movie> getMoviesByStatus(String status) {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM movies WHERE status = ? ORDER BY movie_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractMovie(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Movie getMovieById(int id) {
        String sql = "SELECT * FROM movies WHERE movie_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractMovie(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addMovie(Movie movie) {
        String sql = "INSERT INTO movies (title, description, genre, duration, language, rating, poster_url, status) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, movie.getTitle());
            ps.setString(2, movie.getDescription());
            ps.setString(3, movie.getGenre());
            ps.setInt(4, movie.getDuration());
            ps.setString(5, movie.getLanguage());
            ps.setDouble(6, movie.getRating());
            ps.setString(7,
            	    movie.getPosterUrl() != null
            	        ? movie.getPosterUrl()
            	        : "default-movie.jpg"
            	);
            ps.setString(8, movie.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            
        }
        return false;
    }
    
    public boolean updateMovie(Movie movie) {
        String sql = "UPDATE movies SET title=?, description=?, genre=?, duration=?, language=?, rating=?, poster_url=?, status=? WHERE movie_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, movie.getTitle());
            ps.setString(2, movie.getDescription());
            ps.setString(3, movie.getGenre());
            ps.setInt(4, movie.getDuration());
            ps.setString(5, movie.getLanguage());
            ps.setDouble(6, movie.getRating());
            ps.setString(7, movie.getPosterUrl());
            ps.setString(8, movie.getStatus());
            ps.setInt(9, movie.getMovieId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteMovie(int movieId) {
        String sql = "DELETE FROM movies WHERE movie_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private Movie extractMovie(ResultSet rs) throws SQLException {
        Movie movie = new Movie();
        movie.setMovieId(rs.getInt("movie_id"));
        movie.setTitle(rs.getString("title"));
        movie.setDescription(rs.getString("description"));
        movie.setGenre(rs.getString("genre"));
        movie.setDuration(rs.getInt("duration"));
        movie.setLanguage(rs.getString("language"));
        movie.setRating(rs.getDouble("rating"));
        movie.setPosterUrl(rs.getString("poster_url"));
        movie.setStatus(rs.getString("status"));
        movie.setCreatedAt(rs.getTimestamp("created_at"));
        return movie;
    }
    
    public List<Movie> searchMovies(String keyword) {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM movies WHERE " +
                     "title LIKE ? OR " +
                     "genre LIKE ? OR " +
                     "language LIKE ? OR " +
                     "description LIKE ? " +
                     "ORDER BY status, title";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractMovie(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
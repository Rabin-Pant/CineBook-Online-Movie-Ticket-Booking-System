package com.cinebook.service;

import com.cinebook.dao.ShowtimeDAO;
import com.cinebook.model.Showtime;

import java.util.List;

public class ShowtimeService {
    
    private ShowtimeDAO showtimeDAO;
    
    public ShowtimeService() {
        this.showtimeDAO = new ShowtimeDAO();
    }
    
    // Get showtimes for a specific movie
    public List<Showtime> getShowtimesByMovie(int movieId) {
        if (movieId <= 0) return null;
        return showtimeDAO.getShowtimesByMovie(movieId);
    }
    
    // Get showtime by ID
    public Showtime getShowtimeById(int showtimeId) {
        if (showtimeId <= 0) return null;
        return showtimeDAO.getShowtimeById(showtimeId);
    }
}
package com.cinebook.service;

import com.cinebook.model.Movie;
import com.cinebook.dao.MovieDAO;
import java.util.ArrayList;
import java.util.List;
import com.cinebook.model.Movie;

import java.util.List;

public class MovieService {
    
    private MovieDAO movieDAO;
    
    public MovieService() {
        this.movieDAO = new MovieDAO();
    }
    
    // Get all movies
    public List<Movie> getAllMovies() {
        return movieDAO.getAllMovies();
    }
    
    // Get now showing movies
    public List<Movie> getNowShowingMovies() {
        return movieDAO.getMoviesByStatus("now_showing");
    }
    
    // Get coming soon movies
    public List<Movie> getComingSoonMovies() {
        return movieDAO.getMoviesByStatus("coming_soon");
    }
    
    // Get movie by ID
    public Movie getMovieById(int movieId) {
        if (movieId <= 0) return null;
        return movieDAO.getMovieById(movieId);
    }
    
    public List<Movie> searchMovies(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return new ArrayList<>();
        return movieDAO.searchMovies(keyword.trim());
    }
    
    // Add new movie
    public boolean addMovie(String title, String description, String genre, int duration, 
                            String language, double rating, String posterUrl, String status) {
        // Validation
        if (title == null || title.trim().isEmpty()) return false;
        if (duration <= 0) return false;
        if (rating < 0 || rating > 10) return false;
        
        Movie movie = new Movie();
        movie.setTitle(title.trim());
        movie.setDescription(description != null ? description.trim() : "");
        movie.setGenre(genre != null ? genre.trim() : "");
        movie.setDuration(duration);
        movie.setLanguage(language != null ? language.trim() : "");
        movie.setRating(rating);
        movie.setPosterUrl(posterUrl != null ? posterUrl.trim() : "");
        movie.setStatus(status != null ? status : "now_showing");
        
        return movieDAO.addMovie(movie);
    }
    
    // Update existing movie
    public boolean updateMovie(int movieId, String title, String description, String genre, 
                               int duration, String language, double rating, String posterUrl, String status) {
        if (movieId <= 0) return false;
        
        Movie movie = new Movie();
        movie.setMovieId(movieId);
        movie.setTitle(title.trim());
        movie.setDescription(description != null ? description.trim() : "");
        movie.setGenre(genre != null ? genre.trim() : "");
        movie.setDuration(duration);
        movie.setLanguage(language != null ? language.trim() : "");
        movie.setRating(rating);
        movie.setPosterUrl(posterUrl != null ? posterUrl.trim() : "");
        movie.setStatus(status != null ? status : "now_showing");
        
        return movieDAO.updateMovie(movie);
    }
    
    // Delete movie
    public boolean deleteMovie(int movieId) {
        if (movieId <= 0) return false;
        return movieDAO.deleteMovie(movieId);
    }
}
package com.cinebook.model;

import java.sql.Timestamp;

public class Movie {
    
    private int movieId;
    private String title;
    private String description;
    private String genre;
    private int duration;        // in minutes
    private String language;
    private double rating;
    private String posterUrl;
    private String status;       // 'now_showing' or 'coming_soon'
    private Timestamp createdAt;
    
    // Default constructor
    public Movie() {}
    
    // Parameterized constructor
    public Movie(int movieId, String title, String description, String genre, 
                 int duration, String language, double rating, String posterUrl, 
                 String status, Timestamp createdAt) {
        this.movieId = movieId;
        this.title = title;
        this.description = description;
        this.genre = genre;
        this.duration = duration;
        this.language = language;
        this.rating = rating;
        this.posterUrl = posterUrl;
        this.status = status;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getMovieId() {
        return movieId;
    }
    
    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getGenre() {
        return genre;
    }
    
    public void setGenre(String genre) {
        this.genre = genre;
    }
    
    public int getDuration() {
        return duration;
    }
    
    public void setDuration(int duration) {
        this.duration = duration;
    }
    
    public String getLanguage() {
        return language;
    }
    
    public void setLanguage(String language) {
        this.language = language;
    }
    
    public double getRating() {
        return rating;
    }
    
    public void setRating(double rating) {
        this.rating = rating;
    }
    
    public String getPosterUrl() {
        return posterUrl;
    }
    
    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
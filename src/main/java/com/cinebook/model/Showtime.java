package com.cinebook.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;

public class Showtime {

    private int showtimeId;
    private int movieId;
    private String movieTitle;
    private Date showDate;
    private Time showTime;
    private String hall;
    private int totalSeats;
    private int availableSeats; // ✅ Added
    private BigDecimal price;

    public Showtime() {}

    // Getters and Setters
    public int getShowtimeId()  { return showtimeId; }
    public void setShowtimeId(int showtimeId) { this.showtimeId = showtimeId; }

    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }

    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }

    public Date getShowDate() { return showDate; }
    public void setShowDate(Date showDate) { this.showDate = showDate; }

    public Time getShowTime() { return showTime; }
    public void setShowTime(Time showTime) { this.showTime = showTime; }

    public String getHall() { return hall; }
    public void setHall(String hall) { this.hall = hall; }

    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }

    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
}
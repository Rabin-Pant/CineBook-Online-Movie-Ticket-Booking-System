package com.cinebook.model;

public class Seat {
    
    private int seatId;
    private int showtimeId;
    private String seatNumber;
    private boolean isBooked;
    
    // Default constructor
    public Seat() {}
    
    // Parameterized constructor
    public Seat(int seatId, int showtimeId, String seatNumber, boolean isBooked) {
        this.seatId = seatId;
        this.showtimeId = showtimeId;
        this.seatNumber = seatNumber;
        this.isBooked = isBooked;
    }
    
    // Getters and Setters
    public int getSeatId() {
        return seatId;
    }
    
    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }
    
    public int getShowtimeId() {
        return showtimeId;
    }
    
    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }
    
    public String getSeatNumber() {
        return seatNumber;
    }
    
    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }
    
    public boolean isBooked() {
        return isBooked;
    }
    
    public void setBooked(boolean isBooked) {
        this.isBooked = isBooked;
    }
}
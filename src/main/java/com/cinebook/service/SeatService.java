package com.cinebook.service;

import com.cinebook.dao.SeatDAO;
import com.cinebook.model.Seat;

import java.util.ArrayList;
import java.util.List;

public class SeatService {
    
    private SeatDAO seatDAO;
    
    public SeatService() {
        this.seatDAO = new SeatDAO();
    }
    
    // Get all seats for a showtime
    public List<Seat> getSeatsByShowtime(int showtimeId) {
        if (showtimeId <= 0) return new ArrayList<>();
        return seatDAO.getSeatsByShowtime(showtimeId);
    }
    
    // Get only available (not booked) seats
    public List<Seat> getAvailableSeats(int showtimeId) {
        List<Seat> allSeats = getSeatsByShowtime(showtimeId);
        List<Seat> availableSeats = new ArrayList<>();
        
        for (Seat seat : allSeats) {
            if (!seat.isBooked()) {
                availableSeats.add(seat);
            }
        }
        return availableSeats;
    }
    
    // Get only booked seats
    public List<Seat> getBookedSeats(int showtimeId) {
        List<Seat> allSeats = getSeatsByShowtime(showtimeId);
        List<Seat> bookedSeats = new ArrayList<>();
        
        for (Seat seat : allSeats) {
            if (seat.isBooked()) {
                bookedSeats.add(seat);
            }
        }
        return bookedSeats;
    }
    
    // Book multiple seats
    public boolean bookSeats(int showtimeId, List<Integer> seatIds) {
        if (showtimeId <= 0 || seatIds == null || seatIds.isEmpty()) {
            return false;
        }
        return seatDAO.bookSeats(showtimeId, seatIds);
    }
}
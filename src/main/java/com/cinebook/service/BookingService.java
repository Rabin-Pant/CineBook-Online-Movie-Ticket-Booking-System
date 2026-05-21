package com.cinebook.service;

import com.cinebook.dao.BookingDAO;
import com.cinebook.dao.SeatDAO;
import com.cinebook.dao.ShowtimeDAO;
import com.cinebook.model.Booking;
import com.cinebook.model.Seat;
import com.cinebook.model.Showtime;

import java.math.BigDecimal;
import java.util.List;

public class BookingService {
    
    private BookingDAO bookingDAO;
    private ShowtimeService showtimeService;
    private SeatService seatService;
    
    public BookingService() {
        this.bookingDAO = new BookingDAO();
        this.showtimeService = new ShowtimeService();
        this.seatService = new SeatService();
    }
    
    // Create a new booking with validation
    public int createBooking(int customerId, int showtimeId, List<Integer> seatIds) {
        // Validation
        if (customerId <= 0 || showtimeId <= 0 || seatIds == null || seatIds.isEmpty()) {
            return -1;
        }
        
        // Get showtime details to calculate total amount
        Showtime showtime = showtimeService.getShowtimeById(showtimeId);
        if (showtime == null) {
            return -1;
        }
        
        // Verify all selected seats are available
        for (int seatId : seatIds) {
            List<Seat> allSeats = seatService.getSeatsByShowtime(showtimeId);
            boolean seatFound = false;
            for (Seat seat : allSeats) {
                if (seat.getSeatId() == seatId) {
                    seatFound = true;
                    if (seat.isBooked()) {
                        return -1; // Seat already booked
                    }
                    break;
                }
            }
            if (!seatFound) {
                return -1; // Invalid seat
            }
        }
        
        // Calculate total amount
        BigDecimal totalAmount = showtime.getPrice().multiply(BigDecimal.valueOf(seatIds.size()));
        
        // Create booking
        return bookingDAO.createBooking(customerId, showtimeId, totalAmount, seatIds);
    }
    
    // Get booking by ID
    public Booking getBookingById(int bookingId) {
        if (bookingId <= 0) return null;
        return bookingDAO.getBookingById(bookingId);
    }
    
    // Get all bookings for a customer (FIXED: changed from getBookingsByUser)
    public List<Booking> getCustomerBookings(int customerId) {
        if (customerId <= 0) return null;
        return bookingDAO.getBookingsByCustomer(customerId);
    }
    
    // Get all bookings for a showtime
    public List<Booking> getShowtimeBookings(int showtimeId) {
        if (showtimeId <= 0) return null;
        return bookingDAO.getBookingsByShowtime(showtimeId);
    }
    
    // Get all bookings (admin only)
    public List<Booking> getAllBookings() {
        return bookingDAO.getAllBookings();
    }
    
    // Get recent bookings (admin dashboard)
    public List<Booking> getRecentBookings(int limit) {
        if (limit <= 0) limit = 10;
        return bookingDAO.getRecentBookings(limit);
    }
    
    // Get bookings by date range (admin reports)
    public List<Booking> getBookingsByDateRange(java.sql.Date startDate, java.sql.Date endDate) {
        if (startDate == null || endDate == null) return null;
        return bookingDAO.getBookingsByDateRange(startDate, endDate);
    }
    
    // Cancel a booking
    public boolean cancelBooking(int bookingId) {
        if (bookingId <= 0) return false;
        return bookingDAO.cancelBooking(bookingId);
    }
    
    // Get total revenue (admin)
    public BigDecimal getTotalRevenue() {
        return bookingDAO.getTotalRevenue();
    }
    
    // Get total booking count (admin)
    public int getTotalBookingCount() {
        return bookingDAO.getTotalBookingCount();
    }
    
    // Check if seat is booked
    public boolean isSeatBooked(int showtimeId, int seatId) {
        if (showtimeId <= 0 || seatId <= 0) return true;
        return bookingDAO.isSeatBooked(showtimeId, seatId);
    }
}
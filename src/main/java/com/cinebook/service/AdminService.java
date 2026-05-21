package com.cinebook.service;

import com.cinebook.dao.*;
import com.cinebook.model.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.util.*;

public class AdminService {

    private MovieDAO movieDAO;
    private ShowtimeDAO showtimeDAO;
    private SeatDAO seatDAO;
    private BookingDAO bookingDAO;
    private CustomerDAO customerDAO;
    private AdminDAO adminDAO;

    public AdminService() {
        this.movieDAO    = new MovieDAO();
        this.showtimeDAO = new ShowtimeDAO();
        this.seatDAO     = new SeatDAO();
        this.bookingDAO  = new BookingDAO();
        this.customerDAO = new CustomerDAO();
        this.adminDAO    = new AdminDAO();
    }

    // ========== ADMIN AUTHENTICATION ==========

    public Admin loginAdmin(String email, String password, String ipAddress) {
        if (email == null || password == null) return null;
        boolean isValid = adminDAO.validateAdmin(email.trim().toLowerCase(), password);
        if (isValid) {
            Admin admin = adminDAO.findAdminByEmail(email.trim().toLowerCase());
            if (admin != null && admin.isActive()) {
                adminDAO.updateLastLogin(admin.getAdminId(), ipAddress);
                return admin;
            }
        }
        return null;
    }

    // ========== MOVIE MANAGEMENT ==========

    public List<Movie> getAllMovies() {
        return movieDAO.getAllMovies();
    }

    public Movie getMovieById(int movieId) {
        if (movieId <= 0) return null;
        return movieDAO.getMovieById(movieId);
    }

    public boolean addMovie(Movie movie) {
        if (movie == null) return false;
        if (movie.getTitle() == null || movie.getTitle().trim().isEmpty()) return false;
        if (movie.getDuration() <= 0) return false;
        return movieDAO.addMovie(movie);
    }

    public boolean updateMovie(Movie movie) {
        if (movie == null) return false;
        if (movie.getMovieId() <= 0) return false;
        return movieDAO.updateMovie(movie);
    }

    public boolean deleteMovie(int movieId) {
        if (movieId <= 0) return false;
        return movieDAO.deleteMovie(movieId);
    }

    // ========== SHOWTIME MANAGEMENT ==========

    public List<Showtime> getAllShowtimes() {
        List<Showtime> allShowtimes = new ArrayList<>();
        List<Movie> movies = movieDAO.getAllMovies();
        for (Movie movie : movies) {
            List<Showtime> showtimes = showtimeDAO.getShowtimesByMovie(movie.getMovieId());
            allShowtimes.addAll(showtimes);
        }
        return allShowtimes;
    }

    public List<Showtime> getShowtimesByMovie(int movieId) {
        return showtimeDAO.getShowtimesByMovie(movieId);
    }

    public Showtime getShowtimeById(int showtimeId) {
        return showtimeDAO.getShowtimeById(showtimeId);
    }

    public boolean addShowtime(int movieId, String showDate, String showTime,
                               String hall, int totalSeats, double price) {
        return showtimeDAO.addShowtime(movieId, showDate, showTime, hall, totalSeats, price);
    }

    public boolean deleteShowtime(int showtimeId) {
        if (showtimeId <= 0) return false;
        return showtimeDAO.deleteShowtime(showtimeId);
    }

    // ========== SEAT MANAGEMENT ==========

    public List<Seat> getSeatsByShowtime(int showtimeId) {
        return seatDAO.getSeatsByShowtime(showtimeId);
    }

    // ========== BOOKING MANAGEMENT ==========

    public List<Booking> getAllBookings() {
        return bookingDAO.getAllBookings();
    }

    public List<Booking> getBookingsByCustomer(int customerId) {
        return bookingDAO.getBookingsByCustomer(customerId);
    }

    public List<Booking> getBookingsByDateRange(Date startDate, Date endDate) {
        return bookingDAO.getBookingsByDateRange(startDate, endDate);
    }

    public boolean cancelBooking(int bookingId) {
        if (bookingId <= 0) return false;
        return bookingDAO.cancelBooking(bookingId);
    }

    // ========== USER MANAGEMENT ==========

    public List<Customer> getAllCustomers() {
        return customerDAO.getAllCustomers();
    }

    public Customer getCustomerById(int customerId) {
        return customerDAO.getCustomerById(customerId);
    }

    public boolean deleteCustomer(int customerId) {
        return customerDAO.deleteCustomer(customerId);
    }

    public int getTotalCustomerCount() {
        return customerDAO.getTotalCustomerCount();
    }

    // ========== DASHBOARD STATISTICS ==========

    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        List<Movie> movies = getAllMovies();
        stats.put("totalMovies",            movies != null ? movies.size() : 0);
        stats.put("totalBookings",          bookingDAO.getTotalBookingCount());
        stats.put("totalRevenue",           bookingDAO.getTotalActualRevenue());
        stats.put("cancellationFeeRevenue", bookingDAO.getTotalCancellationFees());
        stats.put("totalCustomers",         getTotalCustomerCount());
        stats.put("recentBookings",         bookingDAO.getRecentBookings(5));

        int nowShowingCount = 0;
        int comingSoonCount = 0;
        if (movies != null) {
            for (Movie movie : movies) {
                if ("now_showing".equals(movie.getStatus()))  nowShowingCount++;
                else if ("coming_soon".equals(movie.getStatus())) comingSoonCount++;
            }
        }
        stats.put("nowShowingCount", nowShowingCount);
        stats.put("comingSoonCount", comingSoonCount);

        // ✅ Chart data
        stats.put("chartDays",           bookingDAO.getLast7Days());
        stats.put("chartRevenues",       bookingDAO.getRevenueForLast7Days());
        stats.put("bookingsByStatus",    bookingDAO.getBookingsByStatus());
        stats.put("bookingsByMovie",     bookingDAO.getBookingsByMovie());

        return stats;
    }

    // ========== REPORTS ==========

    public Map<String, BigDecimal> getRevenueReport(Date startDate, Date endDate) {
        Map<String, BigDecimal> report = new HashMap<>();
        BigDecimal revenue = bookingDAO.getRevenueByDateRange(startDate, endDate);
        report.put("totalRevenue", revenue);
        return report;
    }
}
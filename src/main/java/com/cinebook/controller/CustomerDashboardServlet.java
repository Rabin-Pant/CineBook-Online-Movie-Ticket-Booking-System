package com.cinebook.controller;

import com.cinebook.model.Booking;
import com.cinebook.model.Customer;
import com.cinebook.model.Movie;
import com.cinebook.service.CustomerService;
import com.cinebook.service.MovieService;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/dashboard")
public class CustomerDashboardServlet extends HttpServlet {

    private MovieService movieService;
    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        movieService    = new MovieService();
        customerService = new CustomerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Customer customer = SessionUtil.getLoggedInCustomer(request);

        // ✅ Get booking stats
        List<Booking> allBookings = customerService.getCustomerBookings(customer.getCustomerId());

        int totalBookings     = 0;
        int confirmedBookings = 0;
        int cancelledBookings = 0;

        if (allBookings != null) {
            totalBookings = allBookings.size();
            for (Booking b : allBookings) {
                if ("confirmed".equals(b.getBookingStatus()))  confirmedBookings++;
                else if ("cancelled".equals(b.getBookingStatus())) cancelledBookings++;
            }
        }

        // ✅ Get recent 5 bookings
        List<Booking> recentBookings = customerService.getRecentCustomerBookings(
                                            customer.getCustomerId(), 5);

        // ✅ Get movies
        List<Movie> nowShowingMovies = movieService.getNowShowingMovies();
        List<Movie> comingSoonMovies = movieService.getComingSoonMovies();

        // ✅ Set all attributes — names match dashboard.jsp
        request.setAttribute("totalBookings",     totalBookings);
        request.setAttribute("confirmedBookings", confirmedBookings);
        request.setAttribute("cancelledBookings", cancelledBookings);
        request.setAttribute("nowShowingCount",   nowShowingMovies != null ? nowShowingMovies.size() : 0);
        request.setAttribute("recentBookings",    recentBookings);
        request.setAttribute("nowShowingMovies",  nowShowingMovies);
        request.setAttribute("comingSoonMovies",  comingSoonMovies);

        request.getRequestDispatcher("/WEB-INF/pages/customer/dashboard.jsp")
               .forward(request, response);
    }
}
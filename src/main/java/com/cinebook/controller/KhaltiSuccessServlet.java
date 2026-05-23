package com.cinebook.controller;

import com.cinebook.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

@WebServlet("/customer/khalti-success")
public class KhaltiSuccessServlet extends HttpServlet {

    private static final String KHALTI_LOOKUP_URL = "https://dev.khalti.com/api/v2/epayment/lookup/";
    private static final String SECRET_KEY        = "live_secret_key_68791341fdd94846a146f0457ff7b455";

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pidx           = request.getParameter("pidx");
            String callbackStatus = request.getParameter("status");
            String transactionId  = request.getParameter("transaction_id");

            System.out.println("=== Khalti Success Callback ===");
            System.out.println("pidx:           " + pidx);
            System.out.println("status:         " + callbackStatus);
            System.out.println("transaction_id: " + transactionId);
            // Print ALL params so we can see exactly what Khalti sends back
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String p = paramNames.nextElement();
                System.out.println("  param: " + p + " = " + request.getParameter(p));
            }
            System.out.println("===============================");

            if (pidx == null || pidx.isEmpty()) {
                System.out.println("ERROR: pidx is null/empty");
                response.sendRedirect(request.getContextPath() + "/customer/khalti-failure");
                return;
            }

            // Call Khalti lookup API to verify
            String lookupJson = "{\"pidx\": \"" + pidx + "\"}";

            URL url = new URL(KHALTI_LOOKUP_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Key " + SECRET_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(lookupJson.getBytes("UTF-8"));
            }

            int httpStatus = conn.getResponseCode();
            InputStream is = (httpStatus == 200) ? conn.getInputStream() : conn.getErrorStream();

            StringBuilder sb = new StringBuilder();
            try (Scanner sc = new Scanner(is, "UTF-8")) {
                while (sc.hasNextLine()) sb.append(sc.nextLine());
            }
            String lookupResponse = sb.toString();

            System.out.println("Khalti Lookup HTTP Status: " + httpStatus);
            System.out.println("Khalti Lookup Response:    " + lookupResponse);

            // Check for Completed status — case insensitive to be safe
            boolean isCompleted = lookupResponse.toLowerCase().contains("\"status\":\"completed\"");

            // Fallback: if lookup fails but callback says Completed, trust the callback
            // (only use this if lookup API is unreachable)
            if (!isCompleted && httpStatus != 200) {
                System.out.println("Lookup API failed (HTTP " + httpStatus + "), falling back to callback status");
                isCompleted = "Completed".equalsIgnoreCase(callbackStatus);
            }

            System.out.println("isCompleted: " + isCompleted);

            if (!isCompleted) {
                response.sendRedirect(request.getContextPath() + "/customer/khalti-failure");
                return;
            }

            // Get session data
            Object showtimeObj = request.getSession().getAttribute("pending_showtimeId");
            Object seatIdsObj  = request.getSession().getAttribute("pending_seatIds");
            Object amountObj   = request.getSession().getAttribute("pending_totalAmount");
            Object customerObj = request.getSession().getAttribute("pending_customerId");

            System.out.println("Session - showtimeId: " + showtimeObj);
            System.out.println("Session - seatIds:    " + seatIdsObj);
            System.out.println("Session - amount:     " + amountObj);
            System.out.println("Session - customerId: " + customerObj);

            if (showtimeObj == null || seatIdsObj == null || amountObj == null || customerObj == null) {
                System.out.println("ERROR: Session data missing after Khalti callback!");
                response.sendRedirect(request.getContextPath() + "/customer/movies?error=Session expired. Payment was received but please contact support.");
                return;
            }

            int      showtimeId = (int)      showtimeObj;
            String[] seatIds    = (String[]) seatIdsObj;
            String   amountStr  = (String)   amountObj;
            int      customerId = (int)      customerObj;

            double amount = Double.parseDouble(amountStr);

            List<Integer> seatList = new ArrayList<>();
            for (String id : seatIds) {
                seatList.add(Integer.parseInt(id.trim()));
            }

            // Use pidx as transaction ID
            int bookingId = bookingDAO.createBookingWithPayment(
                customerId, showtimeId,
                new BigDecimal(String.valueOf(amount)),
                seatList, "khalti", pidx
            );

            System.out.println("Booking created with ID: " + bookingId);

            // Clear session
            request.getSession().removeAttribute("pending_showtimeId");
            request.getSession().removeAttribute("pending_seatIds");
            request.getSession().removeAttribute("pending_totalAmount");
            request.getSession().removeAttribute("pending_customerId");
            request.getSession().removeAttribute("pending_orderId");
            request.getSession().removeAttribute("pending_pidx");

            if (bookingId > 0) {
                response.sendRedirect(request.getContextPath() +
                    "/customer/booking-confirmation?bookingId=" + bookingId);
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/customer/movies?error=Payment successful but booking failed. Contact support.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/khalti-failure");
        }
    }
}
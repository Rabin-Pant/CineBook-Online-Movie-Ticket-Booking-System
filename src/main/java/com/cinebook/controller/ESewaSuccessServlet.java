package com.cinebook.controller;

import com.cinebook.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

@WebServlet("/customer/esewa-success")
public class ESewaSuccessServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String status        = null;
            String transactionId = null;

            // eSewa v2 returns base64 encoded data param
            String encodedData = request.getParameter("data");

            if (encodedData != null && !encodedData.isEmpty()) {
                // Decode base64
                String decodedJson = new String(
                    Base64.getDecoder().decode(encodedData));

                System.out.println("eSewa decoded response: " + decodedJson);

                // Extract status
                if (decodedJson.contains("\"status\":\"COMPLETE\"")) {
                    status = "COMPLETE";
                } else if (decodedJson.contains("COMPLETE")) {
                    status = "COMPLETE";
                }

                // Extract transaction_uuid
                if (decodedJson.contains("transaction_uuid")) {
                    int start = decodedJson.indexOf("\"transaction_uuid\":\"") + 20;
                    int end   = decodedJson.indexOf("\"", start);
                    if (start > 20 && end > start) {
                        transactionId = decodedJson.substring(start, end);
                    }
                }

            } else {
                // Fallback — check direct params
                status        = request.getParameter("status");
                transactionId = request.getParameter("transaction_uuid");
                System.out.println("eSewa direct params - status: " + status +
                                   " transactionId: " + transactionId);
            }

            System.out.println("Final status: " + status);

            if (!"COMPLETE".equals(status)) {
                response.sendRedirect(request.getContextPath() +
                    "/customer/esewa-failure");
                return;
            }

            // Get pending booking from session
            Object showtimeObj = request.getSession()
                                        .getAttribute("pending_showtimeId");
            Object seatIdsObj  = request.getSession()
                                        .getAttribute("pending_seatIds");
            Object amountObj   = request.getSession()
                                        .getAttribute("pending_totalAmount");
            Object customerObj = request.getSession()
                                        .getAttribute("pending_customerId");

            if (showtimeObj == null || seatIdsObj == null ||
                amountObj == null || customerObj == null) {
                System.out.println("Session data missing!");
                response.sendRedirect(request.getContextPath() +
                    "/customer/movies?error=Session expired");
                return;
            }

            int      showtimeId = (int)      showtimeObj;
            String[] seatIds    = (String[]) seatIdsObj;
            double   amount     = (double)   amountObj;
            int      customerId = (int)      customerObj;

            List<Integer> seatList = new ArrayList<>();
            for (String id : seatIds) {
                seatList.add(Integer.parseInt(id.trim()));
            }

            String finalTransactionId = transactionId != null
                ? transactionId
                : "TXN-" + System.currentTimeMillis();

            int bookingId = bookingDAO.createBookingWithPayment(
                customerId, showtimeId,
                new BigDecimal(String.valueOf(amount)),
                seatList, "esewa", finalTransactionId
            );

            // Clear session
            request.getSession().removeAttribute("pending_showtimeId");
            request.getSession().removeAttribute("pending_seatIds");
            request.getSession().removeAttribute("pending_totalAmount");
            request.getSession().removeAttribute("pending_customerId");
            request.getSession().removeAttribute("pending_transactionUUID");

            if (bookingId > 0) {
                response.sendRedirect(request.getContextPath() +
                    "/customer/booking-confirmation?bookingId=" + bookingId);
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/customer/movies?error=Payment successful but booking failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/customer/esewa-failure");
        }
    }
}
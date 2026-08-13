package com.cinebook.controller;
 
import com.cinebook.model.Customer;
import com.cinebook.service.SeatService;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

@WebServlet("/customer/khalti-payment")
public class KhaltiPaymentServlet extends HttpServlet {

    private static final String KHALTI_INITIATE_URL = "https://dev.khalti.com/api/v2/epayment/initiate/";
    private static final String SECRET_KEY          = "live_secret_key_68791341fdd94846a146f0457ff7b455"; // Replace with your sandbox key from test-admin.khalti.com

    private SeatService seatService;

    @Override
    public void init() throws ServletException {
        seatService = new SeatService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        try {
            Customer customer  = SessionUtil.getLoggedInCustomer(request);
            int showtimeId     = Integer.parseInt(request.getParameter("showtimeId"));
            String[] seatIds   = request.getParameterValues("seats");
            String totalAmtStr = request.getParameter("totalAmount");
 
            if (seatIds == null || seatIds.length == 0 || totalAmtStr == null) {
                response.sendRedirect(request.getContextPath() + "/customer/movies?error=Invalid booking selection");
                return;
            }

            List<Integer> seatIdList = new ArrayList<>();
            for (String id : seatIds) {
                seatIdList.add(Integer.parseInt(id.trim()));
            }

            // Authoritative check: claim (or refresh) a hold on every seat before leaving for the gateway.
            // Fails if any seat is already booked or actively held by someone else.
            boolean claimed = seatService.holdSeats(showtimeId, seatIdList, customer.getCustomerId());
            if (!claimed) {
                response.sendRedirect(request.getContextPath() +
                    "/customer/seats?showtimeId=" + showtimeId +
                    "&error=" + java.net.URLEncoder.encode("One or more selected seats are no longer available.", "UTF-8"));
                return;
            }

            double totalAmount  = Double.parseDouble(totalAmtStr);
            String amountStr    = String.format("%.2f", totalAmount);
 
            // Khalti requires amount in PAISA (1 NPR = 100 paisa)
            long amountInPaisa  = (long)(totalAmount * 100);
 
            // Unique order ID
            String orderId = "KTI-" + System.currentTimeMillis() + "-" + customer.getCustomerId();
 
            // Save to session — same pattern as eSewa
            request.getSession().setAttribute("pending_showtimeId",  showtimeId);
            request.getSession().setAttribute("pending_seatIds",      seatIds);
            request.getSession().setAttribute("pending_totalAmount",  amountStr);
            request.getSession().setAttribute("pending_customerId",   customer.getCustomerId());
            request.getSession().setAttribute("pending_orderId",      orderId);
 
            // Build return URL dynamically — same as eSewa's URL builder
            String scheme      = request.getScheme();
            String serverName  = request.getServerName();
            int    serverPort  = request.getServerPort();
            String contextPath = request.getContextPath();
 
            StringBuilder urlBuilder = new StringBuilder();
            urlBuilder.append(scheme).append("://").append(serverName);
            if (("http".equals(scheme) && serverPort != 80) || ("https".equals(scheme) && serverPort != 443)) {
                urlBuilder.append(":").append(serverPort);
            }
            urlBuilder.append(contextPath);
 
            String baseUrl   = urlBuilder.toString();
            String returnUrl = baseUrl + "/customer/khalti-success";
 
            // Build JSON payload for Khalti initiate API
            String jsonPayload = "{"
                + "\"return_url\": \"" + returnUrl + "\","
                + "\"website_url\": \"" + baseUrl + "\","
                + "\"amount\": " + amountInPaisa + ","
                + "\"purchase_order_id\": \"" + orderId + "\","
                + "\"purchase_order_name\": \"CineBook Movie Ticket\","
                + "\"customer_info\": {"
                +     "\"name\": \"" + customer.getFullName() + "\","
                +     "\"email\": \"" + customer.getEmail() + "\","
                +     "\"phone\": \"" + customer.getPhone() + "\""
                + "}"
                + "}";
 
            // Call Khalti API server-side
            URL apiUrl = new URL(KHALTI_INITIATE_URL);
            HttpURLConnection conn = (HttpURLConnection) apiUrl.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Key " + SECRET_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
 
            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonPayload.getBytes("UTF-8"));
            }
 
            // Read response
            StringBuilder sb = new StringBuilder();
            try (Scanner sc = new Scanner(conn.getInputStream())) {
                while (sc.hasNextLine()) sb.append(sc.nextLine());
            }
            String jsonResponse = sb.toString();
 
            System.out.println("=== Khalti Initiate Response ===");
            System.out.println(jsonResponse);
            System.out.println("================================");
 
            // Parse pidx and payment_url from response
            // Response: {"pidx":"xxx","payment_url":"https://test-pay.khalti.com/?pidx=xxx","expires_at":"...","expires_in":1800}
            String pidx       = jsonResponse.split("\"pidx\":\"")[1].split("\"")[0];
            String paymentUrl = jsonResponse.split("\"payment_url\":\"")[1].split("\"")[0];
 
            // Save pidx to session for verification on success
            request.getSession().setAttribute("pending_pidx", pidx);
 
            System.out.println("Khalti pidx: " + pidx);
            System.out.println("Khalti payment_url: " + paymentUrl);
 
            // Redirect user to Khalti payment page
            response.sendRedirect(paymentUrl);
 
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/movies?error=Khalti payment system error");
        }
    }
}
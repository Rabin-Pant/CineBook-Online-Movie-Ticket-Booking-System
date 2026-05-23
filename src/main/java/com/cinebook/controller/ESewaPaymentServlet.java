package com.cinebook.controller;

import com.cinebook.model.Customer;
import com.cinebook.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.util.Base64;

@WebServlet("/customer/esewa-payment")
public class ESewaPaymentServlet extends HttpServlet {

	private static final String ESEWA_URL = "https://rc-epay.esewa.com.np/api/epay/main/v2/form";
    private static final String MERCHANT_CODE = "EPAYTEST";
    private static final String SECRET_KEY    = "8gBm/:&EnhH.1/q"; // Official eSewa sandbox secret

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Customer customer   = SessionUtil.getLoggedInCustomer(request);
            int showtimeId      = Integer.parseInt(request.getParameter("showtimeId"));
            String[] seatIds    = request.getParameterValues("seats");
            String totalAmtStr  = request.getParameter("totalAmount");

            if (seatIds == null || seatIds.length == 0 || totalAmtStr == null) {
                response.sendRedirect(request.getContextPath() + "/customer/movies?error=Invalid booking selection");
                return;
            }

            // Clean format for decimal values (eSewa needs clean decimals or integers like "150" or "150.00")
            double totalAmount = Double.parseDouble(totalAmtStr);
            String amountStr = String.format("%.2f", totalAmount);

            // Generate a clean transaction identifier tracking time
            String secureRandomString = java.util.UUID.randomUUID().toString().replaceAll("-", "").substring(0, 12).toUpperCase();
            String transactionUUID = "CINE-" + System.currentTimeMillis() + "-" + secureRandomString;

            // Save booking configurations into current session context so success callback can pull them back safely
            request.getSession().setAttribute("pending_showtimeId",      showtimeId);
            request.getSession().setAttribute("pending_seatIds",         seatIds);
            request.getSession().setAttribute("pending_totalAmount",     amountStr);
            request.getSession().setAttribute("pending_customerId",      customer.getCustomerId());
            request.getSession().setAttribute("pending_transactionUUID", transactionUUID);

            // Create eSewa signature message template structure
            String signatureData = "total_amount=" + amountStr + ",transaction_uuid=" + transactionUUID + ",product_code=" + MERCHANT_CODE;
            String signature = generateHmacSHA256(signatureData, SECRET_KEY);

            // Build clean callback URLs to avoid syntax 400 Bad Request
            String scheme = request.getScheme();             // http or https
            String serverName = request.getServerName();     // localhost
            int serverPort = request.getServerPort();        // 8080
            String contextPath = request.getContextPath();    // /CineBook

            StringBuilder urlBuilder = new StringBuilder();
            urlBuilder.append(scheme).append("://").append(serverName);

            // Only append ports if they are non-standard ports used by IDE local environments
            if (("http".equals(scheme) && serverPort != 80) || ("https".equals(scheme) && serverPort != 443)) {
                urlBuilder.append(":").append(serverPort);
            }
            urlBuilder.append(contextPath);

            String baseUrl = urlBuilder.toString();
            String successUrl = (baseUrl + "/customer/esewa-success").trim();
            String failureUrl = (baseUrl + "/customer/esewa-failure").trim();

            // Debug prints to watch values in your IDE console panel
            System.out.println("=== eSewa Processing Request Log ===");
            System.out.println("Form Amount String: " + amountStr);
            System.out.println("Transaction UUID: " + transactionUUID);
            System.out.println("Built Success URL Reference: " + successUrl);
            System.out.println("Built Failure URL Reference: " + failureUrl);
            System.out.println("=====================================");

            // Bind values across to the frontend dispatcher rendering card
            request.setAttribute("esewaUrl",       ESEWA_URL);
            request.setAttribute("amount",         amountStr);
            request.setAttribute("totalAmount",    amountStr);
            request.setAttribute("transactionUUID",transactionUUID);
            request.setAttribute("merchantCode",   MERCHANT_CODE);
            request.setAttribute("signature",      signature);
            request.setAttribute("successUrl",     successUrl);
            request.setAttribute("failureUrl",     failureUrl);

            request.getRequestDispatcher("/WEB-INF/pages/customer/esewa-payment.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/movies?error=Payment system error");
        }
    }

    private String generateHmacSHA256(String data, String secret) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKeySpec = new SecretKeySpec(secret.getBytes("UTF-8"), "HmacSHA256");
        mac.init(secretKeySpec);
        byte[] hash = mac.doFinal(data.getBytes("UTF-8"));
        return Base64.getEncoder().encodeToString(hash);
    }
}
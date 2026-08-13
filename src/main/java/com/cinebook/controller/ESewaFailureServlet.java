package com.cinebook.controller;

import com.cinebook.service.SeatService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

@WebServlet("/customer/esewa-failure")
public class ESewaFailureServlet extends HttpServlet {

    private SeatService seatService;

    @Override
    public void init() throws ServletException {
        seatService = new SeatService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Log all params eSewa sends back
        System.out.println("=== eSewa Failure Params ===");
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String param = params.nextElement();
            System.out.println(param + " = " + request.getParameter(param));
        }
        System.out.println("============================");

        releasePendingHold(request);

        request.getRequestDispatcher("/WEB-INF/pages/customer/esewa-failure.jsp")
               .forward(request, response);
    }

    private void releasePendingHold(HttpServletRequest request) {
        Object showtimeObj = request.getSession().getAttribute("pending_showtimeId");
        Object seatIdsObj  = request.getSession().getAttribute("pending_seatIds");
        Object customerObj = request.getSession().getAttribute("pending_customerId");

        if (showtimeObj != null && seatIdsObj != null && customerObj != null) {
            int showtimeId = (int) showtimeObj;
            String[] seatIds = (String[]) seatIdsObj;
            int customerId = (int) customerObj;

            List<Integer> seatIdList = new ArrayList<>();
            for (String id : seatIds) {
                seatIdList.add(Integer.parseInt(id.trim()));
            }
            seatService.releaseHold(showtimeId, seatIdList, customerId);
        }

        request.getSession().removeAttribute("pending_showtimeId");
        request.getSession().removeAttribute("pending_seatIds");
        request.getSession().removeAttribute("pending_totalAmount");
        request.getSession().removeAttribute("pending_customerId");
        request.getSession().removeAttribute("pending_transactionUUID");
    }
}
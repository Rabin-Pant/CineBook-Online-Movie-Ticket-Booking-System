package com.cinebook.filter;

import com.cinebook.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter({"/customer-login.jsp", "/customer-register.jsp", 
            "/admin-login.jsp", "/customer/login", 
            "/customer/register", "/admin/login"})
public class GuestFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri    = req.getRequestURI();
        String method = req.getMethod();

        // Only redirect GET requests
        // Allow POST requests to pass through (form submissions)
        if ("POST".equalsIgnoreCase(method)) {
            chain.doFilter(request, response);
            return;
        }

        // If customer already logged in → redirect to dashboard
        if (uri.contains("customer") && SessionUtil.isCustomerLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/customer/dashboard");
            return;
        }

        // If admin already logged in → redirect to dashboard
        if (uri.contains("admin") && SessionUtil.isAdminLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
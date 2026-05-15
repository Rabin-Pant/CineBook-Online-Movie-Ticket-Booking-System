package com.cinebook.filter;

import com.cinebook.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/customer/*")
public class CustomerAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();

        // ✅ Allow these without login
        if (uri.contains("/customer/login") ||
        	    uri.contains("/customer/register") ||
        	    uri.contains("/customer/search") ||      
        	    uri.contains("/customer/movies") ||     
        	    uri.contains("/customer/esewa-success") ||
        	    uri.contains("/customer/esewa-failure") ||
        	    uri.contains("/customer/esewa-payment")) {
        	    chain.doFilter(request, response);
        	    return;
        	}

        if (!SessionUtil.isCustomerLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/customer/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
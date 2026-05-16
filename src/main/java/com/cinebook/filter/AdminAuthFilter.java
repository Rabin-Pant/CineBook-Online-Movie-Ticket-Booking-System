package com.cinebook.filter;

import com.cinebook.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        String uri = req.getRequestURI();
        
        // Public page — allow without login
        if (uri.contains("/admin/login")) {
            chain.doFilter(request, response);
            return;
        }
        
        // All other /admin/* pages require admin login
        if (!SessionUtil.isAdminLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }
        
        // Admin is logged in, proceed
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}
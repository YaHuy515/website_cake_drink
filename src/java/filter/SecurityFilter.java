package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
public class SecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();
        
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        
        // Normalize URI relative to context path
        String relativeUri = uri;
        if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
            relativeUri = uri.substring(contextPath.length());
        }
        
        Account admin = (Account) session.getAttribute("admin");
        Account customer = (Account) session.getAttribute("account");
        if (customer == null) {
            customer = (Account) session.getAttribute("customer");
        }
        
        // Fallback sync
        if (admin == null && customer != null && "admin".equals(customer.getRole())) {
            admin = customer;
            session.setAttribute("admin", admin);
        }
        if (customer == null && admin != null) {
            customer = admin;
        }
        
        // 1. Admin URL protection: check admin session
        if (relativeUri.startsWith("/admin")) {
            if (admin == null || !"admin".equals(admin.getRole())) {
                session.setAttribute("error", "Quyền truy cập bị từ chối! Vui lòng đăng nhập với tài khoản quản lý.");
                res.sendRedirect(contextPath + "/login");
                return;
            }
        }
        
        // 2. Customer checkout / order-history protection: check customer session
        if (relativeUri.startsWith("/checkout") || relativeUri.startsWith("/order-history")) {
            if (customer == null) {
                session.setAttribute("error", "Vui lòng đăng nhập để thực hiện chức năng này!");
                res.sendRedirect(contextPath + "/login");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}

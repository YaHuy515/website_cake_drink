package controller;

import dal.AccountDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account admin = (Account) session.getAttribute("admin");
        Account customer = (Account) session.getAttribute("account");
        if (customer == null) {
            customer = (Account) session.getAttribute("customer");
        }
        
        // If both are already logged in (different accounts), redirect
        if (admin != null && customer != null && !admin.getUsername().equalsIgnoreCase(customer.getUsername())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        
        if (user == null || user.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            request.setAttribute("error", "Tên đăng nhập và mật khẩu không được để trống!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        AccountDAO dao = new AccountDAO();
        Account acc = dao.login(user.trim(), pass);
        
        if (acc != null) {
            HttpSession session = request.getSession();
            
            if ("admin".equals(acc.getRole())) {
                // Store in admin session variable
                session.setAttribute("admin", acc);
                // If no customer account in session yet, optionally assign for store browsing
                if (session.getAttribute("account") == null) {
                    session.setAttribute("account", acc);
                }
                session.setAttribute("message", "Đăng nhập tài khoản Quản trị (" + acc.getFullname() + ") thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // Store in customer session variables (account & customer)
                session.setAttribute("account", acc);
                session.setAttribute("customer", acc);
                // Keep session.getAttribute("admin") intact so both run concurrently!
                session.setAttribute("message", "Đăng nhập tài khoản Khách hàng (" + acc.getFullname() + ") thành công!");
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu, hoặc tài khoản đã bị khóa!");
            request.setAttribute("username", user);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}

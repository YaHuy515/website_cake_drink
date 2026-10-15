package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.http.HttpSession;
import model.Account;

@WebServlet(name = "LogoutController", urlPatterns = {"/logout"})
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String role = request.getParameter("role");
            
            if ("admin".equalsIgnoreCase(role)) {
                session.removeAttribute("admin");
                Account currentAcc = (Account) session.getAttribute("account");
                if (currentAcc != null && "admin".equals(currentAcc.getRole())) {
                    session.removeAttribute("account");
                }
                session.setAttribute("message", "Đã đăng xuất tài khoản Quản trị!");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            } else if ("customer".equalsIgnoreCase(role)) {
                session.removeAttribute("account");
                session.removeAttribute("customer");
                session.setAttribute("message", "Đã đăng xuất tài khoản Khách hàng!");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            } else {
                session.invalidate();
            }
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }
}

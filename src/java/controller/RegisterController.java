package controller;

import dal.AccountDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Account;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        
        // Basic validations
        if (user == null || user.trim().isEmpty() || pass == null || pass.trim().isEmpty() || fullname == null || fullname.trim().isEmpty()) {
            request.setAttribute("error", "Các trường bắt buộc không được để trống!");
            request.setAttribute("username", user);
            request.setAttribute("fullname", fullname);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        AccountDAO dao = new AccountDAO();
        if (dao.exists(user.trim())) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            request.setAttribute("username", user);
            request.setAttribute("fullname", fullname);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        Account acc = new Account();
        acc.setUsername(user.trim());
        acc.setPassword(pass);
        acc.setFullname(fullname.trim());
        acc.setEmail(email != null ? email.trim() : "");
        acc.setRole("customer");
        
        boolean success = dao.register(acc);
        if (success) {
            request.getSession().setAttribute("message", "Đăng ký tài khoản thành công! Hãy đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}

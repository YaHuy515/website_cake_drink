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

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account admin = (Account) session.getAttribute("admin");
        Account customer = (Account) session.getAttribute("account");
        
        // If both logged in, redirect away
        if (admin != null && customer != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // 1. Validation for empty fields
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            request.setAttribute("error", "Vui lòng nhập đầy đủ tất cả các trường!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        username = username.trim();
        email = email.trim();
        
        // 2. Validate password match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không trùng khớp!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        AccountDAO dao = new AccountDAO();
        Account acc = dao.getByUsername(username);
        
        // 4. Validate account existence
        if (acc == null) {
            request.setAttribute("error", "Tên đăng nhập không tồn tại trong hệ thống!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // 5. Validate account status
        if (!acc.isStatus()) {
            request.setAttribute("error", "Tài khoản này hiện đang bị khóa. Vui lòng liên hệ quản trị viên!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // 6. Validate email match
        String registeredEmail = acc.getEmail() != null ? acc.getEmail().trim() : "";
        if (!registeredEmail.equalsIgnoreCase(email)) {
            request.setAttribute("error", "Email không khớp với thông tin đã đăng ký của tài khoản này!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // 7. Update password
        boolean updated = dao.updatePassword(username, newPassword);
        if (updated) {
            request.getSession().setAttribute("message", "Đặt lại mật khẩu thành công! Hãy đăng nhập bằng mật khẩu mới.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đổi mật khẩu. Vui lòng thử lại!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}

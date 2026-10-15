package controller;

import dal.AccountDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Account;

@WebServlet(name = "AdminAccountController", urlPatterns = {"/admin/accounts"})
public class AdminAccountController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        AccountDAO accDao = new AccountDAO();

        if ("toggle".equalsIgnoreCase(action)) {
            String username = request.getParameter("username");
            jakarta.servlet.http.HttpSession session = request.getSession();
            Account currentAcc = (Account) session.getAttribute("admin");
            if (currentAcc == null) {
                currentAcc = (Account) session.getAttribute("account");
            }

            if (username != null) {
                if (currentAcc != null && currentAcc.getUsername().equalsIgnoreCase(username)) {
                    session.setAttribute("error", "Bạn không thể tự khóa tài khoản của chính mình!");
                } else {
                    boolean success = accDao.toggleStatus(username);
                    if (success) {
                        session.setAttribute("message", "Thay đổi trạng thái tài khoản thành công!");
                    } else {
                        session.setAttribute("error", "Thay đổi trạng thái tài khoản thất bại!");
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        // List action (default)
        List<Account> accounts = accDao.getAll();
        request.setAttribute("accounts", accounts);
        request.getRequestDispatcher("/admin/accounts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

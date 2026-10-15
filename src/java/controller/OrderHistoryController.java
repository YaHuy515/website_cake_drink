package controller;

import dal.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Order;
import model.OrderDetail;

@WebServlet(name = "OrderHistoryController", urlPatterns = {"/order-history"})
public class OrderHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");
        if (acc == null) {
            acc = (Account) session.getAttribute("customer");
        }
        if (acc == null) {
            acc = (Account) session.getAttribute("admin");
        }
        
        if (acc == null) {
            session.setAttribute("error", "Bạn cần đăng nhập để xem lịch sử mua hàng!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        OrderDAO orderDao = new OrderDAO();
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("id");
        
        if ("cancel".equals(action)) {
            if (orderIdStr != null && !orderIdStr.isEmpty()) {
                try {
                    int orderId = Integer.parseInt(orderIdStr);
                    Order order = orderDao.getOrderById(orderId);
                    if (order != null && order.getUsername().equals(acc.getUsername()) && "Pending".equals(order.getStatus())) {
                        boolean success = orderDao.updateStatus(orderId, "Cancelled");
                        if (success) {
                            session.setAttribute("message", "Hủy đơn hàng thành công!");
                        } else {
                            session.setAttribute("error", "Hủy đơn hàng thất bại!");
                        }
                    } else {
                        session.setAttribute("error", "Đơn hàng không thể hủy (chỉ có thể hủy đơn ở trạng thái Đang chờ)!");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "Mã đơn hàng không hợp lệ!");
                }
            }
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }
        
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDao.getOrderById(orderId);
                
                // Security check: ensure this order belongs to the logged-in customer
                if (order != null && order.getUsername().equals(acc.getUsername())) {
                    List<OrderDetail> details = orderDao.getOrderDetails(orderId);
                    request.setAttribute("selectedOrder", order);
                    request.setAttribute("orderDetails", details);
                } else {
                    request.setAttribute("error", "Đơn hàng không tồn tại hoặc bạn không có quyền xem!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Mã đơn hàng không hợp lệ!");
            }
        }
        
        List<Order> orders = orderDao.getOrdersByUsername(acc.getUsername());
        request.setAttribute("orders", orders);
        
        request.getRequestDispatcher("/order-history.jsp").forward(request, response);
    }
}

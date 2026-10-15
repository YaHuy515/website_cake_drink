package controller;

import dal.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.OrderDetail;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/orders"})
public class AdminOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO orderDao = new OrderDAO();
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Order order = orderDao.getOrderById(id);
                if (order != null) {
                    List<OrderDetail> details = orderDao.getOrderDetails(id);
                    request.setAttribute("order", order);
                    request.setAttribute("orderDetails", details);
                    request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        // List all orders (default)
        List<Order> orders = orderDao.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");
        
        if (idStr != null && status != null && !status.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                // Validate status
                if ("Pending".equals(status) || "Approved".equals(status) || "Completed".equals(status) || "Cancelled".equals(status)) {
                    OrderDAO orderDao = new OrderDAO();
                    boolean success = orderDao.updateStatus(id, status);
                    if (success) {
                        request.getSession().setAttribute("message", "Cập nhật trạng thái đơn hàng thành công!");
                    } else {
                        request.getSession().setAttribute("error", "Cập nhật trạng thái đơn hàng thất bại!");
                    }
                }
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/orders?id=" + idStr);
    }
}

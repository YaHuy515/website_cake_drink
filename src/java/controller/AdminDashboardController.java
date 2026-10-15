package controller;

import dal.OrderDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ProductDAO prodDao = new ProductDAO();
        OrderDAO orderDao = new OrderDAO();
        
        // Get statistics
        int totalProducts = prodDao.getActiveCount(); 
        int outOfStock = prodDao.getLowStockCount(); 
        int totalOrders = orderDao.getOrderCount();
        double totalRevenue = orderDao.getTotalRevenue();
        
        // Get recent orders:Lấy toàn bộ danh sách đơn hàng và lọc ra 5 đơn hàng mới nhất
        List<Order> allOrders = orderDao.getAllOrders();
        List<Order> recentOrders = allOrders.subList(0, Math.min(allOrders.size(), 5));
        
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("outOfStock", outOfStock);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}

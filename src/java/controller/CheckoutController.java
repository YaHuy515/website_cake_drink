package controller;

import dal.OrderDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import model.Order;
import model.Product;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            session.setAttribute("error", "Bạn cần đăng nhập để thanh toán!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            session.setAttribute("error", "Giỏ hàng của bạn đang trống!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String orderType = request.getParameter("orderType");
        String tableNumber = request.getParameter("tableNumber");
        String deliveryAddress = request.getParameter("deliveryAddress");
        
        String address = "";
        boolean validationError = false;
        
        if (fullname == null || fullname.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty()) {
            validationError = true;
            request.setAttribute("error", "Vui lòng nhập đầy đủ tên và số điện thoại người nhận!");
        } else {
            if ("dinein".equals(orderType)) {
                if (tableNumber == null || tableNumber.trim().isEmpty()) {
                    validationError = true;
                    request.setAttribute("error", "Vui lòng nhập số bàn khi dùng tại quán!");
                } else {
                    address = "Dùng tại quán - " + tableNumber.trim();
                }
            } else {
                if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
                    address = "Mang về (Lấy tại quầy)";
                } else {
                    address = "Mang về - Ship: " + deliveryAddress.trim();
                }
            }
        }
        
        if (validationError) {
            double total = 0;
            for (CartItem item : cart) {
                total += item.getProduct().getPrice() * item.getQuantity();
            }
            request.setAttribute("totalAmount", total);
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            return;
        }
        
        // Double check stock levels in database before saving
        ProductDAO prodDao = new ProductDAO();
        for (CartItem item : cart) {
            Product currentProd = prodDao.getById(item.getProduct().getId());
            if (currentProd == null || !currentProd.isStatus()) {
                request.setAttribute("error", "Sản phẩm " + item.getProduct().getName() + " không còn kinh doanh!");
                forwardToCart(request, response, cart);
                return;
            }
            if (currentProd.getQuantity() < item.getQuantity()) {
                request.setAttribute("error", "Sản phẩm " + item.getProduct().getName() + " chỉ còn " + currentProd.getQuantity() + " sản phẩm trong kho!");
                item.setQuantity(currentProd.getQuantity()); // Auto-update to current stock limit
                forwardToCart(request, response, cart);
                return;
            }
        }
        
        // Calculate total amount
        double totalAmount = 0;
        for (CartItem item : cart) {
            totalAmount += item.getProduct().getPrice() * item.getQuantity();
        }
        
        // Retrieve voucher information from session
        String appliedVoucherCode = (String) session.getAttribute("appliedVoucherCode");
        Double discountVal = (Double) session.getAttribute("discountAmount");
        double discountAmount = discountVal != null ? discountVal : 0;
        
        // Create Order object
        Order order = new Order();
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setUsername(acc.getUsername());
        order.setTotalAmount(totalAmount - discountAmount); // Final amount (after discount)
        order.setFullname(fullname.trim());
        order.setPhone(phone.trim());
        order.setAddress(address.trim());
        order.setVoucherCode(appliedVoucherCode);
        order.setDiscountAmount(discountAmount);
        
        if ("admin".equals(acc.getRole())) {
            order.setStatus("Approved"); // Auto-approve if order is placed by staff/admin at the counter
        } else {
            order.setStatus("Pending");
        }
        
        OrderDAO orderDao = new OrderDAO();
        boolean success = orderDao.createOrder(order, cart);
        
        if (success) {
            session.removeAttribute("cart");
            session.removeAttribute("appliedVoucherCode");
            session.removeAttribute("discountAmount");
            
            if ("admin".equals(acc.getRole())) {
                session.setAttribute("message", "Đặt đơn hàng tại quầy thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            } else {
                session.setAttribute("message", "Đặt đơn hàng thành công! Đơn hàng của bạn đang được xử lý.");
                response.sendRedirect(request.getContextPath() + "/order-history");
            }
        } else {
            request.setAttribute("error", "Đặt hàng thất bại do lỗi hệ thống (có thể mã giảm giá đã hết lượt). Vui lòng thử lại!");
            forwardToCart(request, response, cart);
        }
    }
    
    private void forwardToCart(HttpServletRequest request, HttpServletResponse response, List<CartItem> cart) 
            throws ServletException, IOException {
        double total = 0;
        for (CartItem item : cart) {
            total += item.getProduct().getPrice() * item.getQuantity();
        }
        request.setAttribute("totalAmount", total);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}

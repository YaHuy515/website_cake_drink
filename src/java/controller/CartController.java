package controller;

import dal.ProductDAO;
import dal.VoucherDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.Product;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }
        
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        
        ProductDAO prodDao = new ProductDAO();
        
        if ("add".equalsIgnoreCase(action)) {
            String pidStr = request.getParameter("pid");
            String qtyParam = request.getParameter("qty");
            int addQty = 1;
            if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                try {
                    addQty = Math.max(1, Integer.parseInt(qtyParam.trim()));
                } catch (NumberFormatException e) {
                    addQty = 1;
                }
            }
            
            boolean added = false;
            String errorMessage = "";
            
            if (pidStr != null) {
                try {
                    int pid = Integer.parseInt(pidStr);
                    Product prod = prodDao.getById(pid);
                    
                    if (prod != null && prod.isStatus() && prod.getQuantity() > 0) {
                        // Check if item already exists in cart
                        boolean found = false;
                        for (CartItem item : cart) {
                            if (item.getProduct().getId() == pid) {
                                if (item.getQuantity() < prod.getQuantity()) {
                                    int newQty = Math.min(item.getQuantity() + addQty, prod.getQuantity());
                                    if (newQty > item.getQuantity()) {
                                        item.setQuantity(newQty);
                                        added = true;
                                    } else {
                                        errorMessage = "Số lượng sản phẩm trong giỏ hàng đã đạt giới hạn tồn kho!";
                                    }
                                } else {
                                    errorMessage = "Số lượng sản phẩm trong giỏ hàng đã đạt giới hạn tồn kho!";
                                }
                                found = true;
                                break;
                            }
                        }
                        if (!found) {
                            int initialQty = Math.min(addQty, prod.getQuantity());
                            cart.add(new CartItem(prod, initialQty));
                            added = true;
                        }
                    } else {
                        errorMessage = "Sản phẩm không khả dụng hoặc đã hết hàng!";
                    }
                } catch (NumberFormatException e) {
                    errorMessage = "Mã sản phẩm không hợp lệ!";
                }
            } else {
                errorMessage = "Không tìm thấy mã sản phẩm!";
            }
            
            String isAjax = request.getParameter("ajax");
            boolean ajax = "true".equalsIgnoreCase(isAjax) || "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
            
            if (ajax) {
                response.setContentType("application/json;charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                if (added) {
                    response.getWriter().write("{\"status\":\"success\",\"cartSize\":" + cart.size() + "}");
                } else {
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"" + errorMessage + "\",\"cartSize\":" + cart.size() + "}");
                }
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
        } else if ("update".equalsIgnoreCase(action)) {
            String pidStr = request.getParameter("pid");
            String qtyStr = request.getParameter("qty");
            if (pidStr != null && qtyStr != null) {
                try {
                    int pid = Integer.parseInt(pidStr);
                    int qty = Integer.parseInt(qtyStr);
                    Product prod = prodDao.getById(pid);
                    
                    if (prod != null) {
                        for (int i = 0; i < cart.size(); i++) {
                            CartItem item = cart.get(i);
                            if (item.getProduct().getId() == pid) {
                                if (qty <= 0) {
                                    cart.remove(i);
                                } else {
                                    // Limit quantity to stock level
                                    int finalQty = Math.min(qty, prod.getQuantity());
                                    item.setQuantity(finalQty);
                                }
                                break;
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
            
        } else if ("delete".equalsIgnoreCase(action)) {
            String pidStr = request.getParameter("pid");
            if (pidStr != null) {
                try {
                    int pid = Integer.parseInt(pidStr);
                    for (int i = 0; i < cart.size(); i++) {
                        if (cart.get(i).getProduct().getId() == pid) {
                            cart.remove(i);
                            break;
                        }
                    }
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
            
        } else if ("applyVoucher".equalsIgnoreCase(action)) {
            String code = request.getParameter("voucherCode");
            if (code == null || code.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập mã giảm giá!");
            } else {
                code = code.trim().toUpperCase();
                VoucherDAO vDao = new VoucherDAO();
                model.Voucher v = vDao.getByCode(code);
                
                // Calculate current total
                double subtotal = 0;
                for (CartItem item : cart) {
                    subtotal += item.getProduct().getPrice() * item.getQuantity();
                }
                
                if (v == null || !v.isStatus()) {
                    session.setAttribute("error", "Mã giảm giá không tồn tại hoặc đã bị ngừng hoạt động!");
                } else {
                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    if (now.before(v.getStartDate())) {
                        session.setAttribute("error", "Mã giảm giá chưa đến thời gian áp dụng!");
                    } else if (now.after(v.getEndDate())) {
                        session.setAttribute("error", "Mã giảm giá đã hết hạn!");
                    } else if (v.getQuantity() <= 0) {
                        session.setAttribute("error", "Mã giảm giá đã hết lượt sử dụng!");
                    } else if (subtotal < v.getMinOrderValue()) {
                        java.text.DecimalFormat df = new java.text.DecimalFormat("#,###");
                        session.setAttribute("error", "Mã giảm giá này chỉ áp dụng cho đơn hàng từ " + df.format(v.getMinOrderValue()) + "đ trở lên!");
                    } else {
                        session.setAttribute("appliedVoucherCode", v.getCode());
                        session.setAttribute("message", "Áp dụng mã giảm giá thành công!");
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
            
        } else if ("removeVoucher".equalsIgnoreCase(action)) {
            session.removeAttribute("appliedVoucherCode");
            session.removeAttribute("discountAmount");
            session.setAttribute("message", "Đã gỡ bỏ mã giảm giá!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Calculate subtotal
        double total = 0;
        for (CartItem item : cart) {
            total += item.getProduct().getPrice() * item.getQuantity();
        }
        
        // Recalculate discount if voucher is applied
        String appliedVoucherCode = (String) session.getAttribute("appliedVoucherCode");
        double discount = 0;
        if (appliedVoucherCode != null) {
            VoucherDAO vDao = new VoucherDAO();
            model.Voucher v = vDao.getByCode(appliedVoucherCode);
            if (v != null && v.isStatus() && total >= v.getMinOrderValue()) {
                if ("Percentage".equalsIgnoreCase(v.getDiscountType())) {
                    discount = total * (v.getDiscountValue() / 100.0);
                    if (v.getMaxDiscountAmount() > 0 && discount > v.getMaxDiscountAmount()) {
                        discount = v.getMaxDiscountAmount();
                    }
                } else {
                    discount = v.getDiscountValue();
                }
                if (discount > total) {
                    discount = total;
                }
                session.setAttribute("discountAmount", discount);
            } else {
                session.removeAttribute("appliedVoucherCode");
                session.removeAttribute("discountAmount");
            }
        }
        
        request.setAttribute("totalAmount", total);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

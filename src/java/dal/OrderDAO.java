package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.CartItem;
import model.Order;
import model.OrderDetail;

public class OrderDAO extends DBContext {

    public boolean createOrder(Order order, List<CartItem> cartItems) {
        String insertOrderSql = "INSERT INTO Orders (order_date, username, total_amount, fullname, phone, address, status, voucher_code, discount_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertOrderDetailSql = "INSERT INTO OrderDetails (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        String updateStockSql = "UPDATE Products SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";

        try {
            // Turn off auto-commit for transaction
            connection.setAutoCommit(false);

            // 1. Insert Order
            int orderId = -1;
            try (PreparedStatement stOrder = connection.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                stOrder.setTimestamp(1, order.getOrderDate() != null ? order.getOrderDate() : new Timestamp(System.currentTimeMillis()));
                stOrder.setString(2, order.getUsername());
                stOrder.setDouble(3, order.getTotalAmount());
                stOrder.setString(4, order.getFullname());
                stOrder.setString(5, order.getPhone());
                stOrder.setString(6, order.getAddress());
                stOrder.setString(7, order.getStatus() != null ? order.getStatus() : "Pending");
                stOrder.setString(8, order.getVoucherCode());
                stOrder.setDouble(9, order.getDiscountAmount());

                int affected = stOrder.executeUpdate();
                if (affected == 0) {
                    throw new SQLException("Creating order failed, no rows affected.");
                }

                try (ResultSet generatedKeys = stOrder.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        orderId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating order failed, no ID obtained.");
                    }
                }
            }

            // 2. Insert OrderDetails and Update Stock
            for (CartItem item : cartItems) {
                // Check stock first and update (deduct)
                try (PreparedStatement stUpdateStock = connection.prepareStatement(updateStockSql)) {
                    stUpdateStock.setInt(1, item.getQuantity());
                    stUpdateStock.setInt(2, item.getProduct().getId());
                    stUpdateStock.setInt(3, item.getQuantity());
                    
                    int updated = stUpdateStock.executeUpdate();
                    if (updated == 0) {
                        throw new SQLException("Insufficient stock or product not found for: " + item.getProduct().getName());
                    }
                }

                // Insert detail row
                try (PreparedStatement stDetail = connection.prepareStatement(insertOrderDetailSql)) {
                    stDetail.setInt(1, orderId);
                    stDetail.setInt(2, item.getProduct().getId());
                    stDetail.setInt(3, item.getQuantity());
                    stDetail.setDouble(4, item.getProduct().getPrice());
                    stDetail.executeUpdate();
                }
            }

            // 3. Update Voucher stock if applicable
            if (order.getVoucherCode() != null && !order.getVoucherCode().trim().isEmpty()) {
                String updateVoucherSql = "UPDATE Vouchers SET quantity = quantity - 1 WHERE code = ? AND quantity > 0";
                try (PreparedStatement stVoucher = connection.prepareStatement(updateVoucherSql)) {
                    stVoucher.setString(1, order.getVoucherCode());
                    int updated = stVoucher.executeUpdate();
                    if (updated == 0) {
                        throw new SQLException("Mã giảm giá đã hết lượt sử dụng hoặc không khả dụng!");
                    }
                }
            }

            // Commit the transaction
            connection.commit();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "Transaction rollback due to error", ex);
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "Rollback failed", rollbackEx);
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return false;
    }

    public List<Order> getOrdersByUsername(String username) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT id, order_date, username, total_amount, fullname, phone, address, status, voucher_code, discount_amount FROM Orders WHERE username = ? ORDER BY order_date DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order(
                            rs.getInt("id"),
                            rs.getTimestamp("order_date"),
                            rs.getString("username"),
                            rs.getDouble("total_amount"),
                            rs.getString("fullname"),
                            rs.getString("phone"),
                            rs.getString("address"),
                            rs.getString("status")
                    );
                    o.setVoucherCode(rs.getString("voucher_code"));
                    o.setDiscountAmount(rs.getDouble("discount_amount"));
                    list.add(o);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    //Lấy toàn bộ danh sách đơn hàng và sắp xếp
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT id, order_date, username, total_amount, fullname, phone, address, status, voucher_code, discount_amount FROM Orders ORDER BY order_date DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Order o = new Order(
                        rs.getInt("id"),
                        rs.getTimestamp("order_date"),
                        rs.getString("username"),
                        rs.getDouble("total_amount"),
                        rs.getString("fullname"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("status")
                );
                o.setVoucherCode(rs.getString("voucher_code"));
                o.setDiscountAmount(rs.getDouble("discount_amount"));
                list.add(o);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public Order getOrderById(int id) {
        String sql = "SELECT id, order_date, username, total_amount, fullname, phone, address, status, voucher_code, discount_amount FROM Orders WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order(
                            rs.getInt("id"),
                            rs.getTimestamp("order_date"),
                            rs.getString("username"),
                            rs.getDouble("total_amount"),
                            rs.getString("fullname"),
                            rs.getString("phone"),
                            rs.getString("address"),
                            rs.getString("status")
                    );
                    o.setVoucherCode(rs.getString("voucher_code"));
                    o.setDiscountAmount(rs.getDouble("discount_amount"));
                    return o;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.id, od.order_id, od.product_id, od.quantity, od.price, p.name AS product_name, p.image AS product_image "
                   + "FROM OrderDetails od JOIN Products p ON od.product_id = p.id "
                   + "WHERE od.order_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, orderId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    OrderDetail od = new OrderDetail(
                            rs.getInt("id"),
                            rs.getInt("order_id"),
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getDouble("price")
                    );
                    od.setProductName(rs.getString("product_name"));
                    od.setProductImage(rs.getString("product_image"));
                    list.add(od);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean updateStatus(int orderId, String status) {
        Order currentOrder = getOrderById(orderId);
        if (currentOrder == null) {
            return false;
        }
        String oldStatus = currentOrder.getStatus();

        String sql = "UPDATE Orders SET status = ? WHERE id = ?";
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement st = connection.prepareStatement(sql)) {
                st.setString(1, status);
                st.setInt(2, orderId);
                int rows = st.executeUpdate();
                if (rows == 0) {
                    connection.rollback();
                    return false;
                }
            }

            // 1. Khi hủy đơn hàng: hoàn trả số lượng sản phẩm vào kho
            if ("Cancelled".equalsIgnoreCase(status) && !"Cancelled".equalsIgnoreCase(oldStatus)) {
                List<OrderDetail> details = getOrderDetails(orderId);
                String returnStockSql = "UPDATE Products SET quantity = quantity + ? WHERE id = ?";
                try (PreparedStatement stReturn = connection.prepareStatement(returnStockSql)) {
                    for (OrderDetail item : details) {
                        stReturn.setInt(1, item.getQuantity());
                        stReturn.setInt(2, item.getProductId());
                        stReturn.addBatch();
                    }
                    stReturn.executeBatch();
                }

                // Hoàn lại lượt sử dụng voucher nếu đơn hàng có áp dụng mã giảm giá
                if (currentOrder.getVoucherCode() != null && !currentOrder.getVoucherCode().trim().isEmpty()) {
                    String returnVoucherSql = "UPDATE Vouchers SET quantity = quantity + 1 WHERE code = ?";
                    try (PreparedStatement stVoucher = connection.prepareStatement(returnVoucherSql)) {
                        stVoucher.setString(1, currentOrder.getVoucherCode());
                        stVoucher.executeUpdate();
                    }
                }
            }

            // 2. Nếu đơn trước đó là 'Cancelled' nhưng được đổi lại trạng thái khác: trừ lại số lượng trong kho
            if (!"Cancelled".equalsIgnoreCase(status) && "Cancelled".equalsIgnoreCase(oldStatus)) {
                List<OrderDetail> details = getOrderDetails(orderId);
                String deductStockSql = "UPDATE Products SET quantity = quantity - ? WHERE id = ?";
                try (PreparedStatement stDeduct = connection.prepareStatement(deductStockSql)) {
                    for (OrderDetail item : details) {
                        stDeduct.setInt(1, item.getQuantity());
                        stDeduct.setInt(2, item.getProductId());
                        stDeduct.addBatch();
                    }
                    stDeduct.executeBatch();
                }

                if (currentOrder.getVoucherCode() != null && !currentOrder.getVoucherCode().trim().isEmpty()) {
                    String deductVoucherSql = "UPDATE Vouchers SET quantity = quantity - 1 WHERE code = ? AND quantity > 0";
                    try (PreparedStatement stVoucher = connection.prepareStatement(deductVoucherSql)) {
                        stVoucher.setString(1, currentOrder.getVoucherCode());
                        stVoucher.executeUpdate();
                    }
                }
            }

            connection.commit();

            // Kiểm tra số lần hủy đơn để khóa tài khoản
            if ("Cancelled".equalsIgnoreCase(status) && !"Cancelled".equalsIgnoreCase(oldStatus)) {
                checkAndLockAccount(currentOrder.getUsername());
            }

            return true;
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "Lỗi khi cập nhật trạng thái đơn hàng", ex);
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "Rollback thất bại", rollbackEx);
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return false;
    }

    private void checkAndLockAccount(String username) {
        String countSql = "SELECT COUNT(*) FROM Orders WHERE username = ? AND status = 'Cancelled'";
        String lockSql = "UPDATE Accounts SET status = 0 WHERE username = ?";
        try (PreparedStatement stCount = connection.prepareStatement(countSql)) {
            stCount.setString(1, username);
            try (ResultSet rs = stCount.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    if (count > 3) {
                        try (PreparedStatement stLock = connection.prepareStatement(lockSql)) {
                            stLock.setString(1, username);
                            stLock.executeUpdate();
                        }
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    //Tính tổng doanh thu từ các đơn hàng
    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_amount) FROM Orders WHERE status = 'Completed' OR status = 'Approved'";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    //Đếm tổng số lượng đơn hàng 
    public int getOrderCount() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
}

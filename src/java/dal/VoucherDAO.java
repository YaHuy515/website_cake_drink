package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Voucher;

public class VoucherDAO extends DBContext {

    public List<Voucher> getAll() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT id, code, discount_type, discount_value, min_order_value, max_discount_amount, quantity, start_date, end_date, status FROM Vouchers ORDER BY id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Voucher v = new Voucher(
                        rs.getInt("id"),
                        rs.getString("code"),
                        rs.getString("discount_type"),
                        rs.getDouble("discount_value"),
                        rs.getDouble("min_order_value"),
                        rs.getDouble("max_discount_amount"),
                        rs.getInt("quantity"),
                        rs.getTimestamp("start_date"),
                        rs.getTimestamp("end_date"),
                        rs.getBoolean("status")
                );
                list.add(v);
            }
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public Voucher getById(int id) {
        String sql = "SELECT id, code, discount_type, discount_value, min_order_value, max_discount_amount, quantity, start_date, end_date, status FROM Vouchers WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Voucher(
                            rs.getInt("id"),
                            rs.getString("code"),
                            rs.getString("discount_type"),
                            rs.getDouble("discount_value"),
                            rs.getDouble("min_order_value"),
                            rs.getDouble("max_discount_amount"),
                            rs.getInt("quantity"),
                            rs.getTimestamp("start_date"),
                            rs.getTimestamp("end_date"),
                            rs.getBoolean("status")
                    );
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public Voucher getByCode(String code) {
        String sql = "SELECT id, code, discount_type, discount_value, min_order_value, max_discount_amount, quantity, start_date, end_date, status FROM Vouchers WHERE code = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, code);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Voucher(
                            rs.getInt("id"),
                            rs.getString("code"),
                            rs.getString("discount_type"),
                            rs.getDouble("discount_value"),
                            rs.getDouble("min_order_value"),
                            rs.getDouble("max_discount_amount"),
                            rs.getInt("quantity"),
                            rs.getTimestamp("start_date"),
                            rs.getTimestamp("end_date"),
                            rs.getBoolean("status")
                    );
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean insert(Voucher v) throws SQLException {
        String sql = "INSERT INTO Vouchers (code, discount_type, discount_value, min_order_value, max_discount_amount, quantity, start_date, end_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, v.getCode());
            st.setString(2, v.getDiscountType());
            st.setDouble(3, v.getDiscountValue());
            st.setDouble(4, v.getMinOrderValue());
            st.setDouble(5, v.getMaxDiscountAmount());
            st.setInt(6, v.getQuantity());
            st.setTimestamp(7, v.getStartDate());
            st.setTimestamp(8, v.getEndDate());
            st.setBoolean(9, v.isStatus());
            return st.executeUpdate() > 0;
        }
    }

    public boolean update(Voucher v) throws SQLException {
        String sql = "UPDATE Vouchers SET code = ?, discount_type = ?, discount_value = ?, min_order_value = ?, max_discount_amount = ?, quantity = ?, start_date = ?, end_date = ?, status = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, v.getCode());
            st.setString(2, v.getDiscountType());
            st.setDouble(3, v.getDiscountValue());
            st.setDouble(4, v.getMinOrderValue());
            st.setDouble(5, v.getMaxDiscountAmount());
            st.setInt(6, v.getQuantity());
            st.setTimestamp(7, v.getStartDate());
            st.setTimestamp(8, v.getEndDate());
            st.setBoolean(9, v.isStatus());
            st.setInt(10, v.getId());
            return st.executeUpdate() > 0;
        }
    }

    public boolean toggleStatus(int id) {
        String sql = "UPDATE Vouchers SET status = status ^ 1 WHERE id = ?"; 
        String sqlCompat = "UPDATE Vouchers SET status = CASE WHEN status = 1 THEN 0 ELSE 1 END WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sqlCompat)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean decreaseQuantity(String code) {
        String sql = "UPDATE Vouchers SET quantity = quantity - 1 WHERE code = ? AND quantity > 0";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, code);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}

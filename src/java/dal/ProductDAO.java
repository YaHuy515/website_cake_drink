package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Product;

public class ProductDAO extends DBContext {

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getInt("category_id"),
                rs.getDouble("price"),
                rs.getInt("quantity"),
                rs.getString("image"),
                rs.getString("description"),
                rs.getBoolean("status"),
                rs.getString("detail_description"),
                rs.getString("ingredients"),
                rs.getString("instruction"),
                rs.getString("serving_size")
        );
        try {
            p.setCategoryName(rs.getString("category_name"));
        } catch (SQLException ignored) {}
        return p;
    }

    public List<Product> getAllActive() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.id, p.name, p.category_id, p.price, p.quantity, p.image, p.description, p.status, "
                   + "p.detail_description, p.ingredients, p.instruction, p.serving_size, c.name AS category_name "
                   + "FROM Products p JOIN Categories c ON p.category_id = c.id "
                   + "WHERE p.status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<Product> getAllAdmin() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.id, p.name, p.category_id, p.price, p.quantity, p.image, p.description, p.status, "
                   + "p.detail_description, p.ingredients, p.instruction, p.serving_size, c.name AS category_name "
                   + "FROM Products p JOIN Categories c ON p.category_id = c.id "
                   + "ORDER BY p.id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public Product getById(int id) {
        String sql = "SELECT p.id, p.name, p.category_id, p.price, p.quantity, p.image, p.description, p.status, "
                   + "p.detail_description, p.ingredients, p.instruction, p.serving_size, c.name AS category_name "
                   + "FROM Products p JOIN Categories c ON p.category_id = c.id "
                   + "WHERE p.id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public List<Product> getRelatedProducts(int categoryId, int currentProductId, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.id, p.name, p.category_id, p.price, p.quantity, p.image, p.description, "
                   + "p.status, p.detail_description, p.ingredients, p.instruction, p.serving_size, c.name AS category_name "
                   + "FROM Products p JOIN Categories c ON p.category_id = c.id "
                   + "WHERE p.status = 1 AND p.category_id = ? AND p.id <> ? "
                   + "ORDER BY p.id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            st.setInt(2, categoryId);
            st.setInt(3, currentProductId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<Product> searchAndFilter(String query, int categoryId, String sortOrder) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.id, p.name, p.category_id, p.price, p.quantity, p.image, p.description, p.status, " +
                "p.detail_description, p.ingredients, p.instruction, p.serving_size, c.name AS category_name " +
                "FROM Products p JOIN Categories c ON p.category_id = c.id " +
                "WHERE p.status = 1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + query.trim() + "%");
        }
        
        if (categoryId > 0) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }
        
        if ("price_asc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ORDER BY p.price ASC");
        } else if ("price_desc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ORDER BY p.price DESC");
        } else {
            sql.append(" ORDER BY p.id DESC"); // Default sort
        }
        
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean insert(Product p) {
        String sql = "INSERT INTO Products (name, category_id, price, quantity, image, description, status, detail_description, ingredients, instruction, serving_size) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getName());
            st.setInt(2, p.getCategoryId());
            st.setDouble(3, p.getPrice());
            st.setInt(4, p.getQuantity());
            st.setString(5, p.getImage());
            st.setString(6, p.getDescription());
            st.setBoolean(7, p.isStatus());
            st.setString(8, p.getDetailDescription());
            st.setString(9, p.getIngredients());
            st.setString(10, p.getInstruction());
            st.setString(11, p.getServingSize());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean update(Product p) {
        String sql = "UPDATE Products SET name = ?, category_id = ?, price = ?, quantity = ?, image = ?, description = ?, status = ?, detail_description = ?, ingredients = ?, instruction = ?, serving_size = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getName());
            st.setInt(2, p.getCategoryId());
            st.setDouble(3, p.getPrice());
            st.setInt(4, p.getQuantity());
            st.setString(5, p.getImage());
            st.setString(6, p.getDescription());
            st.setBoolean(7, p.isStatus());
            st.setString(8, p.getDetailDescription());
            st.setString(9, p.getIngredients());
            st.setString(10, p.getInstruction());
            st.setString(11, p.getServingSize());
            st.setInt(12, p.getId());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean toggleStatus(int id) {
        String sql = "UPDATE Products SET status = status ^ 1 WHERE id = ?"; // Toggles between 0 and 1
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateStock(int productId, int newQty) {
        String sql = "UPDATE Products SET quantity = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, newQty);
            st.setInt(2, productId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public int getLowStockCount() {
        String sql = "SELECT COUNT(*) FROM Products WHERE quantity <= 5 AND status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int getActiveCount() {
        String sql = "SELECT COUNT(*) FROM Products WHERE status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
}

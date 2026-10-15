package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;

public class CategoryDAO extends DBContext {

    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name, description FROM Categories";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description")
                );
                list.add(c);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public Category getById(int id) {
        String sql = "SELECT id, name, description FROM Categories WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("description")
                    );
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean insert(Category c) {
        String sql = "INSERT INTO Categories (name, description) VALUES (?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, c.getName());
            st.setString(2, c.getDescription());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean update(Category c) {
        String sql = "UPDATE Categories SET name = ?, description = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, c.getName());
            st.setString(2, c.getDescription());
            st.setInt(3, c.getId());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean delete(int id) {
        // Warning: This could fail if there are products referring to it.
        // In basic CRUD we can delete or alert.
        String sql = "DELETE FROM Categories WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}

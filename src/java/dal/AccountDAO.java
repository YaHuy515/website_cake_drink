package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;

public class AccountDAO extends DBContext {

    public Account login(String username, String password) {
        String sql = "SELECT username, password, fullname, email, role, status FROM Accounts WHERE username = ? AND password = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            st.setString(2, password);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    boolean status = rs.getBoolean("status");
                    if (status) {
                        return new Account(
                                rs.getString("username"),
                                rs.getString("password"),
                                rs.getString("fullname"),
                                rs.getString("email"),
                                rs.getString("role"),
                                status
                        );
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean register(Account acc) {
        String sql = "INSERT INTO Accounts (username, password, fullname, email, role, status) VALUES (?, ?, ?, ?, ?, 1)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, acc.getUsername());
            st.setString(2, acc.getPassword());
            st.setString(3, acc.getFullname());
            st.setString(4, acc.getEmail());
            st.setString(5, acc.getRole() != null ? acc.getRole() : "customer");
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean exists(String username) {
        String sql = "SELECT 1 FROM Accounts WHERE username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public Account getByUsername(String username) {
        String sql = "SELECT username, password, fullname, email, role, status FROM Accounts WHERE username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("fullname"),
                            rs.getString("email"),
                            rs.getString("role"),
                            rs.getBoolean("status")
                    );
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean updatePassword(String username, String newPassword) {
        String sql = "UPDATE Accounts SET password = ? WHERE username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, newPassword);
            st.setString(2, username);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public List<Account> getAll() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT a.username, a.password, a.fullname, a.email, a.role, a.status, " +
                     "(SELECT COUNT(*) FROM Orders o WHERE o.username = a.username AND o.status = 'Cancelled') AS cancelled_count " +
                     "FROM Accounts a ORDER BY a.role, a.username";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Account acc = new Account(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getBoolean("status")
                );
                acc.setCancelledCount(rs.getInt("cancelled_count"));
                list.add(acc);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean toggleStatus(String username) {
        String sql = "UPDATE Accounts SET status = CASE WHEN status = 1 THEN 0 ELSE 1 END WHERE username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}

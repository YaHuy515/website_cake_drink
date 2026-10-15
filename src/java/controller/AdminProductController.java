package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;

@WebServlet(name = "AdminProductController", urlPatterns = {"/admin/products"})
public class AdminProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        ProductDAO prodDao = new ProductDAO();
        CategoryDAO catDao = new CategoryDAO();
        
        if ("delete".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    prodDao.toggleStatus(id);
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
            
        } else if ("add".equalsIgnoreCase(action)) {
            List<Category> categories = catDao.getAll();
            request.setAttribute("categories", categories);
            request.setAttribute("formAction", "add");
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
            return;
            
        } else if ("edit".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    Product prod = prodDao.getById(id);
                    if (prod != null) {
                        List<Category> categories = catDao.getAll();
                        request.setAttribute("product", prod);
                        request.setAttribute("categories", categories);
                        request.setAttribute("formAction", "edit");
                        request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        
        // List action (default)
        List<Product> products = prodDao.getAllAdmin();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String formAction = request.getParameter("formAction");
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String categoryIdStr = request.getParameter("categoryId");
        String priceStr = request.getParameter("price");
        String qtyStr = request.getParameter("quantity");
        String image = request.getParameter("image");
        String description = request.getParameter("description");
        String statusStr = request.getParameter("status"); // checkbox: "on" or null
        
        // Validation
        if (name == null || name.trim().isEmpty() ||
            categoryIdStr == null || categoryIdStr.isEmpty() ||
            priceStr == null || priceStr.isEmpty() ||
            qtyStr == null || qtyStr.isEmpty()) {
            
            request.setAttribute("error", "Vui lòng nhập đầy đủ các trường bắt buộc!");
            repopulateForm(request, response);
            return;
        }
        
        double price = 0;
        int qty = 0;
        int categoryId = 0;
        try {
            price = Double.parseDouble(priceStr);
            qty = Integer.parseInt(qtyStr);
            categoryId = Integer.parseInt(categoryIdStr);
            
            if (price < 0 || qty < 0) {
                request.setAttribute("error", "Giá bán và số lượng không được âm!");
                repopulateForm(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá bán hoặc số lượng không đúng định dạng số!");
            repopulateForm(request, response);
            return;
        }
        
        ProductDAO prodDao = new ProductDAO();
        boolean status = "on".equals(statusStr) || "true".equals(statusStr);
        
        if ("add".equalsIgnoreCase(formAction)) {
            Product p = new Product(0, name.trim(), categoryId, price, qty, image != null ? image.trim() : "", description != null ? description.trim() : "", status);
            boolean success = prodDao.insert(p);
            if (success) {
                request.getSession().setAttribute("message", "Thêm sản phẩm thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                request.setAttribute("error", "Thêm sản phẩm thất bại do lỗi cơ sở dữ liệu!");
                repopulateForm(request, response);
            }
        } else if ("edit".equalsIgnoreCase(formAction)) {
            try {
                int id = Integer.parseInt(idStr);
                Product p = new Product(id, name.trim(), categoryId, price, qty, image != null ? image.trim() : "", description != null ? description.trim() : "", status);
                boolean success = prodDao.update(p);
                if (success) {
                    request.getSession().setAttribute("message", "Cập nhật sản phẩm thành công!");
                    response.sendRedirect(request.getContextPath() + "/admin/products");
                } else {
                    request.setAttribute("error", "Cập nhật sản phẩm thất bại do lỗi cơ sở dữ liệu!");
                    repopulateForm(request, response);
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
            }
        }
    }
    
    private void repopulateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        CategoryDAO catDao = new CategoryDAO();
        request.setAttribute("categories", catDao.getAll());
        
        // Return submitted fields for convenience
        String idStr = request.getParameter("id");
        Product p = new Product();
        if (idStr != null && !idStr.isEmpty()) {
            try {
                p.setId(Integer.parseInt(idStr));
            } catch (NumberFormatException e) {}
        }
        p.setName(request.getParameter("name"));
        try {
            p.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        } catch (Exception e) {}
        try {
            p.setPrice(Double.parseDouble(request.getParameter("price")));
        } catch (Exception e) {}
        try {
            p.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        } catch (Exception e) {}
        p.setImage(request.getParameter("image"));
        p.setDescription(request.getParameter("description"));
        p.setStatus("on".equals(request.getParameter("status")));
        
        request.setAttribute("product", p);
        request.setAttribute("formAction", request.getParameter("formAction"));
        request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
    }
}

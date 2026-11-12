package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet(name = "ProductDetailController", urlPatterns = {"/product-detail", "/product"})
public class ProductDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            idStr = request.getParameter("pid");
        }
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr.trim());
            ProductDAO prodDao = new ProductDAO();
            Product product = prodDao.getById(id);
            
            if (product == null || !product.isStatus()) {
                request.getSession().setAttribute("error", "Sản phẩm không tồn tại hoặc đã ngừng kinh doanh!");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            // Get related products in the same category (excluding this product)
            List<Product> relatedProducts = prodDao.getRelatedProducts(product.getCategoryId(), product.getId(), 4);
            
            request.setAttribute("product", product);
            request.setAttribute("relatedProducts", relatedProducts);
            
            request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}


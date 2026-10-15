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

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        String categoryIdStr = request.getParameter("cid");
        String sortOrder = request.getParameter("sort");
        
        int categoryId = 0;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        CategoryDAO catDao = new CategoryDAO();
        ProductDAO prodDao = new ProductDAO();
        
        List<Category> categories = catDao.getAll();
        List<Product> products = prodDao.searchAndFilter(searchQuery, categoryId, sortOrder);
        
        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("sortOrder", sortOrder);
        
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}

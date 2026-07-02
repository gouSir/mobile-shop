package com.shop.servlet;

import com.shop.dao.ProductDao;
import com.shop.model.Product;
import com.shop.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员商品管理Servlet
 */
public class AdminProductServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 检查管理员权限
        if (!isAdmin(req, resp)) return;

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                req.getRequestDispatcher("/jsp/admin/product_form.jsp").forward(req, resp);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            case "delete":
                deleteProduct(req, resp);
                break;
            default:
                listProducts(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req, resp)) return;

        String action = req.getParameter("action");
        if ("save".equals(action)) {
            saveProduct(req, resp);
        } else if ("update".equals(action)) {
            updateProduct(req, resp);
        }
    }

    /**
     * 商品列表
     */
    private void listProducts(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Product> products = productDao.findAll();
        req.setAttribute("products", products);
        req.getRequestDispatcher("/jsp/admin/product_list.jsp").forward(req, resp);
    }

    /**
     * 显示编辑表单
     */
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            Product product = productDao.findById(Integer.parseInt(idStr));
            req.setAttribute("product", product);
        }
        req.getRequestDispatcher("/jsp/admin/product_form.jsp").forward(req, resp);
    }

    /**
     * 添加商品
     */
    private void saveProduct(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Product product = new Product();
        product.setName(req.getParameter("name"));
        product.setBrand(req.getParameter("brand"));
        product.setDescription(req.getParameter("description"));
        product.setPrice(Double.parseDouble(req.getParameter("price")));
        product.setStock(Integer.parseInt(req.getParameter("stock")));
        product.setImage(req.getParameter("image"));
        product.setCategory(req.getParameter("category"));

        productDao.save(product);
        resp.sendRedirect(req.getContextPath() + "/admin/product?action=list");
    }

    /**
     * 更新商品
     */
    private void updateProduct(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Product product = new Product();
        product.setId(Integer.parseInt(req.getParameter("id")));
        product.setName(req.getParameter("name"));
        product.setBrand(req.getParameter("brand"));
        product.setDescription(req.getParameter("description"));
        product.setPrice(Double.parseDouble(req.getParameter("price")));
        product.setStock(Integer.parseInt(req.getParameter("stock")));
        product.setImage(req.getParameter("image"));
        product.setCategory(req.getParameter("category"));

        productDao.update(product);
        resp.sendRedirect(req.getContextPath() + "/admin/product?action=list");
    }

    /**
     * 删除商品
     */
    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            productDao.delete(Integer.parseInt(idStr));
        }
        resp.sendRedirect(req.getContextPath() + "/admin/product?action=list");
    }

    /**
     * 检查管理员权限
     */
    private boolean isAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return false;
        }
        return true;
    }
}

package com.shop.servlet;

import com.shop.dao.ProductDao;
import com.shop.model.Product;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 商品Servlet - 处理商品列表、搜索、详情
 */
public class ProductServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                showDetail(req, resp);
                break;
            case "search":
                search(req, resp);
                break;
            case "category":
                listByCategory(req, resp);
                break;
            case "brand":
                listByBrand(req, resp);
                break;
            default:
                listAll(req, resp);
                break;
        }
    }

    /**
     * 商品列表
     */
    private void listAll(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Product> products = productDao.findAll();
        req.setAttribute("products", products);
        req.getRequestDispatcher("/jsp/product_list.jsp").forward(req, resp);
    }

    /**
     * 商品详情
     */
    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            Product product = productDao.findById(id);
            if (product != null) {
                req.setAttribute("product", product);
                req.getRequestDispatcher("/jsp/product_detail.jsp").forward(req, resp);
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/product?action=list");
    }

    /**
     * 搜索商品
     */
    private void search(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        List<Product> products;
        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productDao.search(keyword.trim());
            req.setAttribute("keyword", keyword.trim());
        } else {
            products = productDao.findAll();
        }
        req.setAttribute("products", products);
        req.getRequestDispatcher("/jsp/product_list.jsp").forward(req, resp);
    }

    /**
     * 按分类筛选
     */
    private void listByCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String category = req.getParameter("cat");
        List<Product> products = productDao.findByCategory(category);
        req.setAttribute("products", products);
        req.setAttribute("currentCategory", category);
        req.getRequestDispatcher("/jsp/product_list.jsp").forward(req, resp);
    }

    /**
     * 按品牌筛选
     */
    private void listByBrand(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String brand = req.getParameter("name");
        List<Product> products = productDao.findByBrand(brand);
        req.setAttribute("products", products);
        req.setAttribute("currentBrand", brand);
        req.getRequestDispatcher("/jsp/product_list.jsp").forward(req, resp);
    }
}

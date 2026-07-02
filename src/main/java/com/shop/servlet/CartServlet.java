package com.shop.servlet;

import com.shop.dao.CartDao;
import com.shop.dao.ProductDao;
import com.shop.model.CartItem;
import com.shop.model.Product;
import com.shop.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 购物车Servlet
 */
public class CartServlet extends HttpServlet {

    private CartDao cartDao = new CartDao();
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                addToCart(req, resp, user);
                break;
            case "update":
                updateCart(req, resp);
                break;
            case "delete":
                deleteFromCart(req, resp);
                break;
            default:
                listCart(req, resp, user);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    /**
     * 查看购物车
     */
    private void listCart(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        List<CartItem> cartItems = cartDao.findByUserId(user.getId());
        double total = cartItems.stream().mapToDouble(CartItem::getSubtotal).sum();

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("total", total);
        req.getRequestDispatcher("/jsp/cart.jsp").forward(req, resp);
    }

    /**
     * 添加到购物车
     */
    private void addToCart(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        String productIdStr = req.getParameter("productId");
        String quantityStr = req.getParameter("quantity");

        if (productIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/product?action=list");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        int quantity = (quantityStr != null) ? Integer.parseInt(quantityStr) : 1;

        // 检查商品是否存在且有库存
        Product product = productDao.findById(productId);
        if (product == null || product.getStock() < 1) {
            resp.sendRedirect(req.getContextPath() + "/product?action=list");
            return;
        }

        // 检查购物车是否已存在该商品
        CartItem existItem = cartDao.findByUserAndProduct(user.getId(), productId);
        if (existItem != null) {
            // 已存在，更新数量
            int newQuantity = existItem.getQuantity() + quantity;
            cartDao.updateQuantity(existItem.getId(), newQuantity);
        } else {
            // 不存在，新增
            CartItem item = new CartItem();
            item.setUserId(user.getId());
            item.setProductId(productId);
            item.setQuantity(quantity);
            cartDao.add(item);
        }

        resp.sendRedirect(req.getContextPath() + "/cart?action=list");
    }

    /**
     * 更新购物车数量
     */
    private void updateCart(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        String quantityStr = req.getParameter("quantity");

        if (idStr != null && quantityStr != null) {
            int id = Integer.parseInt(idStr);
            int quantity = Integer.parseInt(quantityStr);
            if (quantity > 0) {
                cartDao.updateQuantity(id, quantity);
            } else {
                cartDao.delete(id);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/cart?action=list");
    }

    /**
     * 从购物车删除
     */
    private void deleteFromCart(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            cartDao.delete(id);
        }
        resp.sendRedirect(req.getContextPath() + "/cart?action=list");
    }
}

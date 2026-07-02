package com.shop.servlet;

import com.shop.dao.OrderDao;
import com.shop.model.Order;
import com.shop.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员订单管理Servlet
 */
public class AdminOrderServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

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
            case "ship":
                shipOrder(req, resp);
                break;
            case "complete":
                completeOrder(req, resp);
                break;
            case "delete":
                deleteOrder(req, resp);
                break;
            default:
                listOrders(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    /**
     * 订单列表
     */
    private void listOrders(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Order> orders = orderDao.findAll();
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/jsp/admin/order_list.jsp").forward(req, resp);
    }

    /**
     * 发货
     */
    private void shipOrder(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            orderDao.updateStatus(Integer.parseInt(idStr), "已发货");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/order?action=list");
    }

    /**
     * 完成订单
     */
    private void completeOrder(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            orderDao.updateStatus(Integer.parseInt(idStr), "已完成");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/order?action=list");
    }

    /**
     * 删除订单
     */
    private void deleteOrder(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            orderDao.delete(Integer.parseInt(idStr));
        }
        resp.sendRedirect(req.getContextPath() + "/admin/order?action=list");
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

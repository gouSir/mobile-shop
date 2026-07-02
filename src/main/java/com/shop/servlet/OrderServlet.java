package com.shop.servlet;

import com.shop.dao.CartDao;
import com.shop.dao.OrderDao;
import com.shop.dao.ProductDao;
import com.shop.model.*;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 订单Servlet
 */
public class OrderServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();
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
            case "create":
                showCreateOrder(req, resp, user);
                break;
            case "list":
                listOrders(req, resp, user);
                break;
            default:
                listOrders(req, resp, user);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        String action = req.getParameter("action");
        if ("submit".equals(action)) {
            submitOrder(req, resp, user);
        } else {
            doGet(req, resp);
        }
    }

    /**
     * 显示下单确认页面
     */
    private void showCreateOrder(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        List<CartItem> cartItems = cartDao.findByUserId(user.getId());
        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?action=list");
            return;
        }
        double total = cartItems.stream().mapToDouble(CartItem::getSubtotal).sum();

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("total", total);
        req.setAttribute("user", user);
        req.getRequestDispatcher("/jsp/order_create.jsp").forward(req, resp);
    }

    /**
     * 提交订单
     */
    private void submitOrder(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        String receiverName = req.getParameter("receiverName");
        String receiverPhone = req.getParameter("receiverPhone");
        String receiverAddress = req.getParameter("receiverAddress");

        // 获取购物车
        List<CartItem> cartItems = cartDao.findByUserId(user.getId());
        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?action=list");
            return;
        }

        double total = cartItems.stream().mapToDouble(CartItem::getSubtotal).sum();

        // 生成订单编号
        String orderNo = "MO" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) +
                         String.format("%04d", user.getId());

        // 创建订单
        Order order = new Order();
        order.setUserId(user.getId());
        order.setOrderNo(orderNo);
        order.setTotalAmount(total);
        order.setStatus("待发货");
        order.setReceiverName(receiverName != null ? receiverName : user.getUsername());
        order.setReceiverPhone(receiverPhone != null ? receiverPhone : (user.getPhone() != null ? user.getPhone() : ""));
        order.setReceiverAddress(receiverAddress != null ? receiverAddress : (user.getAddress() != null ? user.getAddress() : ""));

        // 构建订单明细
        for (CartItem cartItem : cartItems) {
            OrderItem item = new OrderItem();
            item.setProductId(cartItem.getProductId());
            item.setProductName(cartItem.getProductName());
            item.setProductPrice(cartItem.getProductPrice());
            item.setQuantity(cartItem.getQuantity());
            item.setSubtotal(cartItem.getSubtotal());
            order.getItems().add(item);

            // 扣减库存
            productDao.updateStock(cartItem.getProductId(), cartItem.getQuantity());
        }

        int orderId = orderDao.createOrder(order);
        if (orderId > 0) {
            // 清空购物车
            cartDao.clearByUserId(user.getId());
            resp.sendRedirect(req.getContextPath() + "/order?action=list");
        } else {
            resp.getWriter().write("<script>alert('下单失败，请重试！');history.back();</script>");
        }
    }

    /**
     * 查看订单列表
     */
    private void listOrders(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        List<Order> orders = orderDao.findByUserId(user.getId());
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/jsp/order_list.jsp").forward(req, resp);
    }
}

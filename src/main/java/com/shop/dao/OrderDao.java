package com.shop.dao;

import com.shop.model.Order;
import com.shop.model.OrderItem;
import com.shop.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单数据访问层
 */
public class OrderDao {

    /**
     * 创建订单并返回订单ID
     */
    public int createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, order_no, total_amount, status, receiver_name, receiver_phone, receiver_address) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 开启事务

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getOrderNo());
            ps.setDouble(3, order.getTotalAmount());
            ps.setString(4, order.getStatus());
            ps.setString(5, order.getReceiverName());
            ps.setString(6, order.getReceiverPhone());
            ps.setString(7, order.getReceiverAddress());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int orderId = -1;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // 插入订单明细
            String itemSql = "INSERT INTO order_items (order_id, product_id, product_name, product_price, quantity, subtotal) " +
                             "VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement itemPs = conn.prepareStatement(itemSql);
            for (OrderItem item : order.getItems()) {
                itemPs.setInt(1, orderId);
                itemPs.setInt(2, item.getProductId());
                itemPs.setString(3, item.getProductName());
                itemPs.setDouble(4, item.getProductPrice());
                itemPs.setInt(5, item.getQuantity());
                itemPs.setDouble(6, item.getSubtotal());
                itemPs.addBatch();
            }
            itemPs.executeBatch();

            conn.commit();
            return orderId;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) { e.printStackTrace(); }
            DBUtil.close(conn, ps);
        }
        return -1;
    }

    /**
     * 获取用户的所有订单
     */
    public List<Order> findByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY create_time DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Order order = extractOrder(rs);
                // 加载订单明细
                order.setItems(findItemsByOrderId(order.getId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * 获取所有订单（管理员）
     */
    public List<Order> findAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY create_time DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Order order = extractOrder(rs);
                order.setItems(findItemsByOrderId(order.getId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * 根据ID获取订单
     */
    public Order findById(int id) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = extractOrder(rs);
                order.setItems(findItemsByOrderId(order.getId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }

    /**
     * 更新订单状态（管理员发货）
     */
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }

    /**
     * 删除订单（管理员）
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM orders WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }

    /**
     * 获取订单明细
     */
    private List<OrderItem> findItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setProductPrice(rs.getDouble("product_price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setSubtotal(rs.getDouble("subtotal"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    private Order extractOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderNo(rs.getString("order_no"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setReceiverName(rs.getString("receiver_name"));
        order.setReceiverPhone(rs.getString("receiver_phone"));
        order.setReceiverAddress(rs.getString("receiver_address"));
        order.setCreateTime(rs.getString("create_time"));
        return order;
    }
}

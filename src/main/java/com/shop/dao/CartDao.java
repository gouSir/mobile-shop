package com.shop.dao;

import com.shop.model.CartItem;
import com.shop.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 购物车数据访问层
 */
public class CartDao {

    /**
     * 获取用户购物车列表（关联商品信息）
     */
    public List<CartItem> findByUserId(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.*, p.name AS product_name, p.brand AS product_brand, " +
                     "p.price AS product_price, p.image AS product_image " +
                     "FROM cart c JOIN products p ON c.product_id = p.id " +
                     "WHERE c.user_id = ? ORDER BY c.create_time DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractCartItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * 查找购物车中是否已存在某商品
     */
    public CartItem findByUserAndProduct(int userId, int productId) {
        String sql = "SELECT c.*, p.name AS product_name, p.brand AS product_brand, " +
                     "p.price AS product_price, p.image AS product_image " +
                     "FROM cart c JOIN products p ON c.product_id = p.id " +
                     "WHERE c.user_id = ? AND c.product_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractCartItem(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }

    /**
     * 添加到购物车
     */
    public boolean add(CartItem item) {
        String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, item.getUserId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }

    /**
     * 更新购物车数量
     */
    public boolean updateQuantity(int id, int quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
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
     * 删除购物车项
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM cart WHERE id = ?";
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
     * 清空用户购物车
     */
    public boolean clearByUserId(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }

    private CartItem extractCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setId(rs.getInt("id"));
        item.setUserId(rs.getInt("user_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setCreateTime(rs.getString("create_time"));
        // 关联属性
        item.setProductName(rs.getString("product_name"));
        item.setProductBrand(rs.getString("product_brand"));
        item.setProductPrice(rs.getDouble("product_price"));
        item.setProductImage(rs.getString("product_image"));
        return item;
    }
}

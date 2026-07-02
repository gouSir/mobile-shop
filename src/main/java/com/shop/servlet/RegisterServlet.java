package com.shop.servlet;

import com.shop.dao.UserDao;
import com.shop.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 用户注册Servlet
 */
public class RegisterServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String repassword = req.getParameter("repassword");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // 验证
        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("error", "用户名不能为空！");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }
        if (password == null || password.trim().length() < 6) {
            req.setAttribute("error", "密码长度不能少于6位！");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(repassword)) {
            req.setAttribute("error", "两次密码输入不一致！");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        // 检查用户名是否已存在
        User existUser = userDao.findByUsername(username.trim());
        if (existUser != null) {
            req.setAttribute("error", "该用户名已被注册！");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password.trim());
        user.setEmail(email != null ? email.trim() : "");
        user.setPhone(phone != null ? phone.trim() : "");
        user.setAddress(address != null ? address.trim() : "");

        int result = userDao.save(user);
        if (result > 0) {
            // 注册成功，自动登录
            User savedUser = userDao.findById(result);
            req.getSession().setAttribute("user", savedUser);
            resp.sendRedirect(req.getContextPath() + "/jsp/index.jsp");
        } else {
            req.setAttribute("error", "注册失败，请稍后重试！");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
        }
    }
}

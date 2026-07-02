package com.shop.servlet;

import com.shop.dao.UserDao;
import com.shop.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 用户登录Servlet
 */
public class LoginServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "用户名和密码不能为空！");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        User user = userDao.findByUsernameAndPassword(username.trim(), password.trim());

        if (user != null) {
            // 登录成功，保存用户信息到Session
            req.getSession().setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + "/jsp/index.jsp");
        } else {
            req.setAttribute("error", "用户名或密码错误！");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        }
    }
}

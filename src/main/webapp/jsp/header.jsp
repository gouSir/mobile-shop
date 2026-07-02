<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    com.shop.model.User loginUser = (com.shop.model.User) session.getAttribute("user");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>手机商城</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f5f5f5; }
        .navbar { box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .card { transition: transform 0.2s; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 4px 15px rgba(0,0,0,0.15); }
        .card-img-top { height: 200px; object-fit: contain; padding: 15px; background: #f8f9fa; }
        .price { color: #e4393c; font-size: 1.3rem; font-weight: bold; }
        .price-big { color: #e4393c; font-size: 1.8rem; font-weight: bold; }
        .footer { background: #2c3e50; color: #ecf0f1; margin-top: 50px; padding: 30px 0; }
        .badge-count { position: relative; top: -8px; left: -5px; font-size: 0.7rem; }
        .category-sidebar .list-group-item { border: none; border-radius: 8px; margin-bottom: 5px; }
        .category-sidebar .list-group-item:hover { background: #0d6efd; color: white; }
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="<%=contextPath%>/jsp/index.jsp">
            <i class="bi bi-phone"></i> 手机商城
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- 搜索框 -->
            <form class="d-flex mx-auto" action="<%=contextPath%>/product" method="get" style="width: 40%;">
                <input type="hidden" name="action" value="search">
                <input class="form-control me-2" type="search" name="keyword" placeholder="搜索手机..." required>
                <button class="btn btn-outline-light" type="submit"><i class="bi bi-search"></i></button>
            </form>

            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="<%=contextPath%>/jsp/index.jsp"><i class="bi bi-house"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=contextPath%>/product?action=list"><i class="bi bi-grid"></i> 全部商品</a>
                </li>
                <% if (loginUser != null) { %>
                <li class="nav-item">
                    <a class="nav-link position-relative" href="<%=contextPath%>/cart?action=list">
                        <i class="bi bi-cart3"></i> 购物车
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=contextPath%>/order?action=list"><i class="bi bi-list-check"></i> 我的订单</a>
                </li>
                <% if ("admin".equals(loginUser.getRole())) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-warning" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-shield-lock"></i> 管理
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="<%=contextPath%>/admin/product?action=list">商品管理</a></li>
                        <li><a class="dropdown-item" href="<%=contextPath%>/admin/order?action=list">订单管理</a></li>
                    </ul>
                </li>
                <% } %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle"></i> <%=loginUser.getUsername()%>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><span class="dropdown-item-text">角色: <%= "admin".equals(loginUser.getRole()) ? "管理员" : "普通用户" %></span></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<%=contextPath%>/user/logout">退出登录</a></li>
                    </ul>
                </li>
                <% } else { %>
                <li class="nav-item">
                    <a class="nav-link" href="<%=contextPath%>/user/login"><i class="bi bi-box-arrow-in-right"></i> 登录</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=contextPath%>/user/register"><i class="bi bi-person-plus"></i> 注册</a>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

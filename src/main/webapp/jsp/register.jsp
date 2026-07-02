<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-body p-5">
                    <div class="text-center mb-4">
                        <i class="bi bi-person-plus fs-1 text-success"></i>
                        <h3>用户注册</h3>
                        <p class="text-muted">注册账号，畅享购物</p>
                    </div>

                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle"></i> <%=request.getAttribute("error")%>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <form action="<%=contextPath%>/user/register" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">用户名 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label">密码 <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="至少6位" required minlength="6">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="repassword" class="form-label">确认密码 <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="repassword" name="repassword" placeholder="再次输入密码" required minlength="6">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="请输入邮箱">
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">手机号码</label>
                            <input type="text" class="form-control" id="phone" name="phone" placeholder="请输入手机号">
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">收货地址</label>
                            <textarea class="form-control" id="address" name="address" rows="2" placeholder="请输入收货地址"></textarea>
                        </div>
                        <button type="submit" class="btn btn-success w-100 mb-3">
                            <i class="bi bi-check-circle"></i> 注册
                        </button>
                    </form>

                    <div class="text-center">
                        <p class="mb-0">已有账号？<a href="<%=contextPath%>/user/login">立即登录</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

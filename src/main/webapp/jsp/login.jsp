<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow">
                <div class="card-body p-5">
                    <div class="text-center mb-4">
                        <i class="bi bi-phone fs-1 text-primary"></i>
                        <h3>手机商城</h3>
                        <p class="text-muted">欢迎回来，请登录您的账户</p>
                    </div>

                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle"></i> <%=request.getAttribute("error")%>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <form action="<%=contextPath%>/user/login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">用户名</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">密码</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 mb-3">
                            <i class="bi bi-box-arrow-in-right"></i> 登录
                        </button>
                    </form>

                    <div class="text-center">
                        <p class="mb-0">还没有账号？<a href="<%=contextPath%>/user/register">立即注册</a></p>
                    </div>

                    <hr>
                    <div class="text-center">
                        <small class="text-muted">
                            管理员账号: admin / admin123<br>
                            测试用户: test / test123
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

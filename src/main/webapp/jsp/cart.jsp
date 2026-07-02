<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>

<div class="container py-4">
    <h4 class="mb-3"><i class="bi bi-cart3"></i> 我的购物车</h4>

    <c:if test="${empty cartItems}">
        <div class="text-center py-5">
            <i class="bi bi-cart-x fs-1 text-muted"></i>
            <p class="text-muted mt-2">购物车是空的</p>
            <a href="<%=contextPath%>/product?action=list" class="btn btn-primary">去购物</a>
        </div>
    </c:if>

    <c:if test="${not empty cartItems}">
        <div class="card shadow-sm mb-3">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>商品</th>
                            <th>单价</th>
                            <th style="width: 150px;">数量</th>
                            <th>小计</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${cartItems}" var="item">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${pageContext.request.contextPath}/images/${item.productImage}"
                                             alt="${item.productName}" style="width: 60px; height: 60px; object-fit: contain;"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.svg'">
                                        <div>
                                            <p class="mb-0 fw-bold">${item.productName}</p>
                                            <small class="text-muted">${item.productBrand}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>&yen;<fmt:formatNumber value="${item.productPrice}" pattern="#,##0.00"/></td>
                                <td>
                                    <form action="<%=contextPath%>/cart" method="get" class="d-flex align-items-center gap-1">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id" value="${item.id}">
                                        <input type="number" name="quantity" value="${item.quantity}"
                                               min="1" max="99" class="form-control form-control-sm"
                                               style="width: 65px;" onchange="this.form.submit()">
                                    </form>
                                </td>
                                <td class="price">&yen;<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                <td>
                                    <a href="<%=contextPath%>/cart?action=delete&id=${item.id}"
                                       class="btn btn-outline-danger btn-sm"
                                       onclick="return confirm('确定要移除该商品吗？')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 结算栏 -->
        <div class="card shadow-sm">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <a href="<%=contextPath%>/product?action=list" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> 继续购物
                        </a>
                    </div>
                    <div class="col-md-6 text-end">
                        <span class="text-muted me-3">共 <b>${cartItems.size()}</b> 件商品</span>
                        <span class="me-4">合计: <span class="price fs-4">&yen;<fmt:formatNumber value="${total}" pattern="#,##0.00"/></span></span>
                        <a href="<%=contextPath%>/order?action=create" class="btn btn-danger btn-lg">
                            <i class="bi bi-bag-check"></i> 去结算
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="footer.jsp" %>

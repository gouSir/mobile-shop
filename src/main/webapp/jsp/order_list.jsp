<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>

<div class="container py-4">
    <h4 class="mb-3"><i class="bi bi-list-check"></i> 我的订单</h4>

    <c:if test="${empty orders}">
        <div class="text-center py-5">
            <i class="bi bi-receipt fs-1 text-muted"></i>
            <p class="text-muted mt-2">暂无订单</p>
            <a href="<%=contextPath%>/product?action=list" class="btn btn-primary">去购物</a>
        </div>
    </c:if>

    <c:if test="${not empty orders}">
        <c:forEach items="${orders}" var="order">
            <div class="card shadow-sm mb-3">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small">订单号: ${order.orderNo}</span>
                        <span class="text-muted small ms-3">${order.createTime}</span>
                    </div>
                    <span class="badge bg-${order.status == '待发货' ? 'warning' : (order.status == '已发货' ? 'info' : 'success')}">
                        ${order.status}
                    </span>
                </div>
                <div class="card-body">
                    <c:forEach items="${order.items}" var="item">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div>
                                <span class="fw-bold">${item.productName}</span>
                                <span class="text-muted ms-2">x${item.quantity}</span>
                            </div>
                            <span>&yen;<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span>
                        </div>
                    </c:forEach>
                </div>
                <div class="card-footer bg-white d-flex justify-content-between align-items-center">
                    <div>
                        <small class="text-muted">收货人: ${order.receiverName} | ${order.receiverPhone}</small>
                        <br>
                        <small class="text-muted">地址: ${order.receiverAddress}</small>
                    </div>
                    <span class="fw-bold fs-5 price">合计: &yen;<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                </div>
            </div>
        </c:forEach>
    </c:if>
</div>

<%@ include file="footer.jsp" %>

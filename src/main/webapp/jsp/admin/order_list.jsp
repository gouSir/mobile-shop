<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="container py-4">
    <h4 class="mb-3"><i class="bi bi-clipboard-check"></i> 订单管理</h4>

    <c:if test="${empty orders}">
        <div class="text-center py-5">
            <i class="bi bi-receipt fs-1 text-muted"></i>
            <p class="text-muted mt-2">暂无订单</p>
        </div>
    </c:if>

    <c:if test="${not empty orders}">
        <c:forEach items="${orders}" var="order">
            <div class="card shadow-sm mb-3">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <div>
                        <span class="fw-bold">订单号: ${order.orderNo}</span>
                        <span class="text-muted ms-3">用户ID: ${order.userId}</span>
                        <span class="text-muted ms-3">${order.createTime}</span>
                    </div>
                    <div>
                        <span class="badge bg-${order.status == '待发货' ? 'warning' : (order.status == '已发货' ? 'info' : 'success')} me-2">
                            ${order.status}
                        </span>
                        <c:if test="${order.status == '待发货'}">
                            <a href="<%=contextPath%>/admin/order?action=ship&id=${order.id}"
                               class="btn btn-sm btn-success"
                               onclick="return confirm('确认发货？')">
                                <i class="bi bi-truck"></i> 发货
                            </a>
                        </c:if>
                        <c:if test="${order.status == '已发货'}">
                            <a href="<%=contextPath%>/admin/order?action=complete&id=${order.id}"
                               class="btn btn-sm btn-primary"
                               onclick="return confirm('确认完成订单？')">
                                <i class="bi bi-check-all"></i> 完成
                            </a>
                        </c:if>
                        <a href="<%=contextPath%>/admin/order?action=delete&id=${order.id}"
                           class="btn btn-sm btn-outline-danger"
                           onclick="return confirm('确定删除该订单吗？')">
                            <i class="bi bi-trash"></i>
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row mb-2">
                        <div class="col-md-6">
                            <small class="text-muted">收货人: ${order.receiverName} | ${order.receiverPhone}</small>
                            <br>
                            <small class="text-muted">地址: ${order.receiverAddress}</small>
                        </div>
                        <div class="col-md-6 text-end">
                            <span class="fw-bold fs-5 price">合计: &yen;<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                        </div>
                    </div>
                    <table class="table table-sm table-borderless">
                        <thead>
                            <tr class="text-muted small">
                                <th>商品</th>
                                <th>单价</th>
                                <th>数量</th>
                                <th>小计</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${order.items}" var="item">
                                <tr>
                                    <td>${item.productName}</td>
                                    <td>&yen;<fmt:formatNumber value="${item.productPrice}" pattern="#,##0.00"/></td>
                                    <td>${item.quantity}</td>
                                    <td>&yen;<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:forEach>
    </c:if>
</div>

<%@ include file="../footer.jsp" %>

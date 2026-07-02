<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>

<div class="container py-4">
    <h4 class="mb-3"><i class="bi bi-bag-check"></i> 确认订单</h4>

    <c:if test="${empty cartItems}">
        <div class="text-center py-5">
            <i class="bi bi-cart-x fs-1 text-muted"></i>
            <p class="text-muted mt-2">购物车是空的，请先添加商品</p>
            <a href="<%=contextPath%>/product?action=list" class="btn btn-primary">去购物</a>
        </div>
    </c:if>

    <c:if test="${not empty cartItems}">
        <div class="row">
            <div class="col-md-8">
                <!-- 收货信息 -->
                <div class="card shadow-sm mb-3">
                    <div class="card-header fw-bold"><i class="bi bi-geo-alt text-danger"></i> 收货信息</div>
                    <div class="card-body">
                        <form id="orderForm" action="<%=contextPath%>/order" method="post">
                            <input type="hidden" name="action" value="submit">
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">收货人 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="receiverName"
                                           value="${user.username}" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">联系电话 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="receiverPhone"
                                           value="${user.phone}" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">收货地址 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="receiverAddress"
                                           value="${user.address}" required>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 商品清单 -->
                <div class="card shadow-sm mb-3">
                    <div class="card-header fw-bold"><i class="bi bi-box"></i> 商品清单</div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>商品</th>
                                    <th>单价</th>
                                    <th>数量</th>
                                    <th>小计</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${cartItems}" var="item">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="${pageContext.request.contextPath}/images/${item.productImage}"
                                                     alt="${item.productName}" style="width: 50px; height: 50px; object-fit: contain;"
                                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.svg'">
                                                <span>${item.productName}</span>
                                            </div>
                                        </td>
                                        <td>&yen;<fmt:formatNumber value="${item.productPrice}" pattern="#,##0.00"/></td>
                                        <td>${item.quantity}</td>
                                        <td>&yen;<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 订单汇总 -->
            <div class="col-md-4">
                <div class="card shadow-sm sticky-top" style="top: 80px;">
                    <div class="card-header fw-bold"><i class="bi bi-calculator"></i> 订单汇总</div>
                    <div class="card-body">
                        <ul class="list-group list-group-flush mb-3">
                            <li class="list-group-item d-flex justify-content-between">
                                <span>商品数量</span>
                                <span>${cartItems.size()} 件</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span>商品总价</span>
                                <span>&yen;<fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span>运费</span>
                                <span class="text-success">免运费</span>
                            </li>
                        </ul>
                        <div class="d-flex justify-content-between align-items-center border-top pt-3">
                            <span class="fw-bold fs-5">应付总额</span>
                            <span class="price-big">&yen;<fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
                        </div>
                        <button type="button" class="btn btn-danger btn-lg w-100 mt-3"
                                onclick="if(confirm('确认提交订单？')) document.getElementById('orderForm').submit()">
                            <i class="bi bi-check-circle"></i> 提交订单
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="footer.jsp" %>

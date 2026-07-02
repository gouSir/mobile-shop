<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="header.jsp" %>

<div class="container py-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="<%=contextPath%>/jsp/index.jsp">首页</a></li>
            <li class="breadcrumb-item"><a href="<%=contextPath%>/product?action=list">全部商品</a></li>
            <li class="breadcrumb-item active">${product.name}</li>
        </ol>
    </nav>

    <c:if test="${empty product}">
        <div class="text-center py-5">
            <i class="bi bi-exclamation-circle fs-1 text-muted"></i>
            <p class="text-muted mt-2">商品不存在或已下架</p>
            <a href="<%=contextPath%>/product?action=list" class="btn btn-primary">返回商品列表</a>
        </div>
    </c:if>

    <c:if test="${not empty product}">
        <div class="card shadow-sm">
            <div class="row g-0">
                <div class="col-md-5 p-4 bg-light text-center">
                    <img src="${pageContext.request.contextPath}/images/${product.image}"
                         class="img-fluid rounded" alt="${product.name}" style="max-height: 400px;"
                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.svg'">
                </div>
                <div class="col-md-7">
                    <div class="card-body p-4">
                        <h3 class="card-title">${product.name}</h3>
                        <p class="text-muted">${product.brand} | ${product.category}</p>
                        <hr>
                        <div class="mb-3">
                            <span class="price-big">&yen;<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="mb-3">
                            <c:if test="${product.stock > 0}">
                                <span class="badge bg-success fs-6">库存 ${product.stock} 件</span>
                            </c:if>
                            <c:if test="${product.stock <= 0}">
                                <span class="badge bg-danger fs-6">暂时缺货</span>
                            </c:if>
                        </div>
                        <h6 class="fw-bold">商品描述</h6>
                        <p class="text-muted mb-4">${product.description}</p>

                        <c:if test="${product.stock > 0}">
                            <form action="<%=contextPath%>/cart" method="get" class="row g-2 align-items-center">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.id}">
                                <div class="col-auto">
                                    <label class="form-label mb-0">数量</label>
                                    <input type="number" name="quantity" class="form-control" value="1"
                                           min="1" max="${product.stock}" style="width: 80px;">
                                </div>
                                <div class="col-auto">
                                    <button type="submit" class="btn btn-danger btn-lg">
                                        <i class="bi bi-cart-plus"></i> 加入购物车
                                    </button>
                                </div>
                            </form>
                        </c:if>
                        <c:if test="${product.stock <= 0}">
                            <button class="btn btn-secondary btn-lg" disabled>暂时缺货</button>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex gap-2 mt-3">
            <a href="<%=contextPath%>/product?action=list" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> 返回列表
            </a>
        </div>
    </c:if>
</div>

<%@ include file="footer.jsp" %>

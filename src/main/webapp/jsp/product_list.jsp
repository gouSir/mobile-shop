<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>

<div class="container py-4">
    <div class="row">
        <!-- 侧边栏筛选 -->
        <div class="col-md-3">
            <div class="card shadow-sm mb-3">
                <div class="card-header fw-bold"><i class="bi bi-funnel"></i> 品牌筛选</div>
                <div class="list-group list-group-flush category-sidebar">
                    <a href="<%=contextPath%>/product?action=list" class="list-group-item list-group-item-action ${empty currentBrand ? 'active' : ''}">
                        全部品牌
                    </a>
                    <a href="<%=contextPath%>/product?action=brand&name=Apple" class="list-group-item list-group-item-action ${currentBrand == 'Apple' ? 'active' : ''}">
                        Apple <i class="bi bi-apple"></i>
                    </a>
                    <a href="<%=contextPath%>/product?action=brand&name=Huawei" class="list-group-item list-group-item-action ${currentBrand == 'Huawei' ? 'active' : ''}">
                        华为 <i class="bi bi-cpu"></i>
                    </a>
                    <a href="<%=contextPath%>/product?action=brand&name=Xiaomi" class="list-group-item list-group-item-action ${currentBrand == 'Xiaomi' ? 'active' : ''}">
                        小米
                    </a>
                    <a href="<%=contextPath%>/product?action=brand&name=Samsung" class="list-group-item list-group-item-action ${currentBrand == 'Samsung' ? 'active' : ''}">
                        三星
                    </a>
                    <a href="<%=contextPath%>/product?action=brand&name=OPPO" class="list-group-item list-group-item-action ${currentBrand == 'OPPO' ? 'active' : ''}">
                        OPPO
                    </a>
                    <a href="<%=contextPath%>/product?action=brand&name=Vivo" class="list-group-item list-group-item-action ${currentBrand == 'Vivo' ? 'active' : ''}">
                        vivo
                    </a>
                    <a href="<%=contextPath%>/product?action=brand&name=OnePlus" class="list-group-item list-group-item-action ${currentBrand == 'OnePlus' ? 'active' : ''}">
                        一加
                    </a>
                    <a href="<%=contextPath%>/product?action=brand&name=Honor" class="list-group-item list-group-item-action ${currentBrand == 'Honor' ? 'active' : ''}">
                        荣耀
                    </a>
                </div>
            </div>

            <div class="card shadow-sm mb-3">
                <div class="card-header fw-bold"><i class="bi bi-collection"></i> 分类筛选</div>
                <div class="list-group list-group-flush category-sidebar">
                    <a href="<%=contextPath%>/product?action=list" class="list-group-item list-group-item-action ${empty currentCategory ? 'active' : ''}">
                        全部分类
                    </a>
                    <a href="<%=contextPath%>/product?action=category&cat=旗舰机" class="list-group-item list-group-item-action ${currentCategory == '旗舰机' ? 'active' : ''}">
                        <i class="bi bi-star-fill text-warning"></i> 旗舰机
                    </a>
                    <a href="<%=contextPath%>/product?action=category&cat=拍照手机" class="list-group-item list-group-item-action ${currentCategory == '拍照手机' ? 'active' : ''}">
                        <i class="bi bi-camera-fill text-primary"></i> 拍照手机
                    </a>
                    <a href="<%=contextPath%>/product?action=category&cat=游戏手机" class="list-group-item list-group-item-action ${currentCategory == '游戏手机' ? 'active' : ''}">
                        <i class="bi bi-controller text-success"></i> 游戏手机
                    </a>
                    <a href="<%=contextPath%>/product?action=category&cat=性价比" class="list-group-item list-group-item-action ${currentCategory == '性价比' ? 'active' : ''}">
                        <i class="bi bi-cash-stack text-danger"></i> 性价比
                    </a>
                </div>
            </div>
        </div>

        <!-- 商品列表 -->
        <div class="col-md-9">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>
                    <c:choose>
                        <c:when test="${not empty keyword}">搜索: "${keyword}" 的结果</c:when>
                        <c:when test="${not empty currentBrand}">品牌: ${currentBrand}</c:when>
                        <c:when test="${not empty currentCategory}">分类: ${currentCategory}</c:when>
                        <c:otherwise>全部商品</c:otherwise>
                    </c:choose>
                    <span class="badge bg-secondary ms-2">${products.size()}件</span>
                </h5>
            </div>

            <c:if test="${empty products}">
                <div class="text-center py-5">
                    <i class="bi bi-inbox fs-1 text-muted"></i>
                    <p class="text-muted mt-2">暂无商品数据</p>
                    <a href="<%=contextPath%>/product?action=list" class="btn btn-outline-primary">查看全部商品</a>
                </div>
            </c:if>

            <div class="row">
                <c:forEach items="${products}" var="p">
                    <div class="col-6 col-md-4 mb-3">
                        <div class="card h-100">
                            <img src="${pageContext.request.contextPath}/images/${p.image}"
                                 class="card-img-top" alt="${p.name}"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.svg'">
                            <div class="card-body">
                                <h6 class="card-title text-truncate" title="${p.name}">${p.name}</h6>
                                <p class="card-text">
                                    <small class="text-muted">${p.brand} | ${p.category}</small>
                                </p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="price">&yen;<fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></span>
                                    <span class="badge bg-${p.stock > 0 ? 'success' : 'danger'}">
                                        ${p.stock > 0 ? '有货' : '缺货'}
                                    </span>
                                </div>
                            </div>
                            <div class="card-footer bg-white border-0">
                                <div class="d-flex gap-1">
                                    <a href="<%=contextPath%>/product?action=detail&id=${p.id}"
                                       class="btn btn-outline-primary btn-sm flex-grow-1">详情</a>
                                    <c:if test="${p.stock > 0}">
                                        <a href="<%=contextPath%>/cart?action=add&productId=${p.id}"
                                           class="btn btn-danger btn-sm">
                                            <i class="bi bi-cart-plus"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

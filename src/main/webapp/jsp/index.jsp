<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shop.dao.ProductDao, com.shop.model.Product, java.util.List" %>
<%
    ProductDao productDao = new ProductDao();
    List<Product> products = productDao.findAll();
    if (products.size() > 8) {
        products = products.subList(0, 8); // 首页只显示前8个
    }
    request.setAttribute("homeProducts", products);
%>
<%@ include file="header.jsp" %>

<!-- 轮播横幅 -->
<div id="heroCarousel" class="carousel slide mb-4" data-bs-ride="carousel">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
    </div>
    <div class="carousel-inner rounded-3">
        <div class="carousel-item active" style="height: 350px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <div class="d-flex align-items-center justify-content-center h-100 text-white text-center">
                <div>
                    <h1 class="fw-bold">新品首发 · 震撼上市</h1>
                    <p class="lead">2025旗舰手机，尽在手机商城</p>
                    <a href="<%=contextPath%>/product?action=list" class="btn btn-light btn-lg">立即选购</a>
                </div>
            </div>
        </div>
        <div class="carousel-item" style="height: 350px; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <div class="d-flex align-items-center justify-content-center h-100 text-white text-center">
                <div>
                    <h1 class="fw-bold">年中大促 · 限时特惠</h1>
                    <p class="lead">多款热销机型直降，最高优惠1000元</p>
                    <a href="<%=contextPath%>/product?action=list" class="btn btn-light btn-lg">抢购</a>
                </div>
            </div>
        </div>
        <div class="carousel-item" style="height: 350px; background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
            <div class="d-flex align-items-center justify-content-center h-100 text-white text-center">
                <div>
                    <h1 class="fw-bold">正品保证 · 官方授权</h1>
                    <p class="lead">全场正品+官方质保+极速发货</p>
                    <a href="<%=contextPath%>/product?action=list" class="btn btn-light btn-lg">逛逛</a>
                </div>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>

<!-- 热销推荐 -->
<div class="container mb-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3><i class="bi bi-fire text-danger"></i> 热销推荐</h3>
        <a href="<%=contextPath%>/product?action=list" class="btn btn-outline-primary btn-sm">查看全部 <i class="bi bi-arrow-right"></i></a>
    </div>
    <div class="row">
        <c:forEach items="${homeProducts}" var="p">
            <div class="col-6 col-md-3 mb-3">
                <div class="card h-100">
                    <img src="${pageContext.request.contextPath}/images/${p.image}"
                         class="card-img-top" alt="${p.name}"
                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.svg'">
                    <div class="card-body">
                        <h6 class="card-title text-truncate">${p.name}</h6>
                        <p class="card-text small text-muted">${p.brand} | ${p.category}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="price">&yen;<fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></span>
                            <a href="<%=contextPath%>/product?action=detail&id=${p.id}" class="btn btn-sm btn-outline-primary">详情</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- 品牌专区 -->
<div class="container mb-5">
    <h3 class="mb-3"><i class="bi bi-tags text-success"></i> 品牌专区</h3>
    <div class="row text-center">
        <%
            String[] brands = {"Apple", "Huawei", "Xiaomi", "Samsung", "OPPO", "Vivo", "OnePlus", "Honor"};
            String[] icons = {"bi-apple", "bi-cpu", "bi-phone-flip", "bi-device-ssd", "bi-camera", "bi-badge-4k", "bi-speedometer2", "bi-star"};
            String[] colors = {"#333", "#cf0a2c", "#ff6900", "#1428a0", "#1ba784", "#415fff", "#eb0028", "#09aebe"};
            for (int i = 0; i < brands.length; i++) {
        %>
        <div class="col-3 col-md-2 mx-auto mb-3">
            <a href="<%=contextPath%>/product?action=brand&name=<%=brands[i]%>" class="text-decoration-none">
                <div class="p-3 rounded-3 shadow-sm bg-white">
                    <i class="<%=icons[i]%> fs-1" style="color:<%=colors[i]%>"></i>
                    <p class="mt-2 mb-0 small fw-bold text-dark"><%=brands[i]%></p>
                </div>
            </a>
        </div>
        <% } %>
    </div>
</div>

<!-- 分类入口 -->
<div class="container mb-5">
    <h3 class="mb-3"><i class="bi bi-collection text-primary"></i> 分类筛选</h3>
    <div class="row">
        <%
            String[][] cats = {
                {"旗舰机", "bi-star-fill", "#ffc107"},
                {"拍照手机", "bi-camera-fill", "#0d6efd"},
                {"游戏手机", "bi-controller", "#198754"},
                {"性价比", "bi-cash-stack", "#dc3545"}
            };
            for (String[] cat : cats) {
        %>
        <div class="col-6 col-md-3 mb-3">
            <a href="<%=contextPath%>/product?action=category&cat=<%=cat[0]%>" class="text-decoration-none">
                <div class="card bg-dark text-white h-100" style="background: linear-gradient(45deg, #2c3e50, #3498db) !important;">
                    <div class="card-body text-center py-4">
                        <i class="<%=cat[1]%> fs-1 mb-2" style="color:<%=cat[2]%>"></i>
                        <h5 class="card-title"><%=cat[0]%></h5>
                    </div>
                </div>
            </a>
        </div>
        <% } %>
    </div>
</div>

<%@ include file="footer.jsp" %>

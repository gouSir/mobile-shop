<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0"><i class="bi bi-box-seam"></i> 商品管理</h4>
        <a href="<%=contextPath%>/admin/product?action=add" class="btn btn-primary">
            <i class="bi bi-plus-circle"></i> 添加商品
        </a>
    </div>

    <c:if test="${empty products}">
        <div class="text-center py-5">
            <i class="bi bi-inbox fs-1 text-muted"></i>
            <p class="text-muted mt-2">暂无商品，请添加</p>
        </div>
    </c:if>

    <c:if test="${not empty products}">
        <div class="card shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>商品图片</th>
                            <th>商品名称</th>
                            <th>品牌</th>
                            <th>分类</th>
                            <th>价格</th>
                            <th>库存</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${products}" var="p">
                            <tr>
                                <td>${p.id}</td>
                                <td>
                                    <img src="${pageContext.request.contextPath}/images/${p.image}"
                                         alt="${p.name}" style="width: 50px; height: 50px; object-fit: contain;"
                                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.svg'">
                                </td>
                                <td><span class="fw-bold">${p.name}</span></td>
                                <td>${p.brand}</td>
                                <td><span class="badge bg-secondary">${p.category}</span></td>
                                <td class="price">&yen;<fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></td>
                                <td>
                                    <span class="badge bg-${p.stock > 10 ? 'success' : (p.stock > 0 ? 'warning' : 'danger')}">
                                        ${p.stock}
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <a href="<%=contextPath%>/admin/product?action=edit&id=${p.id}"
                                           class="btn btn-outline-primary"><i class="bi bi-pencil"></i></a>
                                        <a href="<%=contextPath%>/admin/product?action=delete&id=${p.id}"
                                           class="btn btn-outline-danger"
                                           onclick="return confirm('确定删除「${p.name}」吗？此操作不可恢复！')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="../footer.jsp" %>

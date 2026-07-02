<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header fw-bold">
                    <c:choose>
                        <c:when test="${not empty product}"><i class="bi bi-pencil-square"></i> 编辑商品</c:when>
                        <c:otherwise><i class="bi bi-plus-circle"></i> 添加商品</c:otherwise>
                    </c:choose>
                </div>
                <div class="card-body">
                    <form action="<%=contextPath%>/admin/product" method="post">
                        <input type="hidden" name="action" value="${not empty product ? 'update' : 'save'}">
                        <c:if test="${not empty product}">
                            <input type="hidden" name="id" value="${product.id}">
                        </c:if>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">商品名称 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="name" value="${product.name}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">品牌 <span class="text-danger">*</span></label>
                                <select class="form-select" name="brand">
                                    <option value="Apple" ${product.brand == 'Apple' ? 'selected' : ''}>Apple</option>
                                    <option value="Huawei" ${product.brand == 'Huawei' ? 'selected' : ''}>华为</option>
                                    <option value="Xiaomi" ${product.brand == 'Xiaomi' ? 'selected' : ''}>小米</option>
                                    <option value="Samsung" ${product.brand == 'Samsung' ? 'selected' : ''}>三星</option>
                                    <option value="OPPO" ${product.brand == 'OPPO' ? 'selected' : ''}>OPPO</option>
                                    <option value="Vivo" ${product.brand == 'Vivo' ? 'selected' : ''}>vivo</option>
                                    <option value="OnePlus" ${product.brand == 'OnePlus' ? 'selected' : ''}>一加</option>
                                    <option value="Honor" ${product.brand == 'Honor' ? 'selected' : ''}>荣耀</option>
                                    <option value="Redmi" ${product.brand == 'Redmi' ? 'selected' : ''}>红米</option>
                                    <option value="Realme" ${product.brand == 'Realme' ? 'selected' : ''}>真我</option>
                                    <option value="iQOO" ${product.brand == 'iQOO' ? 'selected' : ''}>iQOO</option>
                                    <option value="ASUS" ${product.brand == 'ASUS' ? 'selected' : ''}>ROG</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">商品描述</label>
                            <textarea class="form-control" name="description" rows="3">${product.description}</textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">价格 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">&yen;</span>
                                    <input type="number" step="0.01" class="form-control" name="price"
                                           value="${product.price}" required>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">库存 <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="stock"
                                       value="${product.stock}" required min="0">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">分类</label>
                                <select class="form-select" name="category">
                                    <option value="旗舰机" ${product.category == '旗舰机' ? 'selected' : ''}>旗舰机</option>
                                    <option value="拍照手机" ${product.category == '拍照手机' ? 'selected' : ''}>拍照手机</option>
                                    <option value="游戏手机" ${product.category == '游戏手机' ? 'selected' : ''}>游戏手机</option>
                                    <option value="性价比" ${product.category == '性价比' ? 'selected' : ''}>性价比</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">图片文件名</label>
                            <input type="text" class="form-control" name="image" value="${product.image}"
                                   placeholder="例如: iphone16.jpg（请将图片放在 images 目录下）">
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i>
                                <c:out value="${not empty product ? '更新商品' : '添加商品'}" />
                            </button>
                            <a href="<%=contextPath%>/admin/product?action=list" class="btn btn-outline-secondary">取消</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>

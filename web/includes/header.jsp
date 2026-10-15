<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiệm Nước & Bánh Ngọt - Order Trực Tuyến</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header>
        <div class="container nav-container">
            <a href="${pageContext.request.contextPath}/home" class="logo">
                🍰 Sweet<span>&Drip</span>
            </a>
            
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="isAdminUri" value="${fn:contains(pageContext.request.requestURI, '/admin') or pageContext.request.servletPath.startsWith('/admin')}" />
            <nav>
                <ul class="nav-links">
                    <c:choose>
                        <%-- 1. Giao diện Web Quản trị (/admin/*) --%>
                        <c:when test="${isAdminUri and not empty sessionScope.admin}">
                            <li><a href="${pageContext.request.contextPath}/home">Cửa hàng (Order)</a></li>
                            <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng <span class="cart-badge"><c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">${sessionScope.cart.size()}</c:if></span></a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Thống kê</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/vouchers">Voucher</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/accounts">Tài khoản</a></li>
                            <li><span class="user-badge">☕ Quản trị: ${sessionScope.admin.fullname}</span></li>
                            <li><a href="${pageContext.request.contextPath}/logout?role=admin" class="btn-login">Đăng xuất</a></li>
                        </c:when>

                        <%-- 2. Giao diện Web Khách hàng (có tài khoản Khách đăng nhập) --%>
                        <c:when test="${not empty sessionScope.account && sessionScope.account.role eq 'customer'}">
                            <li><a href="${pageContext.request.contextPath}/home">Cửa hàng</a></li>
                            <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng <span class="cart-badge"><c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">${sessionScope.cart.size()}</c:if></span></a></li>
                            <li><a href="${pageContext.request.contextPath}/order-history">Đơn hàng</a></li>
                            <li><span class="user-badge">👋 Chào, ${sessionScope.account.fullname}</span></li>
                            <li><a href="${pageContext.request.contextPath}/logout?role=customer" class="btn-login">Đăng xuất</a></li>
                        </c:when>

                        <%-- 3. Giao diện khi chỉ có tài khoản Admin đăng nhập (chưa có khách) --%>
                        <c:when test="${not empty sessionScope.admin}">
                            <li><a href="${pageContext.request.contextPath}/home">Cửa hàng (Order)</a></li>
                            <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng <span class="cart-badge"><c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">${sessionScope.cart.size()}</c:if></span></a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Thống kê</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/vouchers">Voucher</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/accounts">Tài khoản</a></li>
                            <li><span class="user-badge">☕ Quản trị: ${sessionScope.admin.fullname}</span></li>
                            <li><a href="${pageContext.request.contextPath}/logout?role=admin" class="btn-login">Đăng xuất</a></li>
                        </c:when>

                        <%-- 4. Chưa đăng nhập (Khách vãng lai) --%>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/home">Cửa hàng</a></li>
                            <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng <span class="cart-badge"><c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">${sessionScope.cart.size()}</c:if></span></a></li>
                            <li><a href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
                            <li><a href="${pageContext.request.contextPath}/register" class="btn-login">Đăng ký</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </nav>
        </div>
    </header>

    <main class="container">
        <%-- Display Session / Request alerts --%>
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success">
                <span>✨</span> ${sessionScope.message}
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">
                <span>⚠️</span> ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>
        <c:if test="${not empty requestScope.message}">
            <div class="alert alert-success">
                <span>✨</span> ${requestScope.message}
            </div>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger">
                <span>⚠️</span> ${requestScope.error}
            </div>
        </c:if>

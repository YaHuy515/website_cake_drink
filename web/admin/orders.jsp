<jsp:include page="../includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="admin-layout">
    <!-- Sidebar Navigation -->
    <div class="admin-sidebar">
        <h3 style="font-size: 16px; color: var(--text-muted); margin-bottom: 15px; font-weight: 700; text-transform: uppercase;">Quản lý cửa hàng</h3>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">📊 Tổng quan thống kê</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products" class="sidebar-link">🍰 Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link active">📦 Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/vouchers" class="sidebar-link">🎫 Quản lý Voucher</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/accounts" class="sidebar-link">👥 Quản lý Tài khoản</a></li>
        </ul>
    </div>
    
    <!-- Main Content Area -->
    <div class="content-card">
        <div class="section-title">Quản lý đơn đặt hàng</div>
        
        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-state">
                    <h3>Chưa có đơn hàng nào!</h3>
                    <p>Đơn hàng của khách hàng sẽ hiển thị ở đây để xử lý.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="nice-table">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Ngày đặt</th>
                                <th>Khách hàng</th>
                                <th>Số điện thoại</th>
                                <th>Địa chỉ / Số bàn</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th class="text-right">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td><strong>#${o.id}</strong></td>
                                    <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td><strong>${o.fullname}</strong><br><small style="color:var(--text-muted);">${o.username}</small></td>
                                    <td>${o.phone}</td>
                                    <td>${o.address}</td>
                                    <td><strong style="color:var(--primary);"><fmt:formatNumber value="${o.totalAmount}" pattern="#,###" />đ</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status eq 'Pending'}">
                                                <span class="badge pending">Đang chờ</span>
                                            </c:when>
                                            <c:when test="${o.status eq 'Approved'}">
                                                <span class="badge approved">Đang làm</span>
                                            </c:when>
                                            <c:when test="${o.status eq 'Completed'}">
                                                <span class="badge completed">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${o.status eq 'Cancelled'}">
                                                <span class="badge cancelled">Đã hủy</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-right">
                                        <a href="${pageContext.request.contextPath}/admin/orders?id=${o.id}" class="btn btn-outline" style="padding: 6px 14px; font-size: 13px; border-radius: 20px;">Duyệt đơn</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />

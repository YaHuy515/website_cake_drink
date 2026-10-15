<jsp:include page="../includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="admin-layout">
    <!-- Sidebar Navigation -->
    <div class="admin-sidebar">
        <h3 style="font-size: 16px; color: var(--text-muted); margin-bottom: 15px; font-weight: 700; text-transform: uppercase;">Quản lý cửa hàng</h3>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link active">📊 Tổng quan thống kê</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products" class="sidebar-link">🍰 Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link">📦 Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/vouchers" class="sidebar-link">🎫 Quản lý Voucher</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/accounts" class="sidebar-link">👥 Quản lý Tài khoản</a></li>
        </ul>
    </div>
    
    <!-- Main Content Area -->
    <div>
        <h2 style="font-size: 26px; font-weight: 700; color: var(--primary); margin-bottom: 24px;">Trang tổng quan Admin</h2>
        
        <!-- Telemetry Stats Cards Grid -->
        <div class="stats-grid">
            <div class="stat-widget">
                <span class="stat-title">Doanh Thu Đã Duyệt</span>
                <span class="stat-value"><fmt:formatNumber value="${totalRevenue}" pattern="#,###" />đ</span>
                <span style="font-size: 13px; color: var(--status-completed);">Đơn hoàn thành & duyệt</span>
            </div>
            <div class="stat-widget">
                <span class="stat-title">Tổng số đơn hàng</span>
                <span class="stat-value">${totalOrders}</span>
                <span style="font-size: 13px; color: var(--text-muted);">Tất cả trạng thái</span>
            </div>
            <div class="stat-widget">
                <span class="stat-title">Sản phẩm đang bán</span>
                <a href="/Demo_PRJ301_SU26_E1/admin/products" class="stat-value">${totalProducts}</a>
                <span style="font-size: 13px; color: var(--status-approved);">Trạng thái: Hoạt động</span>
            </div>
            <div class="stat-widget" style="border-left: 4px solid var(--status-cancelled);">
                <span class="stat-title" style="color: var(--status-cancelled);">Sắp hết / Hết hàng</span>
                <span class="stat-value" style="color: var(--status-cancelled);">${outOfStock}</span>
                <span style="font-size: 13px; color: var(--text-muted);">Số lượng kho <= 5</span>
            </div>
             
        </div>
        
        <!-- Recent Orders Section -->
        <div class="content-card">
            <div class="section-title">
                <span>Đơn hàng mới nhận</span>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline" style="padding: 6px 14px; font-size: 13px; border-radius: 20px;">Tất cả đơn hàng</a>
            </div>
            
            <c:choose>
                <c:when test="${empty recentOrders}">
                    <div class="empty-state" style="padding: 30px;">
                        <p>Chưa có đơn hàng nào được ghi nhận trên hệ thống.</p>
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
                                    <th>Bàn / Địa chỉ</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th class="text-right">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${recentOrders}">
                                    <tr>
                                        <td><strong>#${o.id}</strong></td>
                                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        <td><strong>${o.fullname}</strong><br><small style="color:var(--text-muted);">${o.username}</small></td>
                                        <td>${o.address}</td>
                                        <td><strong><fmt:formatNumber value="${o.totalAmount}" pattern="#,###" />đ</strong></td>
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
                                            <a href="${pageContext.request.contextPath}/admin/orders?id=${o.id}" class="btn btn-outline" style="padding: 6px 14px; font-size: 13px; border-radius: 20px;">Duyệt / Chi tiết</a>
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
</div>

<jsp:include page="../includes/footer.jsp" />

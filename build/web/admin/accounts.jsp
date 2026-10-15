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
            <li><a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link">📦 Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/vouchers" class="sidebar-link">🎫 Quản lý Voucher</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/accounts" class="sidebar-link active">👥 Quản lý Tài khoản</a></li>
        </ul>
    </div>
    
    <!-- Main Content Area -->
    <div class="content-card">
        <div class="section-title">
            <span>Danh sách tài khoản người dùng</span>
        </div>
        
        <c:choose>
            <c:when test="${empty accounts}">
                <div class="empty-state">
                    <h3>Không có tài khoản nào!</h3>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="nice-table">
                        <thead>
                            <tr>
                                <th>Tên đăng nhập (Username)</th>
                                <th>Họ và tên</th>
                                <th>Email</th>
                                <th>Vai trò</th>
                                <th class="text-center">Số lần hủy đơn</th>
                                <th>Trạng thái</th>
                                <th class="text-right">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${accounts}">
                                <tr>
                                    <td><strong>${a.username}</strong></td>
                                    <td>${a.fullname}</td>
                                    <td>${a.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${a.role eq 'admin'}">
                                                <span class="user-badge" style="background-color: var(--primary-light); color: var(--primary); font-weight: 700;">Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="user-badge" style="background-color: var(--background); color: var(--text-main);">Customer</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${a.cancelledCount > 3}">
                                                <span style="color: var(--status-cancelled); font-weight: 700;">⚠️ ${a.cancelledCount} lần (Khóa)</span>
                                            </c:when>
                                            <c:when test="${a.cancelledCount > 0}">
                                                <span style="font-weight: 600; color: var(--status-pending);">${a.cancelledCount} lần</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--text-muted);">0</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${a.status}">
                                                <span class="badge completed">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge cancelled">Bị khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-right">
                                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                                            <a href="${pageContext.request.contextPath}/admin/accounts?action=toggle&username=${a.username}" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px; border-radius: 20px; color: ${a.status ? 'var(--status-cancelled)' : 'var(--status-completed)'}; border-color: var(--border);" 
                                               onclick="return confirm('Bạn có muốn thay đổi trạng thái hoạt động của tài khoản này?')">
                                                <c:choose>
                                                    <c:when test="${a.status}">Khóa</c:when>
                                                    <c:otherwise>Mở khóa</c:otherwise>
                                                </c:choose>
                                            </a>
                                        </div>
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

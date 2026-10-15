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
            <li><a href="${pageContext.request.contextPath}/admin/vouchers" class="sidebar-link active">🎫 Quản lý Voucher</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/accounts" class="sidebar-link">👥 Quản lý Tài khoản</a></li>
        </ul>
    </div>
    
    <!-- Main Content Area -->
    <div class="content-card">
        <div class="section-title">
            <span>Danh sách Voucher / Khuyến mãi</span>
            <a href="${pageContext.request.contextPath}/admin/vouchers?action=add" class="btn btn-primary" style="border-radius: 20px; font-size: 13px; padding: 8px 16px;">+ Thêm Voucher</a>
        </div>
        
        <c:choose>
            <c:when test="${empty vouchers}">
                <div class="empty-state">
                    <h3>Không có mã giảm giá nào!</h3>
                    <p>Hãy thêm voucher mới để kích thích nhu cầu mua sắm của khách hàng.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="nice-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Mã Code</th>
                                <th>Loại giảm giá</th>
                                <th>Mức giảm</th>
                                <th>Đơn tối thiểu</th>
                                <th>Giảm tối đa</th>
                                <th>Số lượng</th>
                                <th>Hiệu lực</th>
                                <th>Trạng thái</th>
                                <th class="text-right">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="v" items="${vouchers}">
                                <tr>
                                    <td>#${v.id}</td>
                                    <td><strong><span class="user-badge" style="background-color: var(--primary-light); color: var(--primary); font-size: 13px; font-weight: 700;">${v.code}</span></strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${v.discountType eq 'Percentage'}">Theo phần trăm (%)</c:when>
                                            <c:otherwise>Theo số tiền cố định</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${v.discountType eq 'Percentage'}">${v.discountValue}%</c:when>
                                                <c:otherwise><fmt:formatNumber value="${v.discountValue}" pattern="#,###" />đ</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </td>
                                    <td><fmt:formatNumber value="${v.minOrderValue}" pattern="#,###" />đ</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${v.discountType eq 'Percentage' && v.maxDiscountAmount > 0}">
                                                <fmt:formatNumber value="${v.maxDiscountAmount}" pattern="#,###" />đ
                                            </c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${v.quantity <= 0}">
                                                <span style="color: var(--status-cancelled); font-weight: 700;">Hết lượt</span>
                                            </c:when>
                                            <c:otherwise>${v.quantity}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <small style="color: var(--text-muted);">
                                            Từ: <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy HH:mm" /><br>
                                            Đến: <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${v.status}">
                                                <span class="badge completed">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge cancelled">Ngừng hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-right">
                                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                                            <a href="${pageContext.request.contextPath}/admin/vouchers?action=edit&id=${v.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px; border-radius: 20px; color: var(--primary);">Sửa</a>
                                            <a href="${pageContext.request.contextPath}/admin/vouchers?action=toggle&id=${v.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px; border-radius: 20px; color: ${v.status ? 'var(--status-cancelled)' : 'var(--status-completed)'}; border-color: var(--border);" 
                                               onclick="return confirm('Bạn có muốn đổi trạng thái hoạt động của voucher này?')">
                                                <c:choose>
                                                    <c:when test="${v.status}">Ngừng dùng</c:when>
                                                    <c:otherwise>Kích hoạt</c:otherwise>
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

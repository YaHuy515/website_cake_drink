<jsp:include page="../includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="admin-layout">
    <!-- Sidebar Navigation -->
    <div class="admin-sidebar">
        <h3 style="font-size: 16px; color: var(--text-muted); margin-bottom: 15px; font-weight: 700; text-transform: uppercase;">Quản lý cửa hàng</h3>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">📊 Tổng quan thống kê</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products" class="sidebar-link active">🍰 Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link">📦 Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/vouchers" class="sidebar-link">🎫 Quản lý Voucher</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/accounts" class="sidebar-link">👥 Quản lý Tài khoản</a></li>
        </ul>
    </div>
    
    <!-- Main Content Area -->
    <div class="content-card">
        <div class="section-title">
            <span>Danh mục sản phẩm</span>
            <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn btn-primary" style="border-radius: 20px; font-size: 13px; padding: 8px 16px;">+ Thêm sản phẩm</a>
        </div>
        
        <c:choose>
            <c:when test="${empty products}">
                <div class="empty-state">
                    <h3>Không có sản phẩm nào!</h3>
                    <p>Hãy thêm sản phẩm mới vào danh mục bán hàng.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="nice-table">
                        <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Hình ảnh</th>
                                <th>Tên sản phẩm</th>
                                <th>Danh mục</th>
                                <th>Đơn giá</th>
                                <th>Kho hàng</th>
                                <th>Trạng thái</th>
                                <th class="text-right">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td>#${p.id}</td>
                                    <td><img src="${p.image}" class="table-img" alt="${p.name}" onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=60'"></td>
                                    <td><strong>${p.name}</strong></td>
                                    <td><span class="user-badge" style="background-color: var(--background); font-size: 12px; padding: 4px 8px;">${p.categoryName}</span></td>
                                    <td><strong><fmt:formatNumber value="${p.price}" pattern="#,###" />đ</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.quantity <= 0}">
                                                <span style="color: var(--status-cancelled); font-weight: 700;">Hết hàng</span>
                                            </c:when>
                                            <c:when test="${p.quantity <= 5}">
                                                <span style="color: var(--status-pending); font-weight: 700;">Còn ít: ${p.quantity}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span>${p.quantity}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status}">
                                                <span class="badge completed">Đang bán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge cancelled">Ngừng bán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-right">
                                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                                            <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px; border-radius: 20px; color: var(--primary);">Sửa</a>
                                            <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px; border-radius: 20px; color: var(--status-cancelled); border-color: var(--border);" 
                                               onclick="return confirm('Bạn có muốn đổi trạng thái kinh doanh của sản phẩm này?')">
                                                <c:choose>
                                                    <c:when test="${p.status}">Ngừng bán</c:when>
                                                    <c:otherwise>Bán lại</c:otherwise>
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

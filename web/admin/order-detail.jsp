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
        <div class="section-title">
            <span>Chi tiết Đơn Hàng #${order.id}</span>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline" style="padding: 6px 14px; font-size: 13px; border-radius: 20px;">Quay lại danh sách</a>
        </div>
        
        <!-- Summary and Status Updates -->
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 30px; border-bottom: 1px dashed var(--border); padding-bottom: 20px;">
            <div>
                <h4 style="font-size: 16px; color: var(--primary); margin-bottom: 10px;">Thông tin giao nhận</h4>
                <p style="font-size: 15px; margin-bottom: 6px;"><strong>Khách hàng:</strong> ${order.fullname} (${order.username})</p>
                <p style="font-size: 15px; margin-bottom: 6px;"><strong>Điện thoại:</strong> ${order.phone}</p>
                <p style="font-size: 15px; margin-bottom: 6px;"><strong>Số bàn / Địa chỉ:</strong> ${order.address}</p>
                <p style="font-size: 15px; margin-bottom: 6px;"><strong>Ngày đặt đơn:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></p>
            </div>
            
            <div style="background-color: var(--background); padding: 20px; border-radius: 8px; border: 1px solid var(--border);">
                <h4 style="font-size: 16px; color: var(--primary); margin-bottom: 12px;">Cập nhật Trạng thái đơn</h4>
                <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                    <input type="hidden" name="id" value="${order.id}">
                    <div style="display: flex; gap: 10px;">
                        <select name="status" class="form-input" style="height: 42px; border-radius: 6px; padding: 0 10px;" required>
                            <option value="Pending" ${order.status eq 'Pending' ? 'selected' : ''}>Đang chờ duyệt</option>
                            <option value="Approved" ${order.status eq 'Approved' ? 'selected' : ''}>Duyệt & Đang làm</option>
                            <option value="Completed" ${order.status eq 'Completed' ? 'selected' : ''}>Hoàn thành đơn</option>
                            <option value="Cancelled" ${order.status eq 'Cancelled' ? 'selected' : ''}>Hủy đơn hàng</option>
                        </select>
                        <button type="submit" class="btn btn-primary" style="padding: 0 16px; border-radius: 6px; height: 42px;">Cập nhật</button>
                    </div>
                </form>
                <p style="margin-top: 10px; font-size: 13px; color: var(--text-muted);">
                    Trạng thái hiện tại: 
                    <c:choose>
                        <c:when test="${order.status eq 'Pending'}"><span class="badge pending">Đang chờ</span></c:when>
                        <c:when test="${order.status eq 'Approved'}"><span class="badge approved">Đang làm</span></c:when>
                        <c:when test="${order.status eq 'Completed'}"><span class="badge completed">Hoàn thành</span></c:when>
                        <c:when test="${order.status eq 'Cancelled'}"><span class="badge cancelled">Đã hủy</span></c:when>
                    </c:choose>
                </p>
            </div>
        </div>
        
        <!-- Items in Order -->
        <h4 style="font-size: 18px; color: var(--primary); margin-bottom: 15px;">Danh sách sản phẩm order</h4>
        <div class="table-responsive">
            <table class="nice-table">
                <thead>
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th class="text-right">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${orderDetails}">
                        <tr>
                            <td><img src="${item.productImage}" class="table-img" alt="${item.productName}" onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=60'"></td>
                            <td><strong>${item.productName}</strong></td>
                            <td><fmt:formatNumber value="${item.price}" pattern="#,###" />đ</td>
                            <td>${item.quantity}</td>
                            <td class="text-right"><strong><fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###" />đ</strong></td>
                        </tr>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${not empty order.voucherCode}">
                            <tr style="background-color: var(--background);">
                                <td colspan="4" style="text-align: right; font-weight: 600; font-size: 14px; padding: 10px;">Tổng tiền món:</td>
                                <td class="text-right" style="font-weight: 600; font-size: 15px; padding: 10px;">
                                    <fmt:formatNumber value="${order.totalAmount + order.discountAmount}" pattern="#,###" />đ
                                </td>
                            </tr>
                            <tr style="background-color: var(--background);">
                                <td colspan="4" style="text-align: right; font-weight: 600; font-size: 14px; padding: 10px; color: var(--status-cancelled);">Giảm giá (Voucher: ${order.voucherCode}):</td>
                                <td class="text-right" style="font-weight: 600; font-size: 15px; padding: 10px; color: var(--status-cancelled);">-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###" />đ</td>
                            </tr>
                        </c:when>
                    </c:choose>
                    <tr style="background-color: var(--background);">
                        <td colspan="4" style="text-align: right; font-weight: 700; font-size: 16px; padding: 16px;">Tổng thanh toán:</td>
                        <td class="text-right" style="font-weight: 700; font-size: 18px; color: var(--primary); padding: 16px;"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###" />đ</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />

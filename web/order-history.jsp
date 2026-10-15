<jsp:include page="includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<h2 style="font-size: 26px; font-weight: 700; color: var(--primary); margin-bottom: 24px;">Lịch sử đặt hàng</h2>

<!-- If an order detail is active -->
<c:if test="${not empty selectedOrder}">
    <div class="content-card" style="border-color: var(--accent);">
        <div class="section-title">
            <span>Chi tiết Đơn Hàng #${selectedOrder.id}</span>
            <a href="${pageContext.request.contextPath}/order-history" class="btn btn-outline" style="padding: 6px 14px; font-size: 13px; border-radius: 20px;">Đóng</a>
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; font-size: 15px; border-bottom: 1px dashed var(--border); padding-bottom: 16px;">
            <div>
                <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${selectedOrder.orderDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                <p><strong>Người nhận:</strong> ${selectedOrder.fullname}</p>
                <p><strong>Số điện thoại:</strong> ${selectedOrder.phone}</p>
                <p><strong>Nơi nhận / Bàn:</strong> ${selectedOrder.address}</p>
            </div>
            <div style="text-align: right;">
                <p><strong>Trạng thái đơn:</strong> 
                    <c:choose>
                        <c:when test="${selectedOrder.status eq 'Pending'}">
                            <span class="badge pending">Đang chờ duyệt</span>
                        </c:when>
                        <c:when test="${selectedOrder.status eq 'Approved'}">
                            <span class="badge approved">Đã duyệt / Đang làm</span>
                        </c:when>
                        <c:when test="${selectedOrder.status eq 'Completed'}">
                            <span class="badge completed">Đã hoàn thành</span>
                        </c:when>
                        <c:when test="${selectedOrder.status eq 'Cancelled'}">
                            <span class="badge cancelled">Đã hủy đơn</span>
                        </c:when>
                    </c:choose>
                </p>
                <p style="font-size: 15px; margin-top: 8px;"><strong>Tổng tiền món:</strong> <span><fmt:formatNumber value="${selectedOrder.totalAmount + selectedOrder.discountAmount}" pattern="#,###" />đ</span></p>
                <c:if test="${not empty selectedOrder.voucherCode}">
                    <p style="font-size: 15px; color: var(--status-cancelled);"><strong>Giảm giá (Voucher: ${selectedOrder.voucherCode}):</strong> <span>-<fmt:formatNumber value="${selectedOrder.discountAmount}" pattern="#,###" />đ</span></p>
                </c:if>
                <p style="font-size: 18px; margin-top: 8px; border-top: 1px dashed var(--border); padding-top: 8px;"><strong>Tổng thanh toán:</strong> <span class="card-price"><fmt:formatNumber value="${selectedOrder.totalAmount}" pattern="#,###" />đ</span></p>
            </div>
        </div>
        
        <div class="table-responsive">
            <table class="nice-table">
                <thead>
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên món</th>
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
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<!-- List of all customer's orders -->
<div class="content-card">
    <div class="section-title">Danh sách đơn hàng của bạn</div>
    
    <c:choose>
        <c:when test="${empty orders}">
            <div class="empty-state">
                <h3>Bạn chưa đặt đơn hàng nào!</h3>
                <p>Khám phá menu đa dạng của chúng tôi để chọn ngay món đồ uống và bánh kẹo yêu thích.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary" style="margin-top: 20px;">Gọi món ngay</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive">
                <table class="nice-table">
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Ngày đặt</th>
                            <th>Người nhận</th>
                            <th>Số bàn / Địa chỉ</th>
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
                                <td>${o.fullname}</td>
                                <td>${o.address}</td>
                                <td><strong style="color: var(--primary-light);"><fmt:formatNumber value="${o.totalAmount}" pattern="#,###" />đ</strong></td>
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
                                <td class="text-right" style="white-space: nowrap;">
                                    <a href="${pageContext.request.contextPath}/order-history?id=${o.id}" class="btn btn-outline" style="padding: 6px 14px; font-size: 13px; border-radius: 20px;">Xem chi tiết</a>
                                    <c:if test="${o.status eq 'Pending'}">
                                        <a href="${pageContext.request.contextPath}/order-history?action=cancel&id=${o.id}" class="btn btn-outline" style="padding: 6px 14px; font-size: 13px; border-radius: 20px; border-color: var(--status-cancelled); color: var(--status-cancelled); margin-left: 5px;" onclick="return confirm('Bạn có thực sự muốn hủy đơn hàng này?')">Hủy đơn</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="includes/footer.jsp" />

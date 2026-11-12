<jsp:include page="includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<h2 style="font-size: 26px; font-weight: 700; color: var(--primary); margin-bottom: 24px;">Giỏ hàng của bạn</h2>

<c:choose>
    <c:when test="${empty sessionScope.cart}">
        <div class="empty-state" style="background-color: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); box-shadow: var(--shadow-sm);">
            <h3>Giỏ hàng đang trống!</h3>
            <p>Trông giỏ hàng của bạn thật trống trải. Hãy thêm vài ly trà sữa hay bánh mousse ngon lành nhé.</p>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary" style="margin-top: 20px;">Quay lại cửa hàng</a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="cart-layout">
            <!-- Left: Cart Items List -->
            <div class="cart-table-wrapper">
                <c:forEach var="item" items="${sessionScope.cart}">
                    <div class="cart-item-row">
                        <div class="cart-item-info">
                            <a href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}" title="Xem chi tiết ${item.product.name}">
                                <img src="${item.product.image}" class="cart-item-img" alt="${item.product.name}" onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=60'">
                            </a>
                            <div class="cart-item-details">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}" style="text-decoration: none; color: inherit;" title="Xem chi tiết ${item.product.name}">
                                    <h4>${item.product.name}</h4>
                                </a>
                                <p>Đơn giá: <fmt:formatNumber value="${item.product.price}" pattern="#,###" />đ</p>
                            </div>
                        </div>
                        
                        <div class="cart-item-qty">
                            <a href="${pageContext.request.contextPath}/cart?action=update&pid=${item.product.id}&qty=${item.quantity - 1}" class="qty-btn">-</a>
                            <span class="qty-val">${item.quantity}</span>
                            <a href="${pageContext.request.contextPath}/cart?action=update&pid=${item.product.id}&qty=${item.quantity + 1}" class="qty-btn">+</a>
                        </div>
                        
                        <div class="cart-item-actions">
                            <span class="cart-item-subtotal"><fmt:formatNumber value="${item.product.price * item.quantity}" pattern="#,###" />đ</span>
                            <a href="${pageContext.request.contextPath}/cart?action=delete&pid=${item.product.id}" class="btn-remove-item" onclick="return confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?')">Xóa</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <!-- Right: Order Summary & Delivery Form -->
            <div class="checkout-card">
                <h3 class="checkout-title">Thông tin đơn hàng</h3>
                <div class="summary-row">
                    <span>Tổng tiền món:</span>
                    <span><strong><fmt:formatNumber value="${totalAmount}" pattern="#,###" />đ</strong></span>
                </div>
                <div class="summary-row">
                    <span>Phí phục vụ / Ship:</span>
                    <span style="color: var(--status-completed); font-weight: 600;">Miễn phí</span>
                </div>
                <c:if test="${not empty sessionScope.appliedVoucherCode}">
                    <div class="summary-row" style="color: var(--status-cancelled);">
                        <span>Giảm giá (Voucher: <strong>${sessionScope.appliedVoucherCode}</strong>):</span>
                        <span>-<strong><fmt:formatNumber value="${sessionScope.discountAmount}" pattern="#,###" />đ</strong></span>
                    </div>
                </c:if>
                <div class="summary-row total">
                    <span>Tổng thanh toán:</span>
                    <span>
                        <c:choose>
                            <c:when test="${not empty sessionScope.discountAmount}">
                                <fmt:formatNumber value="${totalAmount - sessionScope.discountAmount}" pattern="#,###" />
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${totalAmount}" pattern="#,###" />
                            </c:otherwise>
                        </c:choose>đ
                    </span>
                </div>
                
                <!-- Voucher Apply Section -->
                <div style="margin-top: 20px; border-top: 1px dashed var(--border); padding-top: 15px; margin-bottom: 20px;">
                    <c:choose>
                        <c:when test="${empty sessionScope.appliedVoucherCode}">
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="display: flex; gap: 8px;">
                                <input type="hidden" name="action" value="applyVoucher">
                                <input type="text" name="voucherCode" placeholder="Nhập mã giảm giá..." class="form-input" style="margin-bottom: 0; padding: 8px 12px; height: 38px; text-transform: uppercase;" required>
                                <button type="submit" class="btn btn-primary" style="padding: 8px 16px; border-radius: 8px; font-size: 13px; white-space: nowrap; height: 38px; line-height: 22px;">Áp dụng</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div style="display: flex; justify-content: space-between; align-items: center; background-color: var(--background); padding: 8px 12px; border-radius: 8px; border: 1px dashed var(--primary-light);">
                                <span style="font-size: 13px; color: var(--text-main);">🎫 Đang dùng mã: <strong>${sessionScope.appliedVoucherCode}</strong></span>
                                <a href="${pageContext.request.contextPath}/cart?action=removeVoucher" style="color: var(--status-cancelled); font-size: 13px; font-weight: 600; text-decoration: none;">Gỡ bỏ</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <h3 class="checkout-title" style="margin-top: 30px;">Thông tin nhận hàng</h3>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.account or not empty sessionScope.admin}">
                        <form action="${pageContext.request.contextPath}/checkout" method="post" style="margin-top: 15px;">
                            <div class="form-group">
                                <label for="fullname" class="form-label">Tên người nhận *</label>
                                <input type="text" name="fullname" id="fullname" class="form-input" 
                                       placeholder="Nhập tên người nhận" value="${not empty sessionScope.account ? sessionScope.account.fullname : sessionScope.admin.fullname}" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="phone" class="form-label">Số điện thoại *</label>
                                <input type="tel" name="phone" id="phone" class="form-input" 
                                       placeholder="Nhập số điện thoại liên hệ" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label" style="font-weight: 600;">Hình thức phục vụ *</label>
                                <div style="display: flex; gap: 24px; margin-top: 8px; margin-bottom: 12px;">
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 500; cursor: pointer; color: var(--text-main);">
                                        <input type="radio" name="orderType" value="dinein" checked onclick="toggleOrderType(this.value)"> 🍽️ Dùng tại quán
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 500; cursor: pointer; color: var(--text-main);">
                                        <input type="radio" name="orderType" value="takeaway" onclick="toggleOrderType(this.value)"> 🛍️ Mang về
                                    </label>
                                </div>
                            </div>
                            
                            <div id="table-number-group" class="form-group">
                                <label for="tableNumber" class="form-label">Số bàn *</label>
                                <input type="text" name="tableNumber" id="tableNumber" class="form-input" 
                                       placeholder="Nhập số bàn (Ví dụ: Bàn 3, Bàn 5...)" required>
                            </div>
                            
                            <div id="address-group" class="form-group" style="display: none;">
                                <label for="deliveryAddress" class="form-label">Địa chỉ giao hàng (nếu cần ship)</label>
                                <input type="text" name="deliveryAddress" id="deliveryAddress" class="form-input" 
                                       placeholder="Nhập địa chỉ nhận hàng (để trống nếu nhận tại quầy)">
                            </div>
                            
                            <button type="submit" class="btn-submit" style="margin-top: 20px;">Đặt Đơn Hàng Ngay</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; margin-top: 20px; padding: 15px; border: 1px dashed var(--border); border-radius: 8px;">
                            <p style="font-size: 14px; color: var(--text-muted); margin-bottom: 12px;">Bạn cần đăng nhập để tiến hành đặt đơn hàng.</p>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="width: 100%; border-radius: 8px;">Đăng Nhập Ngay</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<script>
    function toggleOrderType(val) {
        const tableGroup = document.getElementById("table-number-group");
        const addressGroup = document.getElementById("address-group");
        const tableInput = document.getElementById("tableNumber");
        
        if (val === "dinein") {
            tableGroup.style.display = "block";
            addressGroup.style.display = "none";
            tableInput.required = true;
        } else {
            tableGroup.style.display = "none";
            addressGroup.style.display = "block";
            tableInput.required = false;
        }
    }
</script>
<jsp:include page="includes/footer.jsp" />

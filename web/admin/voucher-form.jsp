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
            <c:choose>
                <c:when test="${formAction eq 'add'}">Thêm mã Voucher mới</c:when>
                <c:otherwise>Cập nhật Voucher #${voucher.id}</c:otherwise>
            </c:choose>
        </div>
        
        <form action="${pageContext.request.contextPath}/admin/vouchers" method="post" style="max-width: 600px; margin-top: 20px;">
            <input type="hidden" name="formAction" value="${formAction}">
            <input type="hidden" name="id" value="${voucher.id}">
            
            <div class="form-group">
                <label for="code" class="form-label">Mã Code *</label>
                <input type="text" name="code" id="code" class="form-input" style="text-transform: uppercase;"
                       placeholder="Ví dụ: SUMMER50, BANHNGOT10..." value="${voucher.code}" required>
            </div>
            
            <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div>
                    <label for="discountType" class="form-label">Loại giảm giá *</label>
                    <select name="discountType" id="discountType" class="form-input" style="height: 48px;" onchange="toggleDiscountFields()" required>
                        <option value="Amount" ${voucher.discountType eq 'Amount' ? 'selected' : ''}>Số tiền cố định (đ)</option>
                        <option value="Percentage" ${voucher.discountType eq 'Percentage' ? 'selected' : ''}>Theo phần trăm (%)</option>
                    </select>
                </div>
                <div>
                    <label for="discountValue" class="form-label">Mức giảm *</label>
                    <input type="number" name="discountValue" id="discountValue" class="form-input" min="0.1" step="any"
                           placeholder="Ví dụ: 50000 hoặc 10" value="${voucher.discountValue}" required>
                </div>
            </div>
            
            <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div>
                    <label for="minOrderValue" class="form-label">Giá trị đơn hàng tối thiểu (đ)</label>
                    <input type="number" name="minOrderValue" id="minOrderValue" class="form-input" min="0" step="1000"
                           placeholder="Ví dụ: 150000" value="${voucher.minOrderValue}">
                </div>
                <div id="max-discount-wrapper">
                    <label for="maxDiscountAmount" class="form-label">Số tiền giảm tối đa (đ)</label>
                    <input type="number" name="maxDiscountAmount" id="maxDiscountAmount" class="form-input" min="0" step="1000"
                           placeholder="Ví dụ: 30000" value="${voucher.maxDiscountAmount}">
                </div>
            </div>
            
            <div class="form-group">
                <label for="quantity" class="form-label">Số lượng lượt sử dụng *</label>
                <input type="number" name="quantity" id="quantity" class="form-input" min="0"
                       placeholder="Ví dụ: 100" value="${voucher.quantity}" required>
            </div>
            
            <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div>
                    <label for="startDate" class="form-label">Ngày bắt đầu hiệu lực *</label>
                    <input type="datetime-local" name="startDate" id="startDate" class="form-input" 
                           value="<fmt:formatDate value='${voucher.startDate}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required>
                </div>
                <div>
                    <label for="endDate" class="form-label">Ngày hết hạn *</label>
                    <input type="datetime-local" name="endDate" id="endDate" class="form-input" 
                           value="<fmt:formatDate value='${voucher.endDate}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required>
                </div>
            </div>
            
            <div class="form-group" style="display: flex; align-items: center; gap: 10px; margin-top: 24px;">
                <input type="checkbox" name="status" id="status" style="width: 18px; height: 18px; cursor: pointer;" 
                       <c:if test="${formAction eq 'add' or voucher.status}">checked</c:if>>
                <label for="status" style="font-size: 15px; font-weight: 600; cursor: pointer;">Kích hoạt sử dụng voucher này</label>
            </div>
            
            <div style="display: flex; gap: 12px; margin-top: 30px;">
                <button type="submit" class="btn btn-primary" style="border-radius: 8px;">Lưu lại</button>
                <a href="${pageContext.request.contextPath}/admin/vouchers" class="btn btn-outline" style="border-radius: 8px; line-height: 24px;">Hủy bỏ</a>
            </div>
        </form>
    </div>
</div>

<script>
    function toggleDiscountFields() {
        const type = document.getElementById("discountType").value;
        const maxDiscountWrapper = document.getElementById("max-discount-wrapper");
        const maxDiscountInput = document.getElementById("maxDiscountAmount");
        
        if (type === "Percentage") {
            maxDiscountWrapper.style.opacity = "1";
            maxDiscountInput.disabled = false;
        } else {
            maxDiscountWrapper.style.opacity = "0.4";
            maxDiscountInput.disabled = true;
            maxDiscountInput.value = "0";
        }
    }
    // Run once on load
    window.addEventListener('DOMContentLoaded', toggleDiscountFields);
</script>

<jsp:include page="../includes/footer.jsp" />

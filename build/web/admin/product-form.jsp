<jsp:include page="../includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
            <c:choose>
                <c:when test="${formAction eq 'add'}">Thêm sản phẩm mới</c:when>
                <c:otherwise>Cập nhật sản phẩm #${product.id}</c:otherwise>
            </c:choose>
        </div>
        
        <form action="${pageContext.request.contextPath}/admin/products" method="post" style="max-width: 600px; margin-top: 20px;">
            <input type="hidden" name="formAction" value="${formAction}">
            <input type="hidden" name="id" value="${product.id}">
            
            <div class="form-group">
                <label for="name" class="form-label">Tên sản phẩm *</label>
                <input type="text" name="name" id="name" class="form-input" 
                       placeholder="Nhập tên đồ uống hoặc bánh kẹo" value="${product.name}" required>
            </div>
            
            <div class="form-group">
                <label for="categoryId" class="form-label">Danh mục sản phẩm *</label>
                <select name="categoryId" id="categoryId" class="form-input" style="height: 48px;" required>
                    <option value="">Chọn danh mục...</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div>
                    <label for="price" class="form-label">Giá bán (VND) *</label>
                    <input type="number" name="price" id="price" class="form-input" min="0" step="100"
                           placeholder="Ví dụ: 35000" value="<fmt:formatNumber value='${product.price}' pattern='#' />" required>
                </div>
                <div>
                    <label for="quantity" class="form-label">Số lượng nhập kho *</label>
                    <input type="number" name="quantity" id="quantity" class="form-input" min="0"
                           placeholder="Ví dụ: 50" value="${product.quantity}" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="image" class="form-label">Đường dẫn hình ảnh (URL)</label>
                <input type="text" name="image" id="image" class="form-input" 
                       placeholder="Nhập URL ảnh (Unsplash, Imgur...)" value="${product.image}">
            </div>
            
            <div class="form-group">
                <label for="servingSize" class="form-label">Quy cách / Khẩu phần</label>
                <input type="text" name="servingSize" id="servingSize" class="form-input" 
                       placeholder="Ví dụ: Ly 500ml (Size L) hoặc Hộp 4 chiếc (160g)" value="${product.servingSize}">
            </div>
            
            <div class="form-group">
                <label for="ingredients" class="form-label">Thành phần nguyên liệu</label>
                <input type="text" name="ingredients" id="ingredients" class="form-input" 
                       placeholder="Ví dụ: Bột mì hảo hạng, bơ lạt, sữa tươi, trứng gà..." value="${product.ingredients}">
            </div>
            
            <div class="form-group">
                <label for="instruction" class="form-label">Hướng dẫn sử dụng & bảo quản</label>
                <input type="text" name="instruction" id="instruction" class="form-input" 
                       placeholder="Ví dụ: Dùng lạnh trong 2 giờ, bảo quản ngăn mát 2-6°C..." value="${product.instruction}">
            </div>
            
            <div class="form-group">
                <label for="description" class="form-label">Mô tả ngắn gọn (hiển thị trên thẻ sản phẩm)</label>
                <textarea name="description" id="description" class="form-input" rows="2" 
                          placeholder="Mô tả tóm tắt hương vị sản phẩm...">${product.description}</textarea>
            </div>
            
            <div class="form-group">
                <label for="detailDescription" class="form-label">Mô tả chi tiết chuyên sâu (hiển thị tại trang Detail)</label>
                <textarea name="detailDescription" id="detailDescription" class="form-input" rows="4" 
                          placeholder="Mô tả kỹ lưỡng hương vị, câu chuyện xuất xứ, trải nghiệm thưởng thức...">${product.detailDescription}</textarea>
            </div>
            
            <div class="form-group" style="display: flex; align-items: center; gap: 10px; margin-top: 24px;">
                <input type="checkbox" name="status" id="status" style="width: 18px; height: 18px; cursor: pointer;" 
                       <c:if test="${formAction eq 'add' or product.status}">checked</c:if>>
                <label for="status" style="font-size: 15px; font-weight: 600; cursor: pointer;">Mở bán sản phẩm này</label>
            </div>
            
            <div style="display: flex; gap: 12px; margin-top: 30px;">
                <button type="submit" class="btn btn-primary" style="border-radius: 8px;">Lưu lại</button>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline" style="border-radius: 8px; line-height: 24px;">Hủy bỏ</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />

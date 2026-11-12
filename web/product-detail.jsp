<jsp:include page="includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/blossom.css">

<!-- Breadcrumb -->
<nav class="breadcrumb-nav">
    <a href="${pageContext.request.contextPath}/home" class="breadcrumb-link">Trang chủ</a>
    <span class="breadcrumb-separator">/</span>
    <a href="${pageContext.request.contextPath}/home?cid=${product.categoryId}" class="breadcrumb-link">${product.categoryName}</a>
    <span class="breadcrumb-separator">/</span>
    <span class="breadcrumb-current">${product.name}</span>
</nav>

<!-- Main Detail Showcase -->
<div class="product-detail-container">
    <div class="product-detail-grid">
        <!-- Left: Image & Trust Badges -->
        <div class="detail-visual">
            <div class="detail-img-card">
                <span class="detail-category-pill">${product.categoryName}</span>
                <img src="${product.image}" alt="${product.name}" class="detail-main-img" onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop&q=80'">
            </div>
            
            <div class="detail-perks">
                <div class="perk-item">
                    <span class="perk-icon">☘️</span>
                    <div>
                        <strong>100% Tươi mới</strong>
                        <p>Nguyên liệu chọn lọc, pha chế & nướng mới mỗi ngày</p>
                    </div>
                </div>
                <div class="perk-item">
                    <span class="perk-icon">🚀</span>
                    <div>
                        <strong>Giao nhanh 30 phút</strong>
                        <p>Đóng gói giữ nhiệt & đá gel giữ lạnh chuyên dụng</p>
                    </div>
                </div>
                <div class="perk-item">
                    <span class="perk-icon">💯</span>
                    <div>
                        <strong>Đảm bảo hương vị</strong>
                        <p>Cam kết chuẩn vị, đổi mới nếu không đúng chất lượng</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right: Information & Actions -->
        <div class="detail-info">
            <div class="detail-header">
                <a href="${pageContext.request.contextPath}/home?cid=${product.categoryId}" class="detail-cat-link">${product.categoryName}</a>
                <h1 class="detail-title">${product.name}</h1>
                
                <div class="detail-rating-row">
                    <div class="rating-stars">
                        ★★★★★
                    </div>
                    <span class="rating-score">5.0</span>
                    <span class="rating-divider">•</span>
                    <span class="rating-reviews">Được yêu thích nhất tại tiệm</span>
                </div>
            </div>

            <div class="detail-price-box">
                <span class="detail-price-val"><fmt:formatNumber value="${product.price}" pattern="#,###" />đ</span>
                <span class="detail-price-note">(Đã bao gồm thuế & phí đóng gói)</span>
            </div>

            <p class="detail-short-desc">${product.description}</p>

            <!-- Quick Specs -->
            <div class="detail-specs-list">
                <div class="spec-row">
                    <span class="spec-name">Quy cách / Khẩu phần:</span>
                    <span class="spec-value">${not empty product.servingSize ? product.servingSize : '1 Khẩu phần tiêu chuẩn'}</span>
                </div>
                <div class="spec-row">
                    <span class="spec-name">Tình trạng kho:</span>
                    <span class="spec-value">
                        <c:choose>
                            <c:when test="${product.quantity <= 0}">
                                <span class="stock-status out">🔴 Tạm hết hàng</span>
                            </c:when>
                            <c:when test="${product.quantity <= 5}">
                                <span class="stock-status low">🟡 Sắp hết - Chỉ còn ${product.quantity} sản phẩm</span>
                            </c:when>
                            <c:otherwise>
                                <span class="stock-status in">🟢 Còn hàng (${product.quantity} sản phẩm sẵn sàng)</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <!-- Purchase Controls -->
            <c:choose>
                <c:when test="${product.quantity > 0}">
                    <div class="detail-actions-area">
                        <div class="detail-qty-group">
                            <label class="qty-label">Số lượng:</label>
                            <div class="qty-picker">
                                <button type="button" class="btn-qty-step" id="btnMinus" onclick="stepQty(-1)">-</button>
                                <input type="number" id="detailQtyInput" class="qty-input" value="1" min="1" max="${product.quantity}" readonly>
                                <button type="button" class="btn-qty-step" id="btnPlus" onclick="stepQty(1)">+</button>
                            </div>
                        </div>

                        <div class="detail-buttons-row">
                            <a href="${pageContext.request.contextPath}/cart?action=add&pid=${product.id}&qty=1" 
                               id="btnDetailAddCart" 
                               class="btn btn-detail-add btn-add-cart" 
                               data-pid="${product.id}" 
                               data-name="${product.name}">
                                🛒 Thêm vào giỏ hàng
                            </a>
                            <a href="${pageContext.request.contextPath}/cart?action=add&pid=${product.id}&qty=1" 
                               id="btnDetailBuyNow" 
                               class="btn btn-detail-buy">
                                ⚡ Mua ngay
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="out-of-stock-banner">
                        <p>⚠️ Món này hiện đang tạm hết nguyên liệu tươi trong ngày. Vui lòng chọn món khác hoặc quay lại vào ngày mai nhé!</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline" style="margin-top: 12px; display: inline-block;">Khám phá món khác</a>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Detailed Content Tabs / Accordions -->
            <div class="detail-extra-info">
                <div class="extra-info-card">
                    <h3 class="extra-info-title">🍃 Thành phần nguyên liệu</h3>
                    <p class="extra-info-text">${not empty product.ingredients ? product.ingredients : 'Nguyên liệu tươi chọn lọc cao cấp, không chất bảo quản.'}</p>
                </div>

                <div class="extra-info-card">
                    <h3 class="extra-info-title">❄️ Hướng dẫn sử dụng & Bảo quản</h3>
                    <p class="extra-info-text">${not empty product.instruction ? product.instruction : 'Ngon nhất khi thưởng thức trong ngày. Bảo quản nơi khô thoáng hoặc ngăn mát tủ lạnh.'}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Long Story / Description Section -->
    <div class="detail-description-section">
        <h2 class="section-heading">📖 Câu chuyện & Trải nghiệm hương vị</h2>
        <div class="prose-content">
            <p>${product.detailDescription}</p>
        </div>
    </div>

    <!-- Related Products -->
    <c:if test="${not empty relatedProducts}">
        <div class="related-section">
            <div class="related-header">
                <h2 class="section-heading">☘️ Món ngon cùng danh mục "${product.categoryName}"</h2>
                <a href="${pageContext.request.contextPath}/home?cid=${product.categoryId}" class="see-all-link">Xem tất cả &rarr;</a>
            </div>

            <div class="product-grid">
                <c:forEach var="rp" items="${relatedProducts}">
                    <div class="product-card">
                        <div class="card-img-wrapper">
                            <a href="${pageContext.request.contextPath}/product-detail?id=${rp.id}" class="card-img-link" title="Xem chi tiết ${rp.name}">
                                <span class="card-category-badge">${rp.categoryName}</span>
                                <img src="${rp.image}" class="card-img" alt="${rp.name}" onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=60'">
                            </a>
                        </div>
                        
                        <div class="card-body">
                            <a href="${pageContext.request.contextPath}/product-detail?id=${rp.id}" class="card-title-link" title="Xem chi tiết ${rp.name}">
                                <h3 class="card-title">${rp.name}</h3>
                            </a>
                            <p class="card-desc">${rp.description}</p>
                            
                            <div class="card-footer">
                                <div>
                                    <c:choose>
                                        <c:when test="${rp.quantity <= 0}">
                                            <div class="stock-tag low">Hết hàng</div>
                                        </c:when>
                                        <c:when test="${rp.quantity <= 5}">
                                            <div class="stock-tag low">Còn lại ít: ${rp.quantity}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="stock-tag">Còn kho: ${rp.quantity}</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="card-price"><fmt:formatNumber value="${rp.price}" pattern="#,###" />đ</span>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${rp.quantity > 0}">
                                        <a href="${pageContext.request.contextPath}/cart?action=add&pid=${rp.id}" class="btn-add-cart" data-pid="${rp.id}" data-name="${rp.name}">Thêm +</a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-out-of-stock" disabled>Hết</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

<script>
    const maxStock = parseInt("${product.quantity}") || 1;
    const baseContext = "${pageContext.request.contextPath}";
    const pid = "${product.id}";

    function stepQty(delta) {
        const input = document.getElementById("detailQtyInput");
        if (!input) return;
        let current = parseInt(input.value) || 1;
        current += delta;
        if (current < 1) current = 1;
        if (current > maxStock) current = maxStock;
        input.value = current;
        updateActionUrls(current);
    }

    function updateActionUrls(qty) {
        const btnAdd = document.getElementById("btnDetailAddCart");
        const btnBuy = document.getElementById("btnDetailBuyNow");
        if (btnAdd) {
            btnAdd.setAttribute("href", baseContext + "/cart?action=add&pid=" + pid + "&qty=" + qty);
        }
        if (btnBuy) {
            btnBuy.setAttribute("href", baseContext + "/cart?action=add&pid=" + pid + "&qty=" + qty);
        }
    }
</script>

<script src="${pageContext.request.contextPath}/js/blossom.js" defer></script>
<script src="${pageContext.request.contextPath}/js/cart-ajax.js" defer></script>
<jsp:include page="includes/footer.jsp" />


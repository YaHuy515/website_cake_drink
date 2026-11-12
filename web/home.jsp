<jsp:include page="includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/blossom.css">

<div class="hero">
    <div class="hero-content">
        <h1>Tiệm Trà & Bánh Ngọt <br>☘️ Sweet & Drip</h1>
        <p>Order thức uống thanh mát và bánh ngọt thơm lành ngay tại chỗ. Ship tận bàn cực nhanh!</p>
    </div>
</div>


<div class="controls-row">
    <!-- Category Filter Tabs -->
    <div class="category-tabs">
        <a href="${pageContext.request.contextPath}/home?cid=0&search=${searchQuery}&sort=${sortOrder}" 
           class="tab-btn ${selectedCategoryId == 0 ? 'active' : ''}">Tất cả</a>
        <c:forEach var="cat" items="${categories}">
            <a href="${pageContext.request.contextPath}/home?cid=${cat.id}&search=${searchQuery}&sort=${sortOrder}" 
               class="tab-btn ${selectedCategoryId == cat.id ? 'active' : ''}">${cat.name}</a>
        </c:forEach>
    </div>
    
    <!-- Search & Sort Form -->
    <form action="${pageContext.request.contextPath}/home" method="get" style="margin: 0;">
        <input type="hidden" name="cid" value="${selectedCategoryId}">
        <div class="search-sort-group">
            <input type="text" name="search" class="search-input" placeholder="Tìm tên đồ uống, bánh..." value="${searchQuery}">
            
            <select name="sort" class="sort-select" onchange="this.form.submit()">
                <option value="">Sắp xếp mặc định</option>
                <option value="price_asc" ${sortOrder eq 'price_asc' ? 'selected' : ''}>Giá tăng dần</option>
                <option value="price_desc" ${sortOrder eq 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
            </select>
            
            <button type="submit" class="btn btn-primary" style="border-radius: 20px; padding: 0 20px;">Tìm</button>
        </div>
    </form>
</div>

<!-- Products Grid -->
<c:choose>
    <c:when test="${empty products}">
        <div class="empty-state">
            <h3>Không tìm thấy sản phẩm nào!</h3>
            <p>Vui lòng thử từ khóa khác hoặc chuyển danh mục.</p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="product-grid">
            <c:forEach var="p" items="${products}">
                <div class="product-card">
                    <div class="card-img-wrapper">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="card-img-link" title="Xem chi tiết ${p.name}">
                            <span class="card-category-badge">${p.categoryName}</span>
                            <img src="${p.image}" class="card-img" alt="${p.name}" onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=60'">
                        </a>
                    </div>
                    
                    <div class="card-body">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="card-title-link" title="Xem chi tiết ${p.name}">
                            <h3 class="card-title">${p.name}</h3>
                        </a>
                        <p class="card-desc">${p.description}</p>
                        
                        <div class="card-footer">
                            <div>
                                <c:choose>
                                    <c:when test="${p.quantity <= 0}">
                                        <div class="stock-tag low">Hết hàng</div>
                                    </c:when>
                                    <c:when test="${p.quantity <= 5}">
                                        <div class="stock-tag low">Còn lại ít: ${p.quantity}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="stock-tag">Còn kho: ${p.quantity}</div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="card-price"><fmt:formatNumber value="${p.price}" pattern="#,###" />đ</span>
                            </div>
                            
                            <c:choose>
                                <c:when test="${p.quantity > 0}">
                                    <a href="${pageContext.request.contextPath}/cart?action=add&pid=${p.id}" class="btn-add-cart" data-pid="${p.id}" data-name="${p.name}">Thêm +</a>
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
    </c:otherwise>
</c:choose>

<script src="${pageContext.request.contextPath}/js/blossom.js" defer></script>
<script src="${pageContext.request.contextPath}/js/cart-ajax.js" defer></script>
<jsp:include page="includes/footer.jsp" />

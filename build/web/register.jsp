<jsp:include page="includes/header.jsp" />

<div class="auth-wrapper">
    <div class="auth-card">
        <h2 class="auth-title">Đăng Ký Tài Khoản</h2>
        <p class="auth-sub">Tạo tài khoản để bắt đầu trải nghiệm dịch vụ</p>
        
        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="username" class="form-label">Tên đăng nhập *</label>
                <input type="text" name="username" id="username" class="form-input" 
                       placeholder="Nhập tên đăng nhập" value="${requestScope.username}" required>
            </div>
            
            <div class="form-group">
                <label for="password" class="form-label">Mật khẩu *</label>
                <input type="password" name="password" id="password" class="form-input" 
                       placeholder="Nhập mật khẩu" required>
            </div>
            
            <div class="form-group">
                <label for="fullname" class="form-label">Họ và tên *</label>
                <input type="text" name="fullname" id="fullname" class="form-input" 
                       placeholder="Nhập họ và tên của bạn" value="${requestScope.fullname}" required>
            </div>
            
            <div class="form-group">
                <label for="email" class="form-label">Email</label>
                <input type="email" name="email" id="email" class="form-input" 
                       placeholder="Nhập địa chỉ email" value="${requestScope.email}">
            </div>
            
            <button type="submit" class="btn-submit">Đăng Ký</button>
        </form>
        
        <p class="auth-redirect">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </p>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

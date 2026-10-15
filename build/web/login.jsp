<jsp:include page="includes/header.jsp" />

<div class="auth-wrapper">
    <div class="auth-card">
        <h2 class="auth-title">Chào mừng trở lại!</h2>
        <p class="auth-sub">Đăng nhập tài khoản của bạn để tiếp tục</p>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username" class="form-label">Tên đăng nhập</label>
                <input type="text" name="username" id="username" class="form-input" 
                       placeholder="Nhập tên đăng nhập" value="${requestScope.username}" required>
            </div>
            
            <div class="form-group">
                <div class="form-label-row">
                    <label for="password" class="form-label" style="margin-bottom: 0;">Mật khẩu</label>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Quên mật khẩu?</a>
                </div>
                <input type="password" name="password" id="password" class="form-input" 
                       placeholder="Nhập mật khẩu" required>
            </div>
            
            <button type="submit" class="btn-submit">Đăng Nhập</button>
        </form>
        
        <p class="auth-redirect">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
        </p>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

<jsp:include page="includes/header.jsp" />

<div class="auth-wrapper">
    <div class="auth-card">
        <h2 class="auth-title">Quên Mật Khẩu</h2>
        <p class="auth-sub">Nhập thông tin tài khoản để đặt lại mật khẩu mới</p>
        
        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
            <div class="form-group">
                <label for="username" class="form-label">Tên đăng nhập *</label>
                <input type="text" name="username" id="username" class="form-input" 
                       placeholder="Nhập tên đăng nhập của bạn" value="${requestScope.username}" required>
            </div>
            
            <div class="form-group">
                <label for="email" class="form-label">Email đã đăng ký *</label>
                <input type="email" name="email" id="email" class="form-input" 
                       placeholder="Nhập email tài khoản đã liên kết" value="${requestScope.email}" required>
            </div>

            <div class="form-group">
                <label for="newPassword" class="form-label">Mật khẩu mới *</label>
                <input type="password" name="newPassword" id="newPassword" class="form-input" 
                       placeholder="Nhập mật khẩu mới" required>
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới *</label>
                <input type="password" name="confirmPassword" id="confirmPassword" class="form-input" 
                       placeholder="Nhập lại mật khẩu mới" required>
            </div>

            <div class="form-group">
                <label for="captcha" class="form-label">Mã xác nhận (Captcha)</label>
                <div class="captcha-row">
                    <input type="text" name="captcha" id="captcha" class="form-input" 
                           placeholder="Nhập mã xác nhận">
                    <div class="captcha-display" id="captchaCode" title="Nhấn để đổi mã mới" onclick="generateCaptcha()">
                        8K4P9
                    </div>
                    <button type="button" class="captcha-refresh-btn" onclick="generateCaptcha()" title="Đổi mã khác">
                        🔄
                    </button>
                </div>
            </div>
            
            <button type="submit" class="btn-submit">Đặt Lại Mật Khẩu</button>
        </form>
        
        <p class="auth-redirect">
            Nhớ lại mật khẩu rồi? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </p>
    </div>
</div>

<script>
    function generateCaptcha() {
        const chars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
        let code = '';
        for (let i = 0; i < 5; i++) {
            code += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        const badge = document.getElementById('captchaCode');
        if (badge) {
            badge.innerText = code;
        }
    }
    // Randomize on page load
    window.addEventListener('DOMContentLoaded', generateCaptcha);
</script>

<jsp:include page="includes/footer.jsp" />

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Xác nhận OTP & Đổi Mật khẩu - PRJ Cinema</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Đồng bộ nền tối với toàn hệ thống */
        body {
            background-color: #111827;
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            color: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }
        
        /* Form Card */
        .auth-card {
            background-color: #1f2937;
            border: 1px solid #334155;
            border-radius: 12px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6);
        }
        
        /* Tiêu đề (Đã đổi sang Xanh dương) */
        .auth-title {
            color: #3b82f6; 
            font-weight: bold;
            text-align: center;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        /* Ô nhập liệu Dark Mode */
        .form-control {
            background-color: #334155;
            border: 1px solid #475569;
            color: #fff;
        }
        .form-control:focus {
            background-color: #334155;
            color: #fff;
            border-color: #3b82f6; /* Đổi viền focus sang Xanh dương */
            box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.25);
        }
        .form-control::placeholder {
            color: #94a3b8;
        }
        .input-group-text {
            background-color: #0f172a;
            border: 1px solid #475569;
            color: #94a3b8;
        }
        .form-label {
            font-weight: 500;
            color: #cbd5e1;
            font-size: 0.95rem;
        }
        
        /* Nút bấm (Đã đổi sang Xanh dương) */
        .btn-cinema {
            background-color: #3b82f6;
            color: white;
            border: none;
            font-weight: bold;
            padding: 12px;
            transition: 0.3s;
        }
        .btn-cinema:hover {
            background-color: #2563eb;
            color: white;
        }

        /* Tùy chỉnh nút hiển thị mật khẩu để nó đẹp gọn trong input group */
        .btn-outline-secondary {
            border-color: #475569;
            color: #94a3b8;
        }
        .btn-outline-secondary:hover {
            background-color: #475569;
            color: #fff;
        }
    </style>
</head>
<body>

    <div class="auth-card">
        <h3 class="auth-title">
            <i class="fas fa-shield-alt me-2"></i> Xác thực OTP
        </h3>

        <c:if test="${not empty MESSAGE}">
            <div class="alert alert-success alert-dismissible fade show text-center py-2" role="alert">
                <i class="fas fa-check-circle me-1"></i> <strong>${MESSAGE}</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close" style="padding: 10px;"></button>
            </div>
        </c:if>

        <c:if test="${not empty ERROR}">
            <div class="alert alert-danger alert-dismissible fade show text-center py-2" role="alert">
                <i class="fas fa-exclamation-triangle me-1"></i> <strong>${ERROR}</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close" style="padding: 10px;"></button>
            </div>
        </c:if>

        <form action="ForgotPasswordController" method="POST">
            <input type="hidden" name="action" value="verifyAndReset">
            
            <div class="mb-4">
                <label class="form-label">Nhập mã OTP (6 số từ email):</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-envelope-open-text"></i></span>
                    <input type="text" name="otp" class="form-control" placeholder="Ví dụ: 123456" required autocomplete="off">
                </div>
            </div>
            
            <div class="mb-4">
                <label class="form-label">Nhập mật khẩu mới:</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input type="password" name="newPassword" id="newPass" class="form-control" placeholder="Mật khẩu từ 6 ký tự trở lên..." required>
                    <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                        <i class="fas fa-eye" id="eyeIcon"></i>
                    </button>
                </div>
            </div>
            
            <button type="submit" class="btn btn-cinema w-100 rounded-pill mt-2">
                <i class="fas fa-key me-1"></i> Xác nhận đổi mật khẩu
            </button>
        </form>
        
        <div class="text-center mt-4">
            <a href="login.jsp" class="text-decoration-none text-info small">
                <i class="fas fa-arrow-left me-1"></i> Quay lại Đăng nhập
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('newPass');
        const eyeIcon = document.getElementById('eyeIcon');

        togglePassword.addEventListener('click', function () {
            // Kiểm tra type hiện tại
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            
            // Đổi icon mắt
            eyeIcon.classList.toggle('fa-eye');
            eyeIcon.classList.toggle('fa-eye-slash');
        });
    </script>
</body>
</html>
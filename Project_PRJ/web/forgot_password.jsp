<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Forgot password - PRJ Cinema</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Đồng bộ nền tối với toàn hệ thống */
        body {
            background-color: #111827; /* Nền xám đen rất đậm */
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            color: #f8fafc; /* Chữ trắng sáng nhẹ */
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }
        
        /* Khung chứa Form (Card) */
        .auth-card {
            background-color: #1f2937; /* Nền xám đậm vừa */
            border: 1px solid #334155; /* Viền xám xanh nhạt */
            border-radius: 12px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6); /* Đổ bóng tạo chiều sâu */
        }
        
        /* Tiêu đề chính */
        .auth-title {
            /* ĐÃ THAY ĐỔI: Chuyển từ Đỏ sang Xanh dương chuyên nghiệp */
            color: #3b82f6; 
            font-weight: bold;
            text-align: center;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Dòng hướng dẫn nhỏ */
        .auth-subtitle {
            text-align: center;
            color: #94a3b8; /* Màu chữ xám nhạt */
            font-size: 0.9rem;
            margin-bottom: 25px;
        }
        
        /* Cấu hình các ô nhập liệu (Input) trong Dark Mode */
        .form-control {
            background-color: #334155; /* Nền ô nhập liệu xám xanh đậm */
            border: 1px solid #475569; /* Viền xám xanh nhẹ */
            color: #fff; /* Chữ trong ô màu trắng */
        }
        .form-control:focus {
            background-color: #334155;
            color: #fff;
            /* ĐÃ THAY ĐỔI: Viền và bóng đổ khi chọn chuyển sang màu Xanh dương */
            border-color: #3b82f6; 
            box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.25);
        }
        .form-control::placeholder {
            color: #94a3b8; /* Màu chữ gợi ý */
        }
        
        /* Cấu hình phần biểu tượng bên cạnh ô nhập liệu */
        .input-group-text {
            background-color: #0f172a; /* Nền biểu tượng đen đậm */
            border: 1px solid #475569;
            color: #94a3b8; /* Màu biểu tượng xám nhạt */
        }
        .form-label {
            font-weight: 500;
            color: #cbd5e1; /* Màu nhãn trắng xanh nhạt */
            font-size: 0.95rem;
        }
        
        /* Cấu hình Nút bấm */
        .btn-cinema {
            /* ĐÃ THAY ĐỔI: Nền nút chuyển sang màu Xanh dương */
            background-color: #3b82f6; 
            color: white;
            border: none;
            font-weight: bold;
            padding: 12px;
            transition: 0.3s;
        }
        .btn-cinema:hover {
            /* ĐÃ THAY ĐỔI: Màu xanh dương đậm hơn khi rê chuột vào */
            background-color: #2563eb; 
            color: white;
        }
    </style>
</head>
<body>

    <div class="auth-card">
        <h3 class="auth-title">
            <i class="fas fa-unlock-alt me-2"></i> Quên Mật Khẩu
        </h3>
        <p class="auth-subtitle">
            Vui lòng nhập địa chỉ email bạn đã đăng ký. Chúng tôi sẽ gửi một mã OTP gồm 6 chữ số để giúp bạn khôi phục tài khoản.
        </p>

        <c:if test="${not empty ERROR}">
            <div class="alert alert-danger alert-dismissible fade show text-center py-2" role="alert">
                <i class="fas fa-exclamation-triangle me-1"></i> <strong>${ERROR}</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close" style="padding: 10px;"></button>
            </div>
        </c:if>

        <form action="ForgotPasswordController" method="POST" id="forgotForm">
            <input type="hidden" name="action" value="sendOTP">
            
            <div class="mb-4">
                <label class="form-label">Nhập Email của bạn:</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="example@gmail.com" required autocomplete="email">
                </div>
            </div>
            
            <button type="submit" class="btn btn-cinema w-100 rounded-pill mt-2" id="submitBtn">
                <i class="fas fa-paper-plane me-1"></i> Gửi mã OTP
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
        document.getElementById('forgotForm').addEventListener('submit', function() {
            var btn = document.getElementById('submitBtn');
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Đang gửi...';
            btn.classList.add('disabled');
        });
    </script>
</body>
</html>
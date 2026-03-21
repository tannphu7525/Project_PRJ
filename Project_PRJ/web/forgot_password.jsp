<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quên mật khẩu - PRJ Cinema</title>
    
    <style>
        /* --- 1. RESET & NỀN TỐI --- */
        body {
            background-color: #111827; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #f8fafc; 
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            box-sizing: border-box;
        }
        * { box-sizing: border-box; }
        
        /* --- 2. KHUNG FORM (CARD) --- */
        .auth-card {
            background-color: #1f2937; 
            border: 1px solid #334155; 
            border-radius: 12px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6); 
        }
        
        /* Tiêu đề & Phụ đề */
        .auth-title {
            color: #3b82f6; 
            font-weight: bold;
            text-align: center;
            margin-top: 0;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 1.5rem;
        }
        .auth-subtitle {
            text-align: center;
            color: #94a3b8; 
            font-size: 0.9rem;
            margin-bottom: 25px;
            line-height: 1.5;
        }
        
        /* --- 3. THÔNG BÁO LỖI --- */
        .alert-danger {
            background-color: rgba(239, 68, 68, 0.15);
            border: 1px solid #ef4444;
            color: #f87171;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9rem;
        }
        .btn-close {
            background: transparent;
            border: none;
            color: #f87171;
            font-size: 1.2rem;
            font-weight: bold;
            cursor: pointer;
            opacity: 0.8;
        }
        .btn-close:hover { opacity: 1; }
        
        /* --- 4. Ô NHẬP LIỆU (INPUT) --- */
        .form-group {
            margin-bottom: 25px;
        }
        .form-label {
            display: block;
            font-weight: 500;
            color: #cbd5e1;
            font-size: 0.95rem;
            margin-bottom: 8px;
        }
        .form-control {
            width: 100%;
            background-color: #334155;
            border: 1px solid #475569;
            color: #fff;
            padding: 12px 15px;
            border-radius: 6px;
            font-family: inherit;
            font-size: 1rem;
            outline: none;
            transition: 0.3s;
        }
        .form-control:focus {
            border-color: #3b82f6; 
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
        }
        .form-control::placeholder { color: #94a3b8; }
        
        /* --- 5. NÚT BẤM (BUTTON) --- */
        .btn-cinema {
            width: 100%;
            background-color: #3b82f6; 
            color: white;
            border: none;
            font-weight: bold;
            padding: 12px;
            border-radius: 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }
        .btn-cinema:hover:not(:disabled) {
            background-color: #2563eb; 
        }
        .btn-cinema:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }

        /* Vòng xoay Loading tự làm bằng CSS */
        .spinner {
            width: 18px;
            height: 18px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-top-color: #fff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            display: inline-block;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* Liên kết quay lại */
        .back-link-container {
            text-align: center;
            margin-top: 25px;
        }
        .back-link {
            color: #0ea5e9;
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.3s;
        }
        .back-link:hover {
            color: #38bdf8;
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="auth-card">
        <h3 class="auth-title">Quên Mật Khẩu</h3>
        <p class="auth-subtitle">
            Vui lòng nhập địa chỉ email bạn đã đăng ký. Chúng tôi sẽ gửi một mã OTP gồm 6 chữ số để giúp bạn khôi phục tài khoản.
        </p>

        <c:if test="${not empty ERROR}">
            <div class="alert-danger" id="errorAlert">
                <span><strong>Lỗi:</strong> ${ERROR}</span>
                <button type="button" class="btn-close" onclick="document.getElementById('errorAlert').style.display='none'">X</button>
            </div>
        </c:if>

        <form action="ForgotPasswordController" method="POST" id="forgotForm">
            <input type="hidden" name="action" value="sendOTP">
            
            <div class="form-group">
                <label class="form-label">Nhập Email của bạn:</label>
                <input type="email" name="email" class="form-control" placeholder="example@gmail.com" required autocomplete="email">
            </div>
            
            <button type="submit" class="btn-cinema" id="submitBtn">
                Gửi mã OTP
            </button>
        </form>
        
        <div class="back-link-container">
            <a href="login.jsp" class="back-link">
                &larr; Quay lại Đăng nhập
            </a>
        </div>
    </div>

    <script>
        document.getElementById('forgotForm').addEventListener('submit', function() {
            var btn = document.getElementById('submitBtn');
            // Thay thế nội dung nút thành vòng xoay CSS thuần
            btn.innerHTML = '<span class="spinner"></span> Đang gửi...';
            // Vô hiệu hóa nút (Dùng thuộc tính disabled chuẩn của HTML thay vì class)
            btn.disabled = true;
        });
    </script>
</body>
</html>
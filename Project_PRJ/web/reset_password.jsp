<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Xác nhận OTP & Đổi Mật khẩu - PRJ Cinema</title>
    
    <style>
        /* --- 1. RESET & NỀN TỐI --- */
        body {
            background-color: #111827;
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            color: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            box-sizing: border-box;
            padding: 20px;
        }
        * { box-sizing: border-box; }
        a { text-decoration: none; }
        
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
        
        /* Tiêu đề */
        .auth-title {
            color: #3b82f6; 
            font-weight: bold;
            text-align: center;
            margin-top: 0;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 1.5rem;
        }
        
        /* --- 3. THÔNG BÁO LỖI / THÀNH CÔNG --- */
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .alert-success {
            background-color: rgba(16, 185, 129, 0.15);
            border: 1px solid #10b981;
            color: #34d399;
        }
        .alert-danger {
            background-color: rgba(239, 68, 68, 0.15);
            border: 1px solid #ef4444;
            color: #f87171;
        }
        .btn-close {
            background: transparent;
            border: none;
            font-size: 1.2rem;
            font-weight: bold;
            cursor: pointer;
            opacity: 0.8;
            color: inherit;
        }
        .btn-close:hover { opacity: 1; }
        
        /* --- 4. Ô NHẬP LIỆU (INPUTS) --- */
        .form-group {
            margin-bottom: 20px;
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
        
        /* Cấu trúc bọc Input để chứa nút Hiện/Ẩn mật khẩu */
        .input-wrapper {
            position: relative;
            width: 100%;
        }
        .input-wrapper input {
            padding-right: 60px; /* Chừa chỗ cho nút Hiện/Ẩn */
        }
        .btn-toggle-pass {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            color: #3b82f6;
            font-weight: bold;
            cursor: pointer;
            font-size: 0.9rem;
            transition: 0.3s;
        }
        .btn-toggle-pass:hover { color: #60a5fa; }
        
        /* --- 5. NÚT BẤM (BUTTON) --- */
        .btn-cinema {
            width: 100%;
            background-color: #3b82f6;
            color: white;
            border: none;
            font-weight: bold;
            padding: 14px;
            border-radius: 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }
        .btn-cinema:hover {
            background-color: #2563eb;
        }

        /* --- 6. LIÊN KẾT --- */
        .back-link-container {
            text-align: center;
            margin-top: 25px;
        }
        .back-link {
            color: #0ea5e9;
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
        <h3 class="auth-title">Xác thực OTP</h3>

        <c:if test="${not empty MESSAGE}">
            <div class="alert alert-success" id="successAlert">
                <span><strong>Thành công:</strong> ${MESSAGE}</span>
                <button type="button" class="btn-close" onclick="document.getElementById('successAlert').style.display='none'">X</button>
            </div>
        </c:if>

        <c:if test="${not empty ERROR}">
            <div class="alert alert-danger" id="errorAlert">
                <span><strong>Lỗi:</strong> ${ERROR}</span>
                <button type="button" class="btn-close" onclick="document.getElementById('errorAlert').style.display='none'">X</button>
            </div>
        </c:if>

        <form action="ForgotPasswordController" method="POST">
            <input type="hidden" name="action" value="verifyAndReset">
            
            <div class="form-group">
                <label class="form-label">Nhập mã OTP (6 số từ email):</label>
                <input type="text" name="otp" class="form-control" placeholder="Ví dụ: 123456" required autocomplete="off">
            </div>
            
            <div class="form-group">
                <label class="form-label">Nhập mật khẩu mới:</label>
                <div class="input-wrapper">
                    <input type="password" name="newPassword" id="newPass" class="form-control" placeholder="Mật khẩu từ 6 ký tự..." required>
                    <button type="button" class="btn-toggle-pass" id="togglePassword">Hiện</button>
                </div>
            </div>
            
            <button type="submit" class="btn-cinema">
                Xác nhận đổi mật khẩu
            </button>
        </form>
        
        <div class="back-link-container">
            <a href="login.jsp" class="back-link">
                &larr; Quay lại Đăng nhập
            </a>
        </div>
    </div>
    
    <script>
        const toggleBtn = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('newPass');

        toggleBtn.addEventListener('click', function () {
            // Kiểm tra type hiện tại
            const isPassword = passwordInput.getAttribute('type') === 'password';
            
            // Đổi type
            passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
            
            // Đổi chữ trên nút
            toggleBtn.textContent = isPassword ? 'Ẩn' : 'Hiện';
        });
    </script>
</body>
</html>
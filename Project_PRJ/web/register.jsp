<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Đăng ký tài khoản - PRJ Cinema</title>

        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #1b212c;
                --bg-card: rgba(40, 48, 61, 0.85); /* Kính mờ */
                --accent-blue: #0ea5e9;
                --accent-hover: #0284c7;
                --text-main: #ffffff;
                --text-muted: #cbd5e1;
            }
            * { box-sizing: border-box; margin: 0; padding: 0; }
            body {
                margin: 0;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                position: relative;
                padding: 20px; /* Thêm padding để tránh form chạm mép trên mobile */
                /* Background dự phòng khi chưa load ảnh */
                background: linear-gradient(rgba(27, 33, 44, 0.8), rgba(17, 24, 39, 0.9));
            }
            a { text-decoration: none; }

            /* --- 2. HIỆU ỨNG SLIDESHOW NỀN (GIỐNG LOGIN) --- */
            body::before {
                content: "";
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                z-index: -1;
                background-size: cover;
                background-position: center;
                filter: brightness(0.3) blur(2px);
                animation: syncSlideshow 20s infinite ease-in-out;
            }
            @keyframes syncSlideshow {
                0% { background-image: url('images/bg-login-1.jpg'); }
                33% { background-image: url('images/bg-login-2.jpg'); }
                66% { background-image: url('images/bg-login-3.jpg'); }
                100% { background-image: url('images/bg-login-1.jpg'); }
            }

            /* --- 3. KHUNG FORM KÍNH MỜ --- */
            .register-container {
                width: 100%;
                max-width: 450px;
                z-index: 10;
            }
            .logo-text {
                color: var(--accent-blue);
                font-weight: bold;
                font-size: 2rem;
                text-align: center;
                display: block;
                margin-bottom: 25px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .card {
                background-color: var(--bg-card);
                backdrop-filter: blur(10px);
                -webkit-backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.5);
                padding: 35px;
            }

            /* --- 4. TEXT & THÔNG BÁO --- */
            .text-center { text-align: center; }
            .text-muted { color: var(--text-muted); }
            .text-light { color: #fff; }
            .card-header h4 { color: #fff; margin-bottom: 5px; font-size: 1.4rem; }
            .card-header p { font-size: 0.9rem; margin-bottom: 20px; }

            .alert-danger {
                background-color: rgba(239, 68, 68, 0.2);
                border: 1px solid #ef4444;
                color: #fca5a5;
                padding: 10px 15px;
                border-radius: 6px;
                margin-bottom: 20px;
                font-size: 0.9rem;
                font-weight: bold;
            }

            /* --- 5. Ô NHẬP LIỆU (INPUTS) --- */
            .form-group { margin-bottom: 15px; }
            .form-label { display: block; color: #fff; margin-bottom: 8px; font-size: 0.9rem; font-weight: 500; }
            .form-control {
                width: 100%;
                background-color: rgba(21, 25, 32, 0.8);
                border: 1px solid #475569;
                color: #fff;
                padding: 10px 15px;
                border-radius: 6px;
                font-family: inherit;
                font-size: 0.95rem;
                outline: none;
                transition: 0.3s;
            }
            .form-control:focus {
                background-color: #151920;
                border-color: var(--accent-blue);
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
            }

            /* Bố cục 2 cột cho mật khẩu */
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }

            /* Checkbox */
            .checkbox-group {
                display: flex;
                align-items: center;
                margin-top: 10px;
                margin-bottom: 15px;
            }
            .form-check-input {
                width: 16px;
                height: 16px;
                margin-right: 8px;
                cursor: pointer;
                accent-color: var(--accent-blue);
            }
            .form-check-label { font-size: 0.85rem; cursor: pointer; }

            /* --- 6. NÚT BẤM & LINK --- */
            .btn-primary {
                width: 100%;
                background-color: var(--accent-blue);
                color: white;
                border: none;
                padding: 12px;
                border-radius: 6px;
                font-weight: bold;
                font-size: 1rem;
                cursor: pointer;
                transition: 0.3s;
                margin-top: 15px;
                margin-bottom: 20px;
            }
            .btn-primary:hover { background-color: var(--accent-hover); }

            .login-text { color: #fff; font-size: 0.9rem; margin-top: 10px; }
            .login-link {
                color: var(--accent-blue);
                font-weight: bold;
                transition: 0.3s;
            }
            .login-link:hover { color: #38bdf8; text-decoration: underline; }

            .back-home {
                color: var(--text-muted);
                font-size: 0.9rem;
                margin-top: 25px;
                display: inline-block;
                transition: 0.3s;
            }
            .back-home:hover { color: #fff; }

            /* Responsive: Trên ĐT, mật khẩu dồn thành 1 cột */
            @media (max-width: 480px) {
                .form-row { grid-template-columns: 1fr; gap: 0; }
            }
        </style>
    </head>
    <body>

        <div class="register-container">
            <a href="index.jsp" class="logo-text">PRJ CINEMA</a>

            <div class="card">
                <div class="card-header text-center">
                    <h4>Đăng ký tài khoản</h4>
                    <p class="text-muted">Tham gia để trải nghiệm điện ảnh tốt hơn</p>
                </div>

                <%-- Thông báo lỗi từ Servlet --%>
                <% if (msg != null && !msg.isEmpty()) {%>
                    <div class="alert-danger">
                        <%= msg%>
                    </div>
                <% }%>

                <form action="MainController" method="POST">
                    <input type="hidden" name="action" value="register"/>

                    <div class="form-group">
                        <label class="form-label">Tên đăng nhập (Username)</label>
                        <input type="text" name="username" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Họ và Tên</label>
                        <input type="text" name="fullName" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mật khẩu</label>
                            <input type="password" name="password" id="regPassword" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Xác nhận mật khẩu</label>
                            <input type="password" name="confirmPassword" id="regConfirmPassword" class="form-control" required>
                        </div>
                    </div>

                    <div class="checkbox-group">
                        <input type="checkbox" class="form-check-input" id="showRegPass" onclick="toggleRegPass()">
                        <label class="form-check-label text-muted" for="showRegPass">Hiển thị mật khẩu</label>
                    </div>

                    <div class="checkbox-group" style="margin-bottom: 25px;">
                        <input type="checkbox" class="form-check-input" id="terms" required>
                        <label class="form-check-label text-muted" for="terms">Tôi đồng ý với điều khoản sử dụng</label>
                    </div>

                    <button type="submit" class="btn-primary">TẠO TÀI KHOẢN</button>

                    <div class="text-center login-text">
                        Đã có tài khoản? <a href="login.jsp" class="login-link">Đăng nhập ngay</a>
                    </div>
                </form>
            </div>

            <div class="text-center">
                <a href="HomeController" class="back-home">&larr; Quay lại trang chủ</a>
            </div>
        </div>

        <script>
            function toggleRegPass() {
                var pass1 = document.getElementById("regPassword");
                var pass2 = document.getElementById("regConfirmPassword");

                if (pass1.type === "password") {
                    pass1.type = "text";
                    pass2.type = "text";
                } else {
                    pass1.type = "password";
                    pass2.type = "password";
                }
            }
        </script>
    </body>
</html>
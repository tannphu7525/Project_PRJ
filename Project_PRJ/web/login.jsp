<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.Cookie"%>
<%
    String savedUsername = "";
    boolean isRemembered = false;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("c_user".equals(cookie.getName())) {
                savedUsername = cookie.getValue();
                isRemembered = true;
                break;
            }
        }
    }
    String error = (String) request.getAttribute("error");
    String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Đăng nhập - PRJ Cinema</title>
        
        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #1b212c;
                --bg-card: rgba(40, 48, 61, 0.85); /* Kính mờ đồng bộ */
                --accent-blue: #0ea5e9;
                --accent-hover: #0284c7;
                --text-main: #ffffff;
                --text-muted: #cbd5e1;
            }
            * { box-sizing: border-box; margin: 0; padding: 0; }
            body {
                margin: 0;
                height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                overflow: hidden;
                position: relative;
                /* Background dự phòng khi chưa load ảnh */
                background: linear-gradient(rgba(27, 33, 44, 0.8), rgba(17, 24, 39, 0.9));
            }
            a { text-decoration: none; }

            /* --- 2. HIỆU ỨNG SLIDESHOW NỀN --- */
            body::before {
                content: "";
                position: absolute;
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

            /* --- 3. KHUNG FORM KÍNH MỜ (GLASSMORPHISM) --- */
            .login-container {
                width: 100%;
                max-width: 400px;
                z-index: 10;
                padding: 0 20px;
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
                -webkit-backdrop-filter: blur(10px); /* Cho Safari */
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.5);
                padding: 35px;
            }

            /* --- 4. TEXT & THÔNG BÁO --- */
            .text-center { text-align: center; }
            .text-muted { color: var(--text-muted); }
            .card-header h4 { color: #fff; margin-bottom: 5px; font-size: 1.4rem; }
            .card-header p { font-size: 0.9rem; margin-bottom: 20px; }

            .alert {
                padding: 12px 15px;
                border-radius: 6px;
                margin-bottom: 20px;
                font-size: 0.9rem;
                font-weight: bold;
            }
            .alert-danger { background-color: rgba(239, 68, 68, 0.2); border: 1px solid #ef4444; color: #fca5a5; }
            .alert-success { background-color: rgba(16, 185, 129, 0.2); border: 1px solid #10b981; color: #6ee7b7; }

            /* --- 5. Ô NHẬP LIỆU (INPUTS) --- */
            .form-group { margin-bottom: 20px; }
            .form-label { display: block; color: #fff; margin-bottom: 8px; font-size: 0.9rem; font-weight: 500; }
            .form-control {
                width: 100%;
                background-color: rgba(21, 25, 32, 0.8);
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
                background-color: #151920;
                border-color: var(--accent-blue);
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
            }
            .form-control::placeholder { color: #64748b; }

            /* Checkbox */
            .checkbox-group {
                display: flex;
                align-items: center;
                margin-top: 10px;
            }
            .form-check-input {
                width: 16px;
                height: 16px;
                margin-right: 8px;
                cursor: pointer;
                accent-color: var(--accent-blue);
            }
            .form-check-label { color: var(--text-muted); font-size: 0.85rem; cursor: pointer; }

            /* --- 6. NÚT BẤM & LINK LIÊN KẾT --- */
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
                margin-top: 10px;
                margin-bottom: 20px;
            }
            .btn-primary:hover { background-color: var(--accent-hover); }

            .link-muted { color: var(--text-muted); font-size: 0.85rem; transition: 0.3s; display: block; margin-bottom: 15px;}
            .link-muted:hover { color: #fff; }

            .register-text { color: #fff; font-size: 0.9rem; }
            .register-link {
                color: var(--accent-blue);
                font-weight: bold;
                transition: 0.3s;
            }
            .register-link:hover { color: #38bdf8; text-decoration: underline; }

            /* Nút Back ra ngoài khung */
            .back-home {
                color: var(--text-muted);
                font-size: 0.9rem;
                margin-top: 30px;
                display: inline-block;
                transition: 0.3s;
            }
            .back-home:hover { color: #fff; }

        </style>
    </head>
    <body>
        
        <div class="login-container">
            <a class="logo-text" href="HomeController">PRJ CINEMA</a>

            <div class="card">
                <div class="card-header text-center">
                    <h4>Chào mừng trở lại</h4>
                    <p class="text-muted">Vui lòng đăng nhập để tiếp tục</p>
                </div>

                <%-- HIỂN THỊ THÔNG BÁO LỖI --%>
                <% if (error != null && !error.isEmpty()) {%>
                    <div class="alert alert-danger">
                        <%= error%>
                    </div>
                <% }%>

                <%-- HIỂN THỊ THÔNG BÁO THÀNH CÔNG --%>
                <% 
                    String successMsg = (String) request.getAttribute("msg");
                    if (successMsg != null && !successMsg.isEmpty()) {
                %>
                    <div class="alert alert-success">
                        <%= successMsg%>
                    </div>
                <% }%>

                <form action="MainController" method="POST">
                    <input type="hidden" name="action" value="login"/>
                    
                    <div class="form-group">
                        <label class="form-label">Tên đăng nhập</label>
                        <input type="text" name="username" class="form-control" value="<%= savedUsername%>" required placeholder="Nhập username...">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Mật khẩu</label>
                        <input type="password" name="password" id="myPassword" class="form-control" required placeholder="Nhập mật khẩu...">
                        
                        <div class="checkbox-group">
                            <input class="form-check-input" type="checkbox" id="showPass" onclick="togglePass()">
                            <label class="form-check-label text-light" for="showPass">
                                Hiển thị mật khẩu
                            </label>
                        </div>
                    </div>
                    
                    <div class="form-group checkbox-group" style="margin-bottom: 25px;">
                        <input type="checkbox" name="remember" class="form-check-input" id="rem" value="ON" <%= isRemembered ? "checked" : ""%>>
                        <label class="form-check-label" for="rem">Ghi nhớ đăng nhập</label>
                    </div>
                    
                    <button type="submit" class="btn-primary">ĐĂNG NHẬP</button>

                    <div class="text-center">
                        <a href="forgot_password.jsp" class="link-muted">Quên mật khẩu?</a>
                    </div>

                    <div class="text-center register-text">
                        Chưa có tài khoản? 
                        <a href="register.jsp" class="register-link">Đăng ký ngay</a>
                    </div>
                </form>
            </div>
        </div>

        <div class="text-center">
            <a href="HomeController" class="back-home">&larr; Quay lại trang chủ</a>
        </div>

        <script>
            function togglePass() {
                var passInput = document.getElementById("myPassword");
                if (passInput.type === "password") {
                    passInput.type = "text";
                } else {
                    passInput.type = "password";
                }
            }
        </script>
    </body>
</html>
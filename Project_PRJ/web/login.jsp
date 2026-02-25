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
    String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập - PRJ Cinema</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-body: #1b212c;
            --bg-card: rgba(40, 48, 61, 0.85); /* Kính mờ đồng bộ */
            --accent-blue: #00d4ff;
            --text-main: #ffffff;
            --text-muted: #cbd5e1;
        }

        body { 
            margin: 0;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Roboto', sans-serif;
            overflow: hidden;
            position: relative;
             background: linear-gradient(rgba(27, 33, 44, 0.8), rgba(17, 24, 39, 0.9)),
                    url('https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=2059&auto=format&fit=crop') center/cover no-repeat;
        }

        /* Đồng bộ hiệu ứng Slideshow với trang Register */
        body::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
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

        .login-container { width: 100%; max-width: 400px; z-index: 10; }

        .card {
            background-color: var(--bg-card);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        h4, label, .form-label { color: #ffffff !important; }
        .text-muted, .form-check-label { color: var(--text-muted) !important; }

        .form-control {
            background-color: rgba(21, 25, 32, 0.8);
            border: 1px solid #475569;
            color: #ffffff !important;
        }
        .form-control:focus {
            background-color: #151920;
            color: #ffffff;
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 212, 255, 0.25);
        }

        .btn-primary {
            background-color: var(--accent-blue);
            border: none;
            color: #111827;
            font-weight: bold;
        }

        .logo-text { color: var(--accent-blue); font-weight: bold; font-size: 1.8rem; text-decoration: none; }
        
        /* Chỉnh lại link chuyển trang */
        .register-link { color: var(--accent-blue); text-decoration: none; font-weight: bold; }
        .register-link:hover { text-decoration: underline; }
        .text-center {
            color: white;
        }
    </style>
</head>
<body>

    <div class="login-container px-3">
        <div class="text-center mb-4">
            <a href="index.jsp" class="logo-text"><i class="fas fa-film me-2"></i>PRJ CINEMA</a>
        </div>

        <div class="card p-4">
            <div id="loginForm">
                <div class="text-center mb-4">
                    <h4>Chào mừng trở lại</h4>
                    <p class="text-muted small">Vui lòng đăng nhập để tiếp tục</p>
                </div>

                <% if (msg != null && !msg.isEmpty()) { %>
                    <div class="alert alert-danger py-2 small"><%= msg %></div>
                <% } %>

                <form action="MainController" method="POST">
                    <input type="hidden" name="action" value="login"/>
                    <div class="mb-3">
                        <label class="form-label small">Tên đăng nhập</label>
                        <input type="text" name="username" class="form-control" value="<%= savedUsername %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Mật khẩu</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" name="remember" class="form-check-input" id="rem" value="ON" <%= isRemembered ? "checked" : "" %>>
                        <label class="form-check-label small" for="rem">Ghi nhớ đăng nhập</label>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 py-2 mb-3">ĐĂNG NHẬP</button>
                    
                    <p class="text-center small">Chưa có tài khoản? 
                        <a href="register.jsp" class="register-link">Đăng ký ngay</a>
                    </p>
                </form>
            </div>
        </div>
        
        <div class="text-center mt-4">
            <a href="index.jsp" class="text-muted small text-decoration-none"><i class="fas fa-arrow-left me-2"></i>Quay lại trang chủ</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
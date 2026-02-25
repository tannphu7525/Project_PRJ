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
            --bg-card: #28303d;
            --accent-blue: #00d4ff;
            --text-main: #ffffff;
            --text-muted: #cbd5e1;
        }

        body { 
             background: linear-gradient(rgba(27, 33, 44, 0.8), rgba(17, 24, 39, 0.9)),
                    url('https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=2059&auto=format&fit=crop') center/cover no-repeat; 
            color: var(--text-main);
            font-family: 'Roboto', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        .login-container { width: 100%; max-width: 400px; }

        .card {
            background-color: var(--bg-card);
            border: 1px solid #334155;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        h4, label, .form-label { color: #ffffff !important; }
        .text-muted, .form-check-label { color: var(--text-muted) !important; }

        .form-control {
            background-color: #151920;
            border: 1px solid #475569;
            color: #ffffff !important;
        }
        .form-control:focus {
            background-color: #151920;
            color: #ffffff;
            border-color: var(--accent-blue);
        }

        .btn-primary {
            background-color: var(--accent-blue);
            border: none;
            color: #111827;
            font-weight: bold;
        }

        .logo-text { color: var(--accent-blue); font-weight: bold; font-size: 1.8rem; text-decoration: none; }
        .toggle-link { color: var(--accent-blue); cursor: pointer; text-decoration: none; }

        /* QUAN TRỌNG: Mặc định ẩn form đăng ký để không bị nhân đôi */
        #registerForm { display: none; }
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
                    <h4>Welcome</h4>
                    <p class="text-muted small">Please Login or Sign up</p>
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
                    <p class="text-center small">Chưa có tài khoản? <span class="toggle-link" onclick="toggleForm()">Đăng ký ngay</span></p>
                </form>
            </div>

            <div id="registerForm">
                <div class="text-center mb-4">
                    <h4>Tạo tài khoản</h4>
                    <p class="text-muted small">Đăng ký thành viên mới</p>
                </div>
                <form action="MainController" method="POST">
                    <input type="hidden" name="action" value="register"/>
                    <div class="mb-3">
                        <label class="form-label small">Username</label>
                        <input type="text" name="username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Password</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Re-password</label>
                        <input type="password" name="re-password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 py-2 mb-3">ĐĂNG KÝ</button>
                    <p class="text-center small">Đã có tài khoản? <span class="toggle-link" onclick="toggleForm()">Quay lại đăng nhập</span></p>
                </form>
            </div>
        </div>
        
        <div class="text-center mt-4">
            <a href="index.jsp" class="text-muted small text-decoration-none"><i class="fas fa-arrow-left me-2"></i>Quay lại trang chủ</a>
        </div>
    </div>

    <script>
        function toggleForm() {
            const login = document.getElementById('loginForm');
            const register = document.getElementById('registerForm');
            if (login.style.display === "none") {
                login.style.display = "block";
                register.style.display = "none";
            } else {
                login.style.display = "none";
                register.style.display = "block";
            }
        }
    </script>
</body>
</html>
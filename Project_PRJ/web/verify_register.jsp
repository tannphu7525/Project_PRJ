<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("ERROR");
    String message = (String) request.getAttribute("MESSAGE");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Xác thực đăng ký - PRJ Cinema</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --bg-body: #1b212c;
                --bg-card: rgba(40, 48, 61, 0.85);
                --accent-blue: #00d4ff;
                --text-main: #ffffff;
                --text-muted: #cbd5e1;
            }
            body {
                margin: 0; height: 100vh; display: flex; align-items: center; justify-content: center;
                font-family: 'Roboto', sans-serif; overflow: hidden; position: relative;
                background: linear-gradient(rgba(27, 33, 44, 0.8), rgba(17, 24, 39, 0.9)),
                    url('https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=2059&auto=format&fit=crop') center/cover no-repeat;
            }
            body::before {
                content: ""; position: absolute; top: 0; left: 0; right: 0; bottom: 0; z-index: -1;
                background-size: cover; background-position: center; filter: brightness(0.3) blur(2px);
            }
            .auth-container { width: 100%; max-width: 450px; z-index: 10; }
            .card {
                background-color: var(--bg-card); backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.5); padding: 30px;
            }
            h4, label, .form-label, p { color: #ffffff !important; }
            .text-muted { color: var(--text-muted) !important; }
            .form-control {
                background-color: rgba(21, 25, 32, 0.8); border: 1px solid #475569; color: #ffffff !important;
                text-align: center; letter-spacing: 5px; font-size: 20px; font-weight: bold;
            }
            .form-control:focus {
                background-color: #151920; border-color: var(--accent-blue);
                box-shadow: 0 0 0 0.25rem rgba(0, 212, 255, 0.25);
            }
            .btn-primary {
                background-color: var(--accent-blue); border: none; color: #111827; font-weight: bold; transition: 0.3s;
            }
            .btn-primary:hover { background-color: #00b8e6; transform: scale(1.02); }
        </style>
    </head>
    <body>
        <div class="auth-container px-3">
            <div class="card p-4">
                <div class="text-center mb-4">
                    <h4>Xác thực Email</h4>
                    <p class="text-muted small">Vui lòng nhập mã OTP vừa được gửi đến email của bạn.</p>
                </div>

                <% if (message != null) { %>
                <div class="alert alert-info py-2 small text-center"><%= message %></div>
                <% } %>
                
                <% if (error != null) { %>
                <div class="alert alert-danger py-2 small text-center"><%= error %></div>
                <% } %>

                <form action="MainController" method="POST">
                    <input type="hidden" name="action" value="verifyRegisterOTP"/>
                    
                    <div class="mb-4">
                        <label class="form-label small">Mã OTP (6 số)</label>
                        <input type="text" name="otp" class="form-control" maxlength="6" required autocomplete="off">
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2">XÁC NHẬN</button>
                </form>
            </div>
            <div class="text-center mt-4">
                <a href="register.jsp" class="text-muted small text-decoration-none"><i class="fas fa-arrow-left me-2"></i>Quay lại Đăng ký</a>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
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
        
        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #1b212c;
                --bg-card: rgba(40, 48, 61, 0.85);
                --accent-blue: #0ea5e9;
                --accent-hover: #0284c7;
                --text-main: #ffffff;
                --text-muted: #cbd5e1;
            }
            * { box-sizing: border-box; margin: 0; padding: 0; }
            body {
                margin: 0; height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; overflow: hidden; position: relative;
                /* Background dự phòng */
                background: linear-gradient(rgba(27, 33, 44, 0.8), rgba(17, 24, 39, 0.9));
            }

            /* --- 2. HIỆU ỨNG NỀN (ĐỒNG BỘ LOGIN/REGISTER) --- */
            body::before {
                content: ""; position: absolute; top: 0; left: 0; right: 0; bottom: 0; z-index: -1;
                background-image: url('https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=2059&auto=format&fit=crop');
                background-size: cover; background-position: center; filter: brightness(0.2) blur(3px);
            }

            /* --- 3. KHUNG FORM KÍNH MỜ --- */
            .auth-container { width: 100%; max-width: 450px; z-index: 10; padding: 0 20px; }
            
            .card {
                background-color: var(--bg-card);
                backdrop-filter: blur(10px);
                -webkit-backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.5);
                padding: 40px;
            }

            .text-center { text-align: center; }
            h4 { color: #ffffff; margin-bottom: 10px; font-size: 1.5rem; font-weight: bold; }
            .subtitle { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 30px; line-height: 1.5; }

            /* --- 4. THÔNG BÁO --- */
            .alert {
                padding: 12px;
                border-radius: 6px;
                margin-bottom: 20px;
                font-size: 0.85rem;
                font-weight: bold;
            }
            .alert-info { background-color: rgba(14, 165, 233, 0.2); border: 1px solid var(--accent-blue); color: #7dd3fc; }
            .alert-danger { background-color: rgba(239, 68, 68, 0.2); border: 1px solid #ef4444; color: #fca5a5; }

            /* --- 5. Ô NHẬP LIỆU OTP --- */
            .form-group { margin-bottom: 25px; }
            .form-label { display: block; color: #ffffff; margin-bottom: 10px; font-size: 0.9rem; font-weight: 500; }
            
            .form-control {
                width: 100%;
                background-color: rgba(21, 25, 32, 0.8);
                border: 1px solid #475569;
                color: #ffffff;
                text-align: center;
                letter-spacing: 8px; /* Tạo khoảng cách giữa các số OTP */
                font-size: 24px;
                font-weight: bold;
                padding: 12px;
                border-radius: 8px;
                outline: none;
                transition: 0.3s;
                font-family: monospace; /* Dùng font đơn cách cho số đẹp hơn */
            }
            .form-control:focus {
                border-color: var(--accent-blue);
                background-color: #151920;
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
            }

            /* --- 6. NÚT BẤM --- */
            .btn-primary {
                width: 100%;
                background-color: var(--accent-blue);
                color: #111827;
                border: none;
                padding: 14px;
                border-radius: 8px;
                font-weight: bold;
                font-size: 1rem;
                cursor: pointer;
                transition: 0.3s;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .btn-primary:hover {
                background-color: var(--accent-hover);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(14, 165, 233, 0.4);
            }

            /* --- 7. LINK QUAY LẠI --- */
            .back-link {
                display: inline-block;
                margin-top: 25px;
                color: var(--text-muted);
                text-decoration: none;
                font-size: 0.9rem;
                transition: 0.3s;
            }
            .back-link:hover { color: #ffffff; }
        </style>
    </head>
    <body>
        <div class="auth-container">
            <div class="card">
                <div class="text-center">
                    <h4>Xác thực Email</h4>
                    <p class="subtitle">Vui lòng nhập mã OTP vừa được gửi đến email của bạn để hoàn tất đăng ký.</p>
                </div>

                <% if (message != null) { %>
                    <div class="alert alert-info text-center"><%= message %></div>
                <% } %>
                
                <% if (error != null) { %>
                    <div class="alert alert-danger text-center"><%= error %></div>
                <% } %>

                <form action="MainController" method="POST">
                    <input type="hidden" name="action" value="verifyRegisterOTP"/>
                    
                    <div class="form-group text-center">
                        <label class="form-label">Mã OTP (6 số)</label>
                        <input type="text" name="otp" class="form-control" maxlength="6" required autocomplete="off" placeholder="******">
                    </div>

                    <button type="submit" class="btn-primary">XÁC NHẬN TÀI KHOẢN</button>
                </form>
            </div>

            <div class="text-center">
                <a href="register.jsp" class="back-link">&larr; Quay lại Đăng ký</a>
            </div>
        </div>
    </body>
</html>
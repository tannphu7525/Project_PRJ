<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quên mật khẩu</title>
</head>
<body>
    <h2 style="color: #E50914;">Quên Mật Khẩu</h2>
    <p style="color: red;">${ERROR}</p>
    <form action="ForgotPasswordController" method="POST">
        <input type="hidden" name="action" value="sendOTP">
        Nhập Email của bạn: <input type="email" name="email" required>
        <button type="submit">Gửi mã OTP</button>
    </form>
</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Xác nhận OTP & Đổi Mật khẩu</title>
</head>
<body>
    <h2 style="color: #E50914;">Xác thực OTP</h2>
    <p style="color: green;">${MESSAGE}</p>
    <p style="color: red;">${ERROR}</p> 

    <form action="ForgotPasswordController" method="POST">
        <input type="hidden" name="action" value="verifyAndReset">
        
        Nhập mã OTP (6 số từ email): <br>
        <input type="text" name="otp" required><br><br>
        
        Nhập Mật khẩu mới: <br>
        <input type="password" name="newPassword" required><br><br>
        
        <button type="submit">Xác nhận đổi mật khẩu</button>
    </form>
</body>
</html>
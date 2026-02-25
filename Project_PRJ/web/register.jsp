<%-- 
    Document   : register
    Created on : Feb 25, 2026, 10:36:36 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng ký tài khoản</title>
        <%
            String msg = (String) request.getAttribute("msg");
        %>
    </head>
    <body>
        <h2>Đăng Ký Tài Khoản Mới</h2>
        <% if (msg != null && !msg.isEmpty()) {%>
        <p style="color: red;"><%= msg%></p>
        <% }%>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="register"/>

            <label>Username:</label>
            <input type="text" name="username" required/><br/>

            <label>Họ và Tên:</label>
            <input type="text" name="fullName" required/><br/>

            <label>Password:</label>
            <input type="password" name="password" required/><br/>

            <label>Nhập lại Password:</label>
            <input type="password" name="confirmPassword" required/><br/>

            <input type="submit" value="TẠO TÀI KHOẢN"/>
        </form>
        <br>
        <a href="login.jsp">Quay lại trang Đăng nhập</a>        
    </body>
</html>

<%-- 
    Document   : login.jsp
    Created on : Feb 25, 2026, 10:16:08 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.Cookie"%>
<%
    // Đọc cookie c_user để pre-fill username nếu user đã tích Remember Me
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

    // Đọc thông báo lỗi nếu có
    String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng nhập</title>
    </head>
    <body>
        <h2>Đăng nhập hoặc Đăng kí</h2>

        <%-- Hiển thị thông báo lỗi nếu có --%>
        <% if (msg != null && !msg.isEmpty()) {%>
        <p style="color: red;"><%= msg%></p>
        <% }%>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="login"/>

            <label>Username:</label>
            <input type="text" name="username" value="<%= savedUsername%>" required/><br/>

            <label>Password:</label>
            <input type="password" name="password" value="" required/><br/>

            <label>Ghi nhớ đăng nhập</label>
            <input type="checkbox" name="remember" value="ON" <%= isRemembered ? "checked" : ""%>/><br/>

            <input type="submit" value="ĐĂNG NHẬP"/> 
        </form>

    <a href="register.jsp"><button type="button">ĐĂNG KÝ</button></a>  
    </body>
</html>

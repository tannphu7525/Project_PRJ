<%-- 
    Document   : login
    Created on : Feb 24, 2026, 4:08:30 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="login"/>
            Username: <input type="text" name="username" value="" required/> <br/>
            Password: <input type="password" name="password" value="" required/> <br/>
            
            Remember <input type="checkbox" name="remember" value="ON" /> <br/>
            
            <input type="submit" value="LOGIN"/>
        </form>
    </body>
</html>

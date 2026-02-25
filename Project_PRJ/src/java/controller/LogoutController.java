package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LogoutController", urlPatterns = { "/LogoutController" })
public class LogoutController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        Cookie logoutCookie = new Cookie("c_user", "");
        logoutCookie.setMaxAge(0);
        logoutCookie.setHttpOnly(true); 
        logoutCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        response.addCookie(logoutCookie);

        // 3. Redirect về trang đăng nhập (dùng sendRedirect để ngăn back button)
        response.sendRedirect(request.getContextPath() + "/" + LOGIN_PAGE);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST logout cũng được xử lý giống GET
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Logout Controller";
    }
}

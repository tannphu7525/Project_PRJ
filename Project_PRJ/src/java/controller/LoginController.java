package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDAO;
import model.UserDTO;

@WebServlet(name = "LoginController", urlPatterns = { "/LoginController" })
public class LoginController extends HttpServlet {

    private static final String ERROR_PAGE = "error.jsp";
    private static final String ADMIN_PAGE = "admin.jsp";
    private static final String USER_PAGE = "index.jsp";
    private static final String LOGIN_PAGE = "login.jsp";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String txtUsername = request.getParameter("username");
        String txtPassword = request.getParameter("password");
        String checkRemember = request.getParameter("remember"); 

        String url = ERROR_PAGE;
        String msg = "";

        // 1. Validate input
        if (txtUsername == null || txtUsername.trim().isEmpty()
                || txtPassword == null || txtPassword.trim().isEmpty()) {
            msg = "Vui lòng nhập đầy đủ thông tin Username và Password";
            request.setAttribute("msg", msg);

        } else {
            UserDAO udao = new UserDAO();
            UserDTO user = udao.login(txtUsername, txtPassword);

            if (user == null) {
                // 2. Sai username hoặc password
                msg = "Username hoặc Password không đúng";
                request.setAttribute("msg", msg);

            } else if (!user.isStatus()) {
                // 3. Tài khoản bị khóa
                msg = "Tài khoản bị khóa, vui lòng liên hệ quản trị viên";
                request.setAttribute("msg", msg);

            } else {
                // 4. Đăng nhập thành công

                // --- Session ---
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                Cookie userCookie = new Cookie("c_user", txtUsername);
                userCookie.setHttpOnly(true); // Chống XSS: JS không đọc được cookie
                // userCookie.setSecure(true); // Bật khi deploy lên HTTPS

                if ("ON".equals(checkRemember)) {
                    userCookie.setMaxAge(60 * 60 * 24 * 7);
                } else {
                    userCookie.setMaxAge(0);
                }
                response.addCookie(userCookie);

                if ("admin".equalsIgnoreCase(user.getRole())) {
                    url = ADMIN_PAGE;
                } else {
                    url = USER_PAGE;
                }
            }
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Login chỉ xử lý qua POST, GET redirect về trang login
        response.sendRedirect(request.getContextPath() + "/" + LOGIN_PAGE);
    }

    @Override
    public String getServletInfo() {
        return "Login Controller";
    }
}

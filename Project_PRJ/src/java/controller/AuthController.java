/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.MovieDAO;
import model.MovieDTO;
import model.UserDAO;
import model.UserDTO;

/**
 *
 * @author Cuong
 */
public class AuthController extends HttpServlet {

    private static final String ERROR_PAGE = "error.jsp";
    private static final String ADMIN_PAGE = "admin.jsp";
    private static final String USER_PAGE = "welcome.jsp";
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String SUCCESS_PAGE = "login.jsp";
    private static final String ERRORREGISTER_PAGE = "register.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            doLogin(request, response);
            return;
        }

        try {
            switch (action) {
                case "login":
                    doLogin(request, response);
                    break;

                case "logout":
                    doLogOut(request, response);
                    break;
                case "register":
                    doRegister(request, response);
                    break;

                default:
                    request.setAttribute("error", "Hành động không hợp lệ: " + action);
                    doLogin(request, response);
                    break;
            }
        } catch (Exception e) {
            log("Error at UserController: " + e.toString());
            request.setAttribute("error", "Hệ thống đang gặp sự cố, vui lòng thử lại sau.");
            request.getRequestDispatcher("error.jsp").forward(request, response);

        }
    }

    protected void doLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String txtUsername = request.getParameter("username");
        String txtPassword = request.getParameter("password");
        String checkRemember = request.getParameter("remember");

        String url = LOGIN_PAGE; // Mặc định quay lại trang login nếu lỗi
        String msg = "";

        // 1. Validate input
        if (txtUsername == null || txtUsername.trim().isEmpty()
                || txtPassword == null || txtPassword.trim().isEmpty()) {
            msg = "Vui lòng nhập đầy đủ thông tin Username và Password";
            request.setAttribute("error", msg);

        } else {
            UserDAO udao = new UserDAO();
            UserDTO user = udao.login(txtUsername, txtPassword);

            if (user == null) {
                msg = "Username hoặc Password không đúng";
                request.setAttribute("error", msg);
            } else if (!user.isStatus()) {
                // 3. Tài khoản bị khóa
                msg = "Tài khoản bị khóa, vui lòng liên hệ quản trị viên";
                request.setAttribute("error", msg);

            } else {
                // 4. Đăng nhập thành công
                // --- Session ---
                HttpSession session = request.getSession();
                session.setAttribute("LOGIN_USER", user);
                // --- Cookie (Remember me) ---
                Cookie userCookie = new Cookie("c_user", txtUsername);
                userCookie.setHttpOnly(true);
                if ("ON".equals(checkRemember)) {
                    userCookie.setMaxAge(60 * 60 * 24 * 7);
                } else {
                    userCookie.setMaxAge(0);
                }
                response.addCookie(userCookie);

                // --- Phân quyền & Lấy dữ liệu ---
                // Giả sử RoleID của admin là "AD" và user là "US"
                if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                    // Redirect thẳng lên MainController để tải list, không dùng forward
                    response.sendRedirect(
                            request.getContextPath() + "/MainController?action=adminMovie&subAction=list");
                    return;
                } else {
                    MovieDAO mDao = new MovieDAO();
                    ArrayList<MovieDTO> list = mDao.getAllMovie();
                    request.setAttribute("LIST_MOVIE", list);
                    url = USER_PAGE;
                }
            }
        }
        request.getRequestDispatcher(url).forward(request, response);
    }

    protected void doLogOut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // 2. Xóa Cookie
        Cookie logoutCookie = new Cookie("c_user", "");
        logoutCookie.setMaxAge(0);
        logoutCookie.setHttpOnly(true);
        logoutCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        response.addCookie(logoutCookie);

        response.sendRedirect(request.getContextPath() + "/" + LOGIN_PAGE);
    }

    protected void doRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String confirmpassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");

        String url = ERRORREGISTER_PAGE;
        String msg = "";

        try {
            if (!password.equals(confirmpassword)) {
                msg = "Mật khẩu không trùng khớp!";
                request.setAttribute("msg", msg);
            } else {
                UserDAO dao = new UserDAO();
                if (dao.checkDuplicateUsername(username)) {
                    msg = "Username này đã được sử dụng. Vui lòng chọn Username khác";
                    request.setAttribute("msg", msg);
                } else if (dao.checkDuplicateEmail(email)) {
                    msg = "Email này đã được sử dụng để đăng ký tài khoản khác!";
                    request.setAttribute("msg", msg);
                } else {
                    UserDTO newUser = new UserDTO(0, username, password, fullName, "CUSTOMER", true, email);
                    boolean isSuccess = dao.registerUser(newUser);

                    if (isSuccess) {
                        // 1. Luồng chính: Báo thành công và chuyển ngay lập tức sang trang Login
                        msg = "Đăng ký thành công! Vui lòng kiểm tra hộp thư Email của bạn.";
                        request.setAttribute("msg", msg); // Trang login dùng biến "error" để hiển thị msg
                        url = SUCCESS_PAGE; // (login.jsp)

                        // 2. Luồng phụ (Async Thread): Gọi EmailService chạy ngầm
                        final String toEmail = email;
                        final String toName = fullName;

                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                // Gọi hàm gửi mail từ class EmailService mà bạn đã viết hôm qua
                                util.EmailService.sendWelcomeEmail(toEmail, toName);
                            }
                        }).start();

                    } else {
                        msg = "Có lỗi xảy ra trong quá trình ghi dữ liệu. Vui lòng thử lại.";
                        request.setAttribute("msg", msg);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}

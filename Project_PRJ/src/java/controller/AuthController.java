/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.MovieDAO;
import model.MovieDTO;
import model.UserDAO;
import model.UserDTO;
import util.EmailService;

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
                case "verifyRegisterOTP":
                    doVerifyRegisterOTP(request, response);
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
                request.getRequestDispatcher(url).forward(request, response);
                return;
            }

            UserDAO dao = new UserDAO();
            if (dao.checkDuplicateUsername(username)) {
                msg = "Username này đã được sử dụng. Vui lòng chọn Username khác";
                request.setAttribute("msg", msg);
                request.getRequestDispatcher(url).forward(request, response);
            } else if (dao.checkEmailExist(email)) {
                msg = "Email này đã được sử dụng để đăng ký tài khoản khác!";
                request.setAttribute("msg", msg);
                request.getRequestDispatcher(url).forward(request, response);
            } else {
                // 1. Nếu thông tin hợp lệ, tạo đối tượng User chờ duyệt
                UserDTO pendingUser = new UserDTO(0, username, password, fullName, "CUSTOMER", true, email);

                // 2. Tạo mã OTP 6 số
                SecureRandom random = new SecureRandom();
                int otpCode = 100000 + random.nextInt(900000); // Đảm bảo luôn ra 6 số

                // 3. Lưu vào Session (Chờ xác thực mới lưu DB)
                HttpSession session = request.getSession();
                session.setAttribute("PENDING_USER", pendingUser);
                session.setAttribute("REGISTER_OTP", otpCode);
                session.setAttribute("REGISTER_OTP_EXPIRY", System.currentTimeMillis() + (3 * 60 * 1000)); // Hạn 3 phút

                // 4. Gửi mail OTP chạy ngầm (Async Thread)
                new Thread(() -> {
                    EmailService.sendOTPEmailRegister(email, otpCode);
                }).start();

                // 5. Chuyển hướng tới trang nhập OTP
                request.setAttribute("MESSAGE", "Mã OTP đã được gửi đến email " + email + " của bạn.");
                request.getRequestDispatcher("verify_register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Có lỗi xảy ra, vui lòng thử lại sau.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    //Kiểm tra OTP đăng kí 
    protected void doVerifyRegisterOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inputOTP = request.getParameter("otp");
        HttpSession session = request.getSession();

        UserDTO pendingUser = (UserDTO) session.getAttribute("PENDING_USER");
        Object otpObj = session.getAttribute("REGISTER_OTP");
        Long expiryTime = (Long) session.getAttribute("REGISTER_OTP_EXPIRY");

        if (pendingUser == null || otpObj == null || expiryTime == null) {
            request.setAttribute("msg", "Phiên giao dịch đã hết hạn hoặc không hợp lệ. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > expiryTime) {
            request.setAttribute("ERROR", "Mã OTP đã hết hạn (quá 3 phút). Vui lòng đăng ký lại!");
            request.getRequestDispatcher("verify_register.jsp").forward(request, response);
            return;
        }

        String sessionOTP = String.valueOf(otpObj);
        if (!sessionOTP.equals(inputOTP)) {
            request.setAttribute("ERROR", "Mã OTP không chính xác!");
            request.getRequestDispatcher("verify_register.jsp").forward(request, response);
            return;
        }

        // OTP Hợp lệ -> Tiến hành lưu User vào Database
        UserDAO dao = new UserDAO();
        boolean isSuccess = dao.registerUser(pendingUser);

        if (isSuccess) {
            // Xóa rác trong session
            session.removeAttribute("PENDING_USER");
            session.removeAttribute("REGISTER_OTP");
            session.removeAttribute("REGISTER_OTP_EXPIRY");

            // Gửi Welcome Email chạy ngầm
            final String toEmail = pendingUser.getEmail();
            final String toName = pendingUser.getFullName();
            new Thread(() -> {
                EmailService.sendWelcomeEmail(toEmail, toName);
            }).start();

            // Chuyển sang trang Login
            request.setAttribute("msg", "Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("ERROR", "Có lỗi xảy ra trong quá trình ghi dữ liệu. Vui lòng thử lại.");
            request.getRequestDispatcher("verify_register.jsp").forward(request, response);
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

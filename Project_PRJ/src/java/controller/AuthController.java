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
@WebServlet(name = "AuthController", urlPatterns = {"/AuthController"})
public class AuthController extends HttpServlet {

    private static final String ERROR_PAGE = "error.jsp"; // Hoặc login.jsp để báo lỗi tại chỗ
    private static final String ADMIN_PAGE = "admin.jsp";
    private static final String USER_PAGE = "welcome.jsp";
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String SUCCESS_PAGE = "login.jsp";
    private static final String ERRORREGISTER_PAGE = "register.jsp";

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String txtUsername = request.getParameter("username");
        String txtPassword = request.getParameter("password");
        String checkRemember = request.getParameter("remember");

        String url = LOGIN_PAGE; // Mặc định quay lại trang login nếu lỗi
        String msg = "";

        // 1. Validate input
        if (txtUsername == null || txtUsername.trim().isEmpty()
                || txtPassword == null || txtPassword.trim().isEmpty()) {
            msg = "Vui lòng nhập đầy đủ thông tin Username và Password";
            request.setAttribute("error", msg); // Đổi tên attribute thành 'error' hoặc 'msg' tùy trang login của bạn

        } else {
            UserDAO udao = new UserDAO();
            // Hàm login này trả về UserDTO chứa cả RoleID và FullName nhé
            UserDTO user = udao.login(txtUsername, txtPassword);

            if (user == null) {
                // 2. Sai username hoặc password
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
                // QUAN TRỌNG: Sửa tên key thành "LOGIN_USER" để khớp với welcome.jsp
                session.setAttribute("LOGIN_USER", user);

                // --- Cookie (Remember me) ---
                Cookie userCookie = new Cookie("c_user", txtUsername);
                userCookie.setHttpOnly(true);

                if ("ON".equals(checkRemember)) {
                    userCookie.setMaxAge(60 * 60 * 24 * 7); // Nhớ 7 ngày
                } else {
                    userCookie.setMaxAge(0); // Xóa cookie nếu không tích
                }
                response.addCookie(userCookie);

                // --- Phân quyền & Lấy dữ liệu ---
                // Giả sử RoleID của admin là "AD" và user là "US"
                if ("AD".equals(user.getRole())) {
                    // Nếu là Admin, nên Redirect sang AdminController để tải danh sách quản lý
                    // url = "AdminMovieController?subAction=list"; // Khuyên dùng dòng này
                    // Nhưng nếu bạn muốn forward thẳng:
                    MovieDAO mDao = new MovieDAO();
                    ArrayList<MovieDTO> list = mDao.getAllMovie();
                    request.setAttribute("ADMIN_MOVIE_LIST", list);
                    url = ADMIN_PAGE;

                } else {
                    // Nếu là User, tải danh sách phim để hiện ở welcome.jsp
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. Hủy Session hiện tại (false: chỉ lấy session đang có, không tạo mới)
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Hủy bỏ toàn bộ nội dung session
        }

        // 2. Xóa Cookie (BẮT BUỘC phải làm TRƯỚC khi gọi sendRedirect)
        Cookie logoutCookie = new Cookie("c_user", "");
        logoutCookie.setMaxAge(0); // Set time = 0 để trình duyệt tự xóa
        logoutCookie.setHttpOnly(true);
        logoutCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        response.addCookie(logoutCookie);

        // 3. Redirect về trang đăng nhập (Chỉ gọi sendRedirect 1 lần duy nhất ở cuối cùng)
        response.sendRedirect(request.getContextPath() + "/" + LOGIN_PAGE);

    }

    protected void doRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

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
                        msg = "Đăng ký thành công! Vui lòng đăng nhập.";
                        request.setAttribute("msg", msg);
                        url = SUCCESS_PAGE;
                    } else {
                        msg = "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại.";
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

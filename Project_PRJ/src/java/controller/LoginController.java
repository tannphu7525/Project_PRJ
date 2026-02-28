package controller;

import java.io.IOException;
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

@WebServlet(name = "LoginController", urlPatterns = { "/LoginController" })
public class LoginController extends HttpServlet {

    private static final String ERROR_PAGE = "error.jsp"; // Hoặc login.jsp để báo lỗi tại chỗ
    private static final String ADMIN_PAGE = "admin.jsp";
    private static final String USER_PAGE = "welcome.jsp";
    private static final String LOGIN_PAGE = "login.jsp";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
                    
                    // QUAN TRỌNG: Đặt tên attribute là "LIST_MOVIE" để khớp với welcome.jsp
                    request.setAttribute("LIST_MOVIE", list);
                    
                    url = USER_PAGE;
                }
            }
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
    }
}
package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDTO;

/**
 * AdminFilter: Bảo vệ AdminController.
 * - Nếu chưa đăng nhập → redirect về trang Login.
 * - Nếu đã đăng nhập nhưng Role không phải ADMIN → redirect về trang Home
 * (403).
 * - Nếu đúng là ADMIN → cho đi qua.
 */
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false); // Không tạo session mới

        boolean isLoggedIn = false;
        boolean isAdmin = false;

        if (session != null) {
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
            if (loginUser != null) {
                isLoggedIn = true;
                if ("ADMIN".equalsIgnoreCase(loginUser.getRole())) {
                    isAdmin = true;
                }
            }
        }

        String contextPath = req.getContextPath();

        if (!isLoggedIn) {
            // Chưa đăng nhập → về trang login
            res.sendRedirect(contextPath + "/index.jsp");
        } else if (!isAdmin) {
            // Đã đăng nhập nhưng không phải admin → về trang chủ
            res.sendRedirect(contextPath + "/HomeController");
        } else {
            // Là Admin → cho đi qua
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
    }
}

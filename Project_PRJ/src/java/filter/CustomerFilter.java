package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDTO;

/**
 * CustomerFilter: Bảo vệ các trang dành riêng cho người dùng đã đăng nhập.
 * - Nếu chưa đăng nhập → redirect về trang Login.
 * - Nếu đã đăng nhập (bất kể role gì) → cho đi qua.
 *
 * Thêm các trang cần bảo vệ vào urlPatterns bên dưới.
 */
@WebFilter(filterName = "CustomerFilter", urlPatterns = {"/history.jsp", "/seat_map.jsp"})
public class CustomerFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean isLoggedIn = false;

        if (session != null) {
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
            if (loginUser != null) {
                isLoggedIn = true;
            }
        }

        if (!isLoggedIn) {
            // Chưa đăng nhập → về trang login
            res.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            // Đã đăng nhập → cho đi qua
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
    }
}

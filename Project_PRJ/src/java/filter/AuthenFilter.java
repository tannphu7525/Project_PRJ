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
 * AuthenFilter: Bảo vệ trang Login / Register. - Nếu user ĐÃ đăng nhập mà còn
 * vào trang Login → redirect về Home. - Nếu chưa đăng nhập → cho đi qua bình
 * thường.
 *
 * URL patterns: /index.jsp, /login.jsp, /AuthController (action=login,
 * register)
 */
public class AuthenFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false); // Lấy session hiện tại

        // Kiểm tra xem User đã đăng nhập chưa 
        if (session != null && session.getAttribute("LOGIN_USER") != null) {
            res.sendRedirect(req.getContextPath() + "/HomeController");
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
    }
}

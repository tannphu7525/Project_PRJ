package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;

/**
 * EncodingFilter: Áp dụng mã hóa UTF-8 cho TẤT CẢ request và response.
 * Dùng chung thay thế cho các dòng:
 * request.setCharacterEncoding("UTF-8");
 * response.setCharacterEncoding("UTF-8");
 * response.setContentType("text/html;charset=UTF-8");
 * trong từng Controller.
 */
@WebFilter(filterName = "EncodingFilter", urlPatterns = { "/*" })
public class EncodingFilter implements Filter {

    private static final String ENCODING = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Áp dụng encoding UTF-8 trước khi xử lý request
        request.setCharacterEncoding(ENCODING);
        response.setCharacterEncoding(ENCODING);

        // Cho request đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

package controller;

import java.io.IOException;
import java.security.SecureRandom;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDAO;
import util.EmailService;

public class ForgotPasswordController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("sendOTP".equals(action)) {
                String email = request.getParameter("email");
                UserDAO dao = new UserDAO();

                if (!dao.checkEmailExist(email)) {
                    request.setAttribute("ERROR", "Email không tồn tại trong hệ thống!");
                    request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
                    return;
                }

                // Gen mã OTP 6 số ngẫu nhiên
                SecureRandom random = new SecureRandom();
                int otp = random.nextInt(999999);
                
                // Lưu vào Session kèm thời gian hết hạn (3 phút = 3 * 60 * 1000 ms)
                long expiryTime = System.currentTimeMillis() + (3 * 60 * 1000);
                session.setAttribute("OTP_CODE", otp);
                session.setAttribute("OTP_EMAIL", email);
                session.setAttribute("OTP_EXPIRY_TIME", expiryTime);

                // Gửi mail
                new Thread(() -> {
                    EmailService.sendOTPEmailForgetPass(email, otp);
                }).start();

                request.setAttribute("MESSAGE", "Mã OTP đã được gửi đến email của bạn.");
                request.getRequestDispatcher("reset_password.jsp").forward(request, response);

            } else if ("verifyAndReset".equals(action)) {
                String inputOTP = request.getParameter("otp");
                String newPassword = request.getParameter("newPassword");

                // Lấy object ra trước
                Object otpObj = session.getAttribute("OTP_CODE");
                Object emailObj = session.getAttribute("OTP_EMAIL");
                Long expiryTime = (Long) session.getAttribute("OTP_EXPIRY_TIME");

                String sessionOTP = (otpObj != null) ? String.valueOf(otpObj) : null;
                String sessionEmail = (emailObj != null) ? String.valueOf(emailObj) : null;

                // Validate
                if (sessionOTP == null || expiryTime == null) {
                    request.setAttribute("ERROR", "Bạn chưa yêu cầu gửi mã OTP hoặc thao tác không hợp lệ!");
                    request.getRequestDispatcher("reset_password.jsp").forward(request, response);
                    return;
                }

                if (System.currentTimeMillis() > expiryTime) {
                    request.setAttribute("ERROR", "Mã OTP đã hết hạn (quá 3 phút). Vui lòng yêu cầu lại!");
                    request.getRequestDispatcher("reset_password.jsp").forward(request, response);
                    return;
                }

                if (!sessionOTP.equals(inputOTP)) {
                    request.setAttribute("ERROR", "Mã OTP không chính xác!");
                    request.getRequestDispatcher("reset_password.jsp").forward(request, response);
                    return;
                }

                // Cập nhật pass
                UserDAO dao = new UserDAO();
                if (dao.updatePassword(sessionEmail, newPassword)) {
                    // Thành công -> Xóa rác trong session
                    session.removeAttribute("OTP_CODE");
                    session.removeAttribute("OTP_EMAIL");
                    session.removeAttribute("OTP_EXPIRY_TIME");
                    
                    request.setAttribute("msg", "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Lỗi hệ thống khi cập nhật mật khẩu!");
                    request.getRequestDispatcher("reset_password.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
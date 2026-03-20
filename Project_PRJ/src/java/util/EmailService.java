package util;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {

    private static final String FROM_EMAIL = "tphu6541@gmail.com";
    private static final String APP_PASSWORD = "tjgx zysa ennq ufvz";

    // Email đăng kí thành công
    public static boolean sendWelcomeEmail(String toEmail, String fullName) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Hệ Thống PRJ Cinema", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Đăng kí thành công! Chào mừng bạn đến với PRJ Cinema", "UTF-8");

            // html cho mail
            String htmlContent = "<html><body>"
                    + "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333; border: 1px solid #ddd; border-radius: 10px; max-width: 600px; margin: 0 auto;'>"
                    + "<h2 style='color: #E50914; text-align: center;'>Xin chào " + fullName + "!</h2>"
                    + "<p style='font-size: 16px;'>Chúc mừng bạn đã tạo tài khoản thành công tại <b>PRJ Cinema</b>.</p>"
                    + "<p style='font-size: 16px;'>Tài khoản của bạn đã sẵn sàng để đặt vé những bộ phim bom tấn mới nhất với những chỗ ngồi có View đẹp nhất.</p>"
                    + "<hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'>"
                    + "<p style='font-size: 14px; color: #777;'>Trân trọng,<br><b>Đội ngũ hỗ trợ PRJ Cinema</b></p>"
                    + "</div>"
                    + "</body></html>";

            // Hỗ trợ tiếng việt cho nội dung
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Gửi mail sau khi thanh toán
    public static boolean sendTicketEmail(String toEmail, String fullName, String movieTitle, String showDate, String startTime, String seats, double totalAmount) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Phòng vé PRJ Cinema", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("E-ticket: Hóa đơn đặt vé xem phim tại PRJ Cinema", "UTF-8");

            // Định dạng tiền tệ: VD 150000 -> 150,000 VNĐ
            String formattedAmount = String.format("%,.0f VNĐ", totalAmount);

            // html cho mail
            String htmlContent = "<html><body>"
                    + "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333; border: 2px dashed #E50914; border-radius: 10px; max-width: 500px; margin: 0 auto; background-color: #fcfcfc;'>"
                    + "<h2 style='color: #E50914; text-align: center; text-transform: uppercase; border-bottom: 2px solid #E50914; padding-bottom: 10px;'>VÉ XEM PHIM (E-TICKET)</h2>"
                    + "<p>Xin chào <b>" + fullName + "</b>,</p>"
                    + "<p>Cảm ơn bạn đã tin tưởng và đặt vé tại PRJ Cinema. Dưới đây là thông tin vé của bạn. Vui lòng đưa mã này cho nhân viên soát vé trước khi vào rạp:</p>"
                    + "<table style='width: 100%; border-collapse: collapse; margin-top: 20px;'>"
                    + "<tr><td style='padding: 8px 0; border-bottom: 1px solid #ddd;'><b>Phim:</b></td><td style='padding: 8px 0; border-bottom: 1px solid #ddd; text-align: right; color: #E50914; font-weight: bold;'>" + movieTitle + "</td></tr>"
                    + "<tr><td style='padding: 8px 0; border-bottom: 1px solid #ddd;'><b>Suất chiếu:</b></td><td style='padding: 8px 0; border-bottom: 1px solid #ddd; text-align: right;'>" + startTime + " | " + showDate + "</td></tr>"
                    + "<tr><td style='padding: 8px 0; border-bottom: 1px solid #ddd;'><b>Ghế đã đặt:</b></td><td style='padding: 8px 0; border-bottom: 1px solid #ddd; text-align: right; font-weight: bold;'>" + seats + "</td></tr>"
                    + "<tr><td style='padding: 8px 0; border-bottom: 1px solid #ddd;'><b>Tổng tiền:</b></td><td style='padding: 8px 0; border-bottom: 1px solid #ddd; text-align: right; font-size: 18px; color: #28a745; font-weight: bold;'>" + formattedAmount + "</td></tr>"
                    + "</table>"
                    + "<p style='text-align: center; margin-top: 30px; font-size: 13px; color: #888;'><i>Đây là email tự động, vui lòng không trả lời.</i></p>"
                    + "</div>"
                    + "</body></html>";

            // Hỗ trợ tiếng việt cho nội dung
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Gửi mail mã OTP Quên mật khẩu
    public static boolean sendOTPEmailForgetPass(String toEmail, int otpCode) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Hệ Thống PRJ Cinema", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác thực (OTP)", "UTF-8");

            String htmlContent = "<html><body>"
                    + "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333; border: 1px solid #ddd; border-radius: 10px; max-width: 500px; margin: 0 auto;'>"
                    + "<h2 style='color: #E50914; text-align: center;'>Yêu cầu đặt lại mật khẩu</h2>"
                    + "<p>Xin chào,</p>"
                    + "<p>Bạn vừa yêu cầu lấy lại mật khẩu tại PRJ Cinema. Dưới đây là mã xác thực (OTP) của bạn. Mã này chỉ có hiệu lực trong vòng <b>3 phút</b>.</p>"
                    + "<div style='text-align: center; margin: 20px 0;'>"
                    + "<span style='font-size: 24px; font-weight: bold; background-color: #f4f4f4; padding: 10px 20px; border-radius: 5px; color: #E50914; letter-spacing: 5px;'>" + otpCode + "</span>"
                    + "</div>"
                    + "<p style='color: #777; font-size: 13px;'>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này để bảo vệ tài khoản.</p>"
                    + "</div>"
                    + "</body></html>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Gửi mail mã OTP Đăng kí
    public static boolean sendOTPEmailRegister(String toEmail, int otpCode) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Hệ Thống PRJ Cinema", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác thực (OTP)", "UTF-8");

            String htmlContent = "<html><body>"
                    + "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333; border: 1px solid #ddd; border-radius: 10px; max-width: 500px; margin: 0 auto;'>"
                    + "<h2 style='color: #E50914; text-align: center;'>Yêu cầu đặt lại mật khẩu</h2>"
                    + "<p>Xin chào,</p>"
                    + "<p>Bạn vừa yêu cầu lấy lại mật khẩu tại PRJ Cinema. Dưới đây là mã xác thực (OTP) của bạn. Mã này chỉ có hiệu lực trong vòng <b>3 phút</b>.</p>"
                    + "<div style='text-align: center; margin: 20px 0;'>"
                    + "<span style='font-size: 24px; font-weight: bold; background-color: #f4f4f4; padding: 10px 20px; border-radius: 5px; color: #E50914; letter-spacing: 5px;'>" + otpCode + "</span>"
                    + "</div>"
                    + "<p style='color: #777; font-size: 13px;'>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này để bảo vệ tài khoản.</p>"
                    + "</div>"
                    + "</body></html>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

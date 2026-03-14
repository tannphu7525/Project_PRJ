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
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Hệ Thống PRJ Cinema"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Đăng ký thành công! Chào mừng đến với PRJ Cinema");

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

            // Hỗ trợ tiếng việt
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

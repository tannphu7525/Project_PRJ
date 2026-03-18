package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.mindrot.jbcrypt.BCrypt;
import util.DBUtils;

public class UserDAO {

    private static final String LOGIN_QUERY = "SELECT * FROM Users WHERE Username = ?";
    private static final String CHECK_DUPLICATE_USERNAME_QUERY = "SELECT Username FROM Users WHERE Username = ?";
    private static final String REGISTER_QUERY = "INSERT INTO [dbo].[Users]\n"
            + "           ([Username]\n"
            + "           ,[Password]\n"
            + "           ,[FullName]\n"
            + "           ,[Role]\n"
            + "           ,[Status]\n"
            + "           ,[Email])\n"
            + "     VALUES\n"
            + "           (?\n"
            + "           ,?\n"
            + "           ,?\n"
            + "           ,'CUSTOMER'\n"
            + "           ,1"
            + "           ,?)";
    private static final String CHECK_EMAIL_EXIST = "SELECT UserID FROM Users WHERE Email = ?";
    private static final String UPDATE_PASSWORD = "UPDATE Users SET Password = ? WHERE Email = ?";

    // Login DAO
    public UserDTO login(String txtUsername, String txtPassword) {
        UserDTO user = null;
        try (Connection conn = DBUtils.getConnection();  
             PreparedStatement stm = conn.prepareStatement(LOGIN_QUERY)) {            
            stm.setString(1, txtUsername);            
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    String hashedPasswordFromDB = rs.getString("password");
                    
                    // Dùng BCrypt để kiểm tra xem mật khẩu nhập vào có khớp với mã băm trong DB không
                    if (BCrypt.checkpw(txtPassword, hashedPasswordFromDB)) {
                        int userID = rs.getInt("userID");
                        String username = rs.getString("username");
                        String fullName = rs.getString("fullName");
                        String role = rs.getString("role");
                        boolean status = rs.getBoolean("status");
                        String email = rs.getString("email");

                        user = new UserDTO(userID, username, hashedPasswordFromDB, fullName, role, status, email);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    //Check Username có tồn tại trong database chưa?
    public boolean checkDuplicateUsername(String username) {
        boolean isExist = false;
        UserDTO user = null;

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement stm = conn.prepareStatement(CHECK_DUPLICATE_USERNAME_QUERY)) {
            stm.setString(1, username);
            try ( ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    isExist = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isExist;
    }

    // Register DAO
    public boolean registerUser(UserDTO user) {
        boolean check = false;
        try ( Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(REGISTER_QUERY)) {
            String hashPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            stm.setString(1, user.getUsername());
            stm.setString(2, hashPassword);
            stm.setString(3, user.getFullName());
            stm.setString(4, user.getEmail());
            check = stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    //Kiểm tra Email có tồn tại trong hệ thống không
    public boolean checkEmailExist(String email) {
        boolean check = false;
        try ( Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(CHECK_EMAIL_EXIST)) {
            ps.setString(1, email);
            try ( ResultSet rs = ps.executeQuery();) {
                if (rs.next()) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    //Cập nhật mật khẩu mới (Hiện tại lưu plain-text, moudle sau sẽ băm Hash)
    public boolean updatePassword(String email, String newPassword) {
        boolean check = false;
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(UPDATE_PASSWORD)) {
            String hashPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            ps.setString(1, hashPassword);
            ps.setString(2, email);
            check = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }
}

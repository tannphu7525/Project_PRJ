package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBUtils;

public class UserDAO {

    private static final String LOGIN_QUERY = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
    private static final String CHECK_DUPLICATE_USERNAME_QUERY = "SELECT Username FROM Users WHERE Username = ?";
    
    // Login DAO
    public UserDTO login(String txtUsername, String txtPassword) {
        UserDTO user = null;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                stm = conn.prepareStatement(LOGIN_QUERY);
                stm.setString(1, txtUsername);
                stm.setString(2, txtPassword);
                rs = stm.executeQuery();

                if (rs.next()) {
                    int userID = rs.getInt("userID");
                    String username = rs.getString("username");
                    String password = rs.getString("password");
                    String fullName = rs.getString("fullName");
                    String role = rs.getString("role");
                    boolean status = rs.getBoolean("status");

                    user = new UserDTO(userID, username, password, fullName, role, status);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stm != null)
                    stm.close();
                if (conn != null)
                    conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return user;
    }
    
    //Check Username có tồn tại trong database chưa?
    public boolean checkDuplicateUsername(String username){
        boolean isExist = false;
        UserDTO user = null;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                stm = conn.prepareStatement(CHECK_DUPLICATE_USERNAME_QUERY);
                stm.setString(1, username);
                rs = stm.executeQuery();
                if (rs.next()) {
                    isExist = true; 
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stm != null)
                    stm.close();
                if (conn != null)
                    conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return isExist;      
    }
    
    // Register DAO
//    public UserDTO registerUser(){
//        
//    }
}

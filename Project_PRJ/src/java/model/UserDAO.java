/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBUtils;

/**
 *
 * @author admin
 */
public class UserDAO {

    private static final String LOGIN_QUERY = "SELECT * FROM Users WHERE Username = ? AND Password = ?";

    //Login
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

                while (rs.next()) {
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
                if (rs != null) rs.close();
                if (stm != null) stm.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return user;
    }

}

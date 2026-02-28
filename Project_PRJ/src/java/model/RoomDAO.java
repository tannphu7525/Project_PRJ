/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import util.DBUtils;

/**
 *
 * @author admin
 */
public class RoomDAO {
    
    private static final String GET_ALL_ACTIVE_ROOM = "SELECT * FROM Room WHERE Status = 1";
    
    //In ra tất cả phòng đang hoạt động
    public ArrayList<RoomDTO> getAllActiveRoom(){
        ArrayList<RoomDTO> list = new ArrayList<>();
        
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(GET_ALL_ACTIVE_ROOM);
                ResultSet rs = stm.executeQuery()){
            int roomID = rs.getInt("roomID");
            int cinemaID = rs.getInt("cinemaID");
            String roomName = rs.getString("roomName");
            int capacity = rs.getInt("capacity");
            boolean status = rs.getBoolean("status");
            
            list.add(new RoomDTO(roomID, cinemaID, roomName, capacity, status));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}


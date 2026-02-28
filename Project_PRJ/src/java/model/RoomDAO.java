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

    //Code ở đây là thêm phần Tên rạp cho phần Thêm lịch chiếu
    private static final String GET_ALL_ACTIVE_ROOM = "SELECT r.RoomID, r.CinemaID, r.RoomName, r.Capacity, r.Status, c.CinemaName " +
                                                "FROM Room r " +
                                                "JOIN Cinemas c ON r.CinemaID = c.CinemaID " +
                                                "WHERE r.Status = 1 AND c.Status = 1 " +
                                                "ORDER BY c.CinemaID ASC";

    //In ra tất cả phòng đang hoạt động
    public ArrayList<RoomDTO> getAllActiveRoom() {
        ArrayList<RoomDTO> list = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(GET_ALL_ACTIVE_ROOM);
                ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                int roomID = rs.getInt("roomID");
                int cinemaID = rs.getInt("cinemaID");
                String roomName = rs.getString("roomName");
                int capacity = rs.getInt("capacity");
                boolean status = rs.getBoolean("status");
                String cinemaName = rs.getString("CinemaName");
                
                list.add(new RoomDTO(roomID, cinemaID, roomName, capacity, status, cinemaName));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

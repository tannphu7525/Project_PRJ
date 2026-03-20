package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import util.DBUtils;

public class RoomDAO {

    // Lấy danh sách PHÒNG ĐANG HOẠT ĐỘNG
    public ArrayList<RoomDTO> getAllActiveRoom() {
        ArrayList<RoomDTO> list = new ArrayList<>();
        String sql = "SELECT r.RoomID, r.CinemaID, r.RoomName, r.Capacity, r.Status, c.CinemaName " +
                     "FROM Room r JOIN Cinemas c ON r.CinemaID = c.CinemaID " +
                     "WHERE r.Status = 1 AND c.Status = 1 ORDER BY c.CinemaID ASC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                list.add(new RoomDTO(rs.getInt("RoomID"), rs.getInt("CinemaID"), rs.getString("RoomName"), 
                                     rs.getInt("Capacity"), rs.getBoolean("Status"), rs.getString("CinemaName")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    
    // Lấy TOÀN BỘ phòng chiếu (Bao gồm cả phòng đã khóa)
    public ArrayList<RoomDTO> getAllRooms() {
        ArrayList<RoomDTO> list = new ArrayList<>();
        String sql = "SELECT r.RoomID, r.CinemaID, r.RoomName, r.Capacity, r.Status, c.CinemaName " +
                     "FROM Room r JOIN Cinemas c ON r.CinemaID = c.CinemaID ORDER BY c.CinemaID ASC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                list.add(new RoomDTO(rs.getInt("RoomID"), rs.getInt("CinemaID"), rs.getString("RoomName"), 
                                     rs.getInt("Capacity"), rs.getBoolean("Status"), rs.getString("CinemaName")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Lấy 1 phòng cụ thể để Edit
    public RoomDTO getRoomByID(int roomID) {
        String sql = "SELECT r.RoomID, r.CinemaID, r.RoomName, r.Capacity, r.Status, c.CinemaName " +
                     "FROM Room r JOIN Cinemas c ON r.CinemaID = c.CinemaID WHERE r.RoomID = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, roomID);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return new RoomDTO(rs.getInt("RoomID"), rs.getInt("CinemaID"), rs.getString("RoomName"), 
                                       rs.getInt("Capacity"), rs.getBoolean("Status"), rs.getString("CinemaName"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // Thêm phòng mới 
    public int insertRoom(RoomDTO room) {
        String sql = "INSERT INTO Room (CinemaID, RoomName, Capacity, Status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, room.getCinemaID());
            ps.setString(2, room.getRoomName());
            ps.setInt(3, room.getCapacity());
            ps.setBoolean(4, room.isStatus());
            ps.executeUpdate();
            
            // Lấy ID vừa tạo ra
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    // Cập nhật phòng
    public boolean updateRoom(RoomDTO room) {
        String sql = "UPDATE Room SET CinemaID = ?, RoomName = ?, Status = ? WHERE RoomID = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, room.getCinemaID());
            ps.setString(2, room.getRoomName());
            ps.setBoolean(3, room.isStatus());
            ps.setInt(4, room.getRoomID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Xóa phòng 
    public boolean deleteRoom(int roomID) {
        String sql = "DELETE FROM Room WHERE RoomID = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}
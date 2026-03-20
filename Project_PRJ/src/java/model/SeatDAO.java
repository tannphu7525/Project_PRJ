package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import util.DBUtils;

public class SeatDAO {

    public ArrayList<SeatDTO> getSeatsByShowtime(int roomID, int showtimeID) {
        ArrayList<SeatDTO> list = new ArrayList<>();

        String sql = "SELECT s.SeatID, s.RoomID, s.SeatName, s.SeatType, s.Status, "
                + "CASE WHEN t.TicketID IS NOT NULL THEN 1 ELSE 0 END AS IsBooked "
                + "FROM Seats s "
                + "LEFT JOIN Tickets t ON s.SeatID = t.SeatID AND t.ShowtimeID = ? "
                + "WHERE s.RoomID = ? AND s.Status = 1 "
                + "ORDER BY s.SeatName ASC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement stm = conn.prepareStatement(sql)) {

            stm.setInt(1, showtimeID);
            stm.setInt(2, roomID);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                int seatID = rs.getInt("seatID");
                int rID = rs.getInt("roomID");
                String seatName = rs.getString("seatName");
                String seatType = rs.getString("seatType");
                boolean status = rs.getBoolean("status");

                // Nếu SQL trả về 1 nghĩa là đã có người mua, 0 là còn trống
                boolean isBooked = rs.getInt("IsBooked") == 1;

                list.add(new SeatDTO(seatID, rID, seatName, seatType, status, isBooked));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// Xóa toàn bộ ghế của 1 phòng 
    public void deleteSeatsByRoom(int roomID) {
        String sql = "DELETE FROM Seats WHERE RoomID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Tự động sinh sơ đồ ghế khi tạo phòng mới
    public void generateSeatsForRoom(int roomID, int capacity) {
        String sql = "INSERT INTO Seats (RoomID, SeatName, SeatType, Status) VALUES (?, ?, ?, 1)";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            char row = 'A';
            int num = 1;

            for (int i = 0; i < capacity; i++) {
                String seatName = String.valueOf(row) + num;
                // Giả sử: Từ dãy D trở đi mặc định là ghế VIP
                String seatType = (row >= 'D') ? "VIP" : "NORMAL";

                ps.setInt(1, roomID);
                ps.setString(2, seatName);
                ps.setString(3, seatType);
                ps.addBatch(); // Gom lệnh để insert 1 lần cho nhanh

                num++;
                if (num > 10) { // Mỗi hàng 10 ghế
                    num = 1;
                    row++;
                }
            }
            ps.executeBatch(); // Thực thi insert toàn bộ ghế
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

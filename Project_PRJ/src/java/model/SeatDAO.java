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
}

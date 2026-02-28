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
public class ShowtimeDAO {

    private static final String GET_ALL_SHOWTIMES = "SELECT s.ShowtimeID, s.MovieID, s.RoomID, s.ShowDate, s.StartTime, s.EndTime, s.Price, s.Status, "
            + "m.Title AS movieTitle, r.RoomName AS roomName, c.CinemaName AS cinemaName "
            + "FROM Showtime s "
            + "JOIN Movies m ON s.MovieID = m.MovieID "
            + "JOIN Room r ON s.RoomID = r.RoomID "
            + "JOIN Cinemas c ON r.CinemaID = c.CinemaID "
            + "ORDER BY s.ShowDate DESC, s.StartTime ASC";

    private static final String INSERT_SHOWTIME = "INSERT INTO Showtime (RoomID, MovieID, ShowDate, StartTime, EndTime, Price, Status) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String CHECK_CONFLICT = "SELECT TOP 1 ShowtimeID FROM Showtime " +
                                                "WHERE RoomID = ? AND ShowDate = ? AND Status = 1 " +
                                                "AND (? < EndTime AND ? > StartTime)";
    
    //In ra tất cả lịch chiếu 
    public ArrayList<ShowtimeDTO> getAllShowtimes() {
        ArrayList<ShowtimeDTO> list = new ArrayList<>();

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement stm = conn.prepareStatement(GET_ALL_SHOWTIMES);  ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                int showtimeID = rs.getInt("ShowtimeID");
                int movieID = rs.getInt("MovieID");
                int roomID = rs.getInt("RoomID");
                String showDate = rs.getString("ShowDate");
                String startTime = rs.getString("StartTime");
                String endTime = rs.getString("EndTime");
                double price = rs.getDouble("Price");
                boolean status = rs.getBoolean("Status");

                String movieTitle = rs.getString("movieTitle");
                String roomName = rs.getString("roomName");
                String cinemaName = rs.getString("cinemaName");

                list.add(new ShowtimeDTO(showtimeID, movieID, roomID, showDate, startTime, endTime, price, status, movieTitle, roomName, cinemaName));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //
    public boolean insertShowtimes(ShowtimeDTO st) {
        boolean check = false;
        try ( Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(INSERT_SHOWTIME)) {

            stm.setInt(1, st.getRoomID());
            stm.setInt(2, st.getMovieID());
            stm.setString(3, st.getShowDate());
            stm.setString(4, st.getStartTime());
            stm.setString(5, st.getEndTime());
            stm.setDouble(6, st.getPrice());
            stm.setBoolean(7, st.isStatus());

            check = stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }
    
    public boolean checkConflict(int roomID, String showDate, String startTime, String endTime){
        boolean isConflict = false;
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(CHECK_CONFLICT)){
            
            stm.setInt(1, roomID);
            stm.setString(2, showDate);
            stm.setString(3, startTime); 
            stm.setString(4, endTime);  
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                    isConflict = true; // trùng lịch
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isConflict;
    }
}
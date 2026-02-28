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
    private static final String GET_ALL_SHOWTIMES = "SELECT \n" +
                                                    "    m.Title AS TenPhim,\n" +
                                                    "    c.CinemaName AS TenRap,\n" +
                                                    "    r.RoomName AS TenPhong,\n" +
                                                    "    s.ShowDate AS NgayChieu,\n" +
                                                    "    s.StartTime AS GioChieu,\n" +
                                                    "    s.Price AS GiaVe\n" +
                                                    "FROM Showtime s\n" +
                                                    "JOIN Movies m ON s.MovieID = m.MovieID\n" +
                                                    "JOIN Room r ON s.RoomID = r.RoomID\n" +
                                                    "JOIN Cinemas c ON r.CinemaID = c.CinemaID\n" +
                                                    "WHERE c.Status = 1 AND r.Status = 1 AND s.Status = 1";
    
    private static final String INSERT_SHOWTIME = "INSERT INTO Showtime (RoomID, MovieID, ShowDate, StartTime, EndTime, Price, Status) "+
                                                "VALUES (?, ?, ?, ?, NULL, ?, ?)";
    
    //In ra tất cả lịch chiếu 
    public ArrayList<ShowtimeDTO> getAllShowtimes(){
        ArrayList<ShowtimeDTO> list = new ArrayList<>();
        
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(GET_ALL_SHOWTIMES);
                ResultSet rs = stm.executeQuery()){
            
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
    public boolean insertShowtimes(ShowtimeDTO st){
        boolean check = false;
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(INSERT_SHOWTIME)){
            
            stm.setInt(1, st.getRoomID());
            stm.setInt(2, st.getMovieID());
            stm.setString(3, st.getShowDate());
            stm.setString(4, st.getStartTime());
            stm.setDouble(4, st.getPrice());
            stm.setBoolean(5, st.isStatus());
            
            check = stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }      
}

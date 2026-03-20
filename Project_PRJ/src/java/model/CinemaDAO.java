package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import util.DBUtils;

public class CinemaDAO {
    
    public List<CinemaDTO> getAllCinemas() {
        List<CinemaDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Cinemas"; 
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new CinemaDTO(rs.getInt("cinemaID"), rs.getString("cinemaName"), rs.getString("location"), rs.getBoolean("status")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public CinemaDTO getCinemaByID(int id) {
        String sql = "SELECT * FROM Cinemas WHERE cinemaID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new CinemaDTO(rs.getInt("cinemaID"), rs.getString("cinemaName"), rs.getString("location"), rs.getBoolean("status"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean addCinema(CinemaDTO cinema) {
        String sql = "INSERT INTO Cinemas (cinemaName, location, status) VALUES (?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cinema.getCinemaName());
            ps.setString(2, cinema.getLocation());
            ps.setBoolean(3, cinema.isStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateCinema(CinemaDTO cinema) {
        String sql = "UPDATE Cinemas SET cinemaName = ?, location = ?, status = ? WHERE cinemaID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cinema.getCinemaName());
            ps.setString(2, cinema.getLocation());
            ps.setBoolean(3, cinema.isStatus());
            ps.setInt(4, cinema.getCinemaID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteCinema(int id) {
        String sql = "DELETE FROM Cinemas WHERE cinemaID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false; 
        }
    }
}
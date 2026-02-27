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
public class MovieDAO {
    //CRUD

    private final static String GET_ALL_MOVIE = "SELECT * FROM Movies";
    private final static String GET_ACTIVE_MOVIE = "SELECT * FROM Movies WHERE Status = 1";
    private final static String INSERT_MOVIE = "INSERT INTO [dbo].[Movies]\n" +
                                                "           ([Title]\n" +
                                                "           ,[Description]\n" +
                                                "           ,[PosterUrl]\n" +
                                                "           ,[Genre]\n" +
                                                "           ,[BasePrice]\n" +
                                                "           ,[Status])\n" +
                                                "     VALUES\n" +
                                                "           (?\n" +
                                                "           ,?\n" +
                                                "           ,?\n" +
                                                "           ,?\n" +
                                                "           ,?\n" +
                                                "           ,?)";
    private final static String DELETE_MOVIE = "UPDATE [dbo].[Movies] SET [Status] = 0 WHERE MovieID = ?";
    private final static String UPDATE_MOVIE = "UPDATE [dbo].[Movies]\n" +
                                                "   SET [Title] = ?\n" +
                                                "      ,[Description] = ?\n" +
                                                "      ,[PosterUrl] = ?\n" +
                                                "      ,[Genre] = ?\n" +
                                                "      ,[BasePrice] = ?\n" +
                                                "      ,[Status] = ?\n" +
                                                " WHERE MovieID = ?";
    
    //Lấy ra tất cả Movie
    public ArrayList<MovieDTO> getAllMovie() {
        ArrayList<MovieDTO> list = new ArrayList<>();
        try ( Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(GET_ALL_MOVIE)) {
            try ( ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    int movieID = rs.getInt("movieID");
                    String title = rs.getString("title");
                    String description = rs.getString("description");
                    String posterUrl = rs.getString("posterUrl");
                    String genre = rs.getString("genre");
                    double basePrice = rs.getDouble("basePrice");
                    boolean status = rs.getBoolean("status");

                    MovieDTO movie = new MovieDTO(movieID, title, description, posterUrl, genre, basePrice, status);
                    list.add(movie);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //Lấy ra phim đang chiếu (Admin)
    public ArrayList<MovieDTO> getActiveMovie() {
        ArrayList<MovieDTO> list = new ArrayList<>();
        try ( Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(GET_ACTIVE_MOVIE)) {
            try ( ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    int movieID = rs.getInt("movieID");
                    String title = rs.getString("title");
                    String description = rs.getString("description");
                    String posterUrl = rs.getString("posterUrl");
                    String genre = rs.getString("genre");
                    double basePrice = rs.getDouble("basePrice");
                    boolean status = rs.getBoolean("status");

                    MovieDTO movie = new MovieDTO(movieID, title, description, posterUrl, genre, basePrice, status);
                    list.add(movie);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //INSERT New Movie (Admin)
    public boolean insertMovie(MovieDTO movie) {
        boolean check = false;
        try ( Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(INSERT_MOVIE)) {
        stm.setString(1, movie.getTitle());
        stm.setString(2, movie.getDescription());
        stm.setString(3, movie.getPosterUrl());
        stm.setString(4, movie.getGenre());
        stm.setDouble(5, movie.getBasePrice());
        stm.setBoolean(6, movie.isStatus());
        
        check = stm.executeUpdate() > 0; 
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }    
    
    //DELETE MOVIE (Admin)
    public boolean deleteMovie(int movieID) {
        boolean check = false;
        try ( Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(DELETE_MOVIE)) {
        stm.setInt(1,movieID);      
        check = stm.executeUpdate() > 0; 
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }  

    //Update Movie (Admin)
    public boolean updateMovie(MovieDTO movie) {
        boolean checkUpdate = false;
        try ( Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(UPDATE_MOVIE)) {
        stm.setString(1, movie.getTitle());
        stm.setString(2, movie.getDescription());
        stm.setString(3, movie.getPosterUrl());
        stm.setString(4, movie.getGenre());
        stm.setDouble(5, movie.getBasePrice());
        stm.setBoolean(6, movie.isStatus());
        stm.setInt(7, movie.getMovieID());
        
        checkUpdate = stm.executeUpdate() > 0; 
        } catch (Exception e) {
            e.printStackTrace();
        }
        return checkUpdate;
    }  
}

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
    
    public MovieDTO getMovieByID(int id) {
        String sql = "SELECT * FROM Movies WHERE MovieID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return new MovieDTO(
                        rs.getInt("MovieID"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getString("PosterUrl"),
                        rs.getString("Genre"),
                        rs.getDouble("BasePrice"),
                        rs.getBoolean("Status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    //INSERT New Movie (Admin)
    public boolean insertMovie(MovieDTO movie) {
        boolean check = false;
        String sql;
        
        // TRƯỜNG HỢP 1: MUỐN TỰ NHẬP ID (ĐIỀN VÀO CHỖ TRỐNG)
        if (movie.getMovieID() > 0) {
            // Câu lệnh phức tạp hơn: Bật cho phép nhập ID -> Insert -> Tắt đi
            sql = "SET IDENTITY_INSERT Movies ON; " +
                  "INSERT INTO [dbo].[Movies] " +
                  "([MovieID], [Title], [Description], [PosterUrl], [Genre], [BasePrice], [Status]) " +
                  "VALUES (?, ?, ?, ?, ?, ?, ?); " +
                  "SET IDENTITY_INSERT Movies OFF;";
        } 
        // TRƯỜNG HỢP 2: ĐỂ TỰ ĐỘNG TĂNG (ID = 0)
        else {
            sql = "INSERT INTO [dbo].[Movies] " +
                  "([Title], [Description], [PosterUrl], [Genre], [BasePrice], [Status]) " +
                  "VALUES (?, ?, ?, ?, ?, ?)";
        }

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            
            if (movie.getMovieID() > 0) {
                // Nếu tự nhập ID, phải set tham số ID đầu tiên
                stm.setInt(1, movie.getMovieID());
                stm.setString(2, movie.getTitle());
                stm.setString(3, movie.getDescription());
                stm.setString(4, movie.getPosterUrl());
                stm.setString(5, movie.getGenre());
                stm.setDouble(6, movie.getBasePrice());
                stm.setBoolean(7, movie.isStatus());
            } else {
                // Nếu tự động, bỏ qua ID
                stm.setString(1, movie.getTitle());
                stm.setString(2, movie.getDescription());
                stm.setString(3, movie.getPosterUrl());
                stm.setString(4, movie.getGenre());
                stm.setDouble(5, movie.getBasePrice());
                stm.setBoolean(6, movie.isStatus());
            }

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

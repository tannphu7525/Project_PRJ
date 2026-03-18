package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import util.DBUtils;

public class ReviewDAO {

    private static final String CHECK_CAN_REVIEW = "SELECT TOP 1 1 "
                                + "FROM Orders o "
                                + "JOIN Tickets t ON o.OrderID = t.OrderID "
                                + "JOIN Showtime s ON t.ShowtimeID = s.ShowtimeID "
                                + "WHERE o.UserID = ? "
                                + "  AND s.MovieID = ? "
                                + "  AND o.OrderStatus = 'Completed' "
                                + "  AND s.ShowDate < CAST(GETDATE() AS DATE)";
    
    private static final String INSERT_REVIEW = "INSERT INTO Reviews (UserID, MovieID, Rating, Comment) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_RATING = "UPDATE Movies "
                                                + "SET Avg_Rating = (SELECT ROUND(CAST(AVG(CAST(Rating AS FLOAT)) AS DECIMAL(3,1)), 1) "
                                                + "                  FROM Reviews WHERE MovieID = ?) "
                                                + "WHERE MovieID = ?";
    private static final String GET_REVIEW_BY_MOVIEID = "SELECT r.*, u.FullName "
                                                + "FROM Reviews r "
                                                + "JOIN Users u ON r.UserID = u.UserID "
                                                + "WHERE r.MovieID = ? "
                                                + "ORDER BY r.ReviewDate DESC";
    
    //User TỪNG XEM phim này chưa?
    // Điều kiện: Có hóa đơn Completed + Có vé của phim đó + Ngày chiếu phải nhỏ hơn ngày hiện tại
    public boolean checkCanReview(int userID, int movieID) {
        boolean canReview = false;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_CAN_REVIEW)) {           
            ps.setInt(1, userID);
            ps.setInt(2, movieID);           
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    canReview = true; 
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return canReview;
    }
    
    // Thêm đánh giá mới & Tự động cập nhật Avg_Rating
    public boolean insertReview(int userID, int movieID, int rating, String comment) {
        boolean check = false;
        try (Connection conn = DBUtils.getConnection()) {
            // Thêm Review vào bảng
            try (PreparedStatement ps1 = conn.prepareStatement(INSERT_REVIEW)) {
                ps1.setInt(1, userID);
                ps1.setInt(2, movieID);
                ps1.setInt(3, rating);
                ps1.setString(4, comment);
                check = ps1.executeUpdate() > 0;
            }
            //Nếu thêm thành công, Trigger tính lại Avg_Rating
            if (check) {
                try (PreparedStatement ps2 = conn.prepareStatement(UPDATE_RATING)) {
                    ps2.setInt(1, movieID);
                    ps2.setInt(2, movieID);
                    ps2.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    // Lấy danh sách đánh giá của 1 bộ phim để hiển thị lên màn hình
    public ArrayList<ReviewDTO> getReviewsByMovieID(int movieID) {
        ArrayList<ReviewDTO> list = new ArrayList<>();                
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_REVIEW_BY_MOVIEID)) {
            ps.setInt(1, movieID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ReviewDTO(
                            rs.getInt("ReviewID"),
                            rs.getInt("UserID"),
                            rs.getInt("MovieID"),
                            rs.getInt("Rating"),
                            rs.getString("Comment"),
                            rs.getString("ReviewDate"),
                            rs.getString("FullName") 
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
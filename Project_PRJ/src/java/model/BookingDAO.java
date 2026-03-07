package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import util.DBUtils;

public class BookingDAO {

    private static final String INSERT_ORDER = "INSERT INTO Orders (UserID, TotalAmount, OrderStatus) VALUES (?, ?, 'Completed')";
    private static final String INSERT_TICKET = "INSERT INTO Tickets (OrderID, ShowtimeID, SeatID, Price) VALUES (?, ?, ?, ?)";
    private static final String GET_ORDER_HISTORY_BY_USERID = "SELECT \n" +
                        "    o.OrderID, o.OrderDate, o.TotalAmount, \n" +
                        "    m.Title AS MovieTitle, \n" +
                        "    c.CinemaName, \n" +
                        "    r.RoomName, \n" +
                        "    st.ShowDate, st.StartTime, \n" +
                        "    STRING_AGG(s.SeatName, ', ') AS Seats\n" +
                        "FROM Orders o\n" +
                        "JOIN Tickets t ON o.OrderID = t.OrderID\n" +
                        "JOIN Showtime st ON t.ShowtimeID = st.ShowtimeID\n" +
                        "JOIN Movies m ON st.MovieID = m.MovieID\n" +
                        "JOIN Room r ON st.RoomID = r.RoomID\n" +
                        "JOIN Cinemas c ON r.CinemaID = c.CinemaID\n" +
                        "JOIN Seats s ON t.SeatID = s.SeatID\n" +
                        "WHERE o.UserID = ? AND o.OrderStatus = 'Completed'\n" +
                        "GROUP BY o.OrderID, o.OrderDate, o.TotalAmount, m.Title, c.CinemaName, r.RoomName, st.ShowDate, st.StartTime\n" +
                        "ORDER BY o.OrderDate DESC"; // Đơn hàng mới nhất sẽ hiển thị lên đầu;

    public boolean processCheckout(int userID, int showtimeID, String[] seatIDs, double totalAmount) {
        boolean result = false;
        String sqlOrder = INSERT_ORDER;
        String sqlTicket = INSERT_TICKET;

        // 1. Vòng Try ngoài cùng: Quản lý đóng Connection
        try (Connection conn = DBUtils.getConnection()) {
            
            // 2. Vòng Try bên trong: Quản lý Transaction (Rollback)
            try {
                conn.setAutoCommit(false); 
                int currentOrderID = 0;

                // Gộp PreparedStatement của Order vào 1 khối block
                try (PreparedStatement stmOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                    stmOrder.setInt(1, userID);
                    stmOrder.setDouble(2, totalAmount);
                    stmOrder.executeUpdate();

                    // Gộp ResultSet
                    try (ResultSet rs = stmOrder.getGeneratedKeys()) {
                        if (rs.next()) currentOrderID = rs.getInt(1);
                    }
                }

                // Tách PreparedStatement của Ticket ra 1 khối block riêng
                try (PreparedStatement stmTicket = conn.prepareStatement(sqlTicket)) {
                    double pricePerTicket = totalAmount / seatIDs.length;
                    for (String seatIDStr : seatIDs) {
                        if (seatIDStr == null || seatIDStr.trim().isEmpty()) continue;
                        
                        stmTicket.setInt(1, currentOrderID);
                        stmTicket.setInt(2, showtimeID);
                        stmTicket.setInt(3, Integer.parseInt(seatIDStr.trim()));
                        stmTicket.setDouble(4, pricePerTicket); 
                        stmTicket.executeUpdate();
                    }
                }

                conn.commit(); // Chốt giao dịch
                result = true;

            } catch (Exception innerException) {
                innerException.printStackTrace();
                conn.rollback(); // Rollback an toàn vì Connection vẫn đang mở!
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }
    
    // Hàm lấy danh sách lịch sử vé của 1 khách hàng cụ thể
    public ArrayList<OrderHistoryDTO> getOrderHistoryByUserID(int userID) {
        ArrayList<OrderHistoryDTO> list = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(GET_ORDER_HISTORY_BY_USERID)) {
            
            stm.setInt(1, userID);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    OrderHistoryDTO history = new OrderHistoryDTO(
                            rs.getInt("OrderID"),
                            rs.getTimestamp("OrderDate"),
                            rs.getDouble("TotalAmount"),
                            rs.getString("MovieTitle"),
                            rs.getString("CinemaName"),
                            rs.getString("RoomName"),
                            rs.getDate("ShowDate"),
                            rs.getTime("StartTime"),
                            rs.getString("Seats")
                    );
                    list.add(history);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }    
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.BookingDAO;
import model.OrderHistoryDTO;
import model.SeatDAO;
import model.SeatDTO;
import model.ShowtimeDAO;
import model.ShowtimeDTO;
import model.UserDTO;
import model.VoucherDAO;
import model.VoucherDTO;

@WebServlet(name = "BookingController", urlPatterns = {"/BookingController"})
public class BookingController extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            doBooking(request, response);
            return;
        }

        try {
            switch (action) {
                case "booking":
                    doBooking(request, response);
                    break;
                case "history":
                    doHistory(request, response);
                    break;                
                default:
                    request.setAttribute("error", "Hành động không hợp lệ: " + action);
                    doBooking(request, response);
                    break;
            }
        } catch (Exception e) {
            log("Error at UserController: " + e.toString());
            request.setAttribute("error", "Hệ thống đang gặp sự cố, vui lòng thử lại sau.");
            request.getRequestDispatcher("error.jsp").forward(request, response);

        }
    }

    protected void doBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");
            String movieIDStr = request.getParameter("movieID");
            if (action == null && movieIDStr == null) {
                response.sendRedirect("HomeController");
                return;
            }

            // Tải danh sách Giờ chiếu của 1 Phim (khi khách bấm "Mua Vé Ngay")
            if ("loadShowtimes".equals(action) || (action == null && movieIDStr != null)) {
                int movieID = Integer.parseInt(movieIDStr);

                ShowtimeDAO stDAO = new ShowtimeDAO();
                ArrayList<ShowtimeDTO> stList = stDAO.getShowtimesByMovieID(movieID);

                request.setAttribute("SHOWTIME_LIST", stList);
                request.getRequestDispatcher("showtimes.jsp").forward(request, response);
                return; 
            }
            if (action.equals("loadSeats")) {
                int showtimeID = Integer.parseInt(request.getParameter("showtimeID"));
                int roomID = Integer.parseInt(request.getParameter("roomID"));

                SeatDAO seatDAO = new SeatDAO();
                ArrayList<SeatDTO> seatList = seatDAO.getSeatsByShowtime(roomID, showtimeID);
                request.setAttribute("SEAT_LIST", seatList);

                // Ném thêm 2 cái ID này sang JSP để lát nữa khách bấm "Thanh toán" mình còn biết là suất nào
                request.setAttribute("CURRENT_SHOWTIME_ID", showtimeID);
                request.setAttribute("CURRENT_ROOM_ID", roomID);
                request.getRequestDispatcher("seat_map.jsp").forward(request, response);
            } // Luồng 2: Xử lý khi khách bấm nút "Đặt vé" 
            else if (action.equals("checkout")) {
                // 1. Nhận dữ liệu từ form ẩn của JS ném về
                String selectedSeatsRaw = request.getParameter("selectedSeats"); // VD: "15,16,17"
                int showtimeID = Integer.parseInt(request.getParameter("showtimeID"));
                double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
                String appliedVoucherCode = request.getParameter("appliedVoucherCode");
                
                HttpSession session = request.getSession();
                UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
                if (loginUser == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                int userID = loginUser.getUserID();
                
                // BẢO MẬT VOUCHER 
                VoucherDAO voucherDAO = new VoucherDAO();              
                if (appliedVoucherCode != null && !appliedVoucherCode.trim().isEmpty()) {
                    VoucherDTO checkVoucher = voucherDAO.getValidVoucher(appliedVoucherCode);
                    
                    if (checkVoucher == null) {
                        request.setAttribute("ERROR_MSG", "Mã giảm giá không hợp lệ, đã hết lượt hoặc hết hạn. Giao dịch bị hủy!");
                        request.getRequestDispatcher("error.jsp").forward(request, response);
                        return; 
                    }                   
                }
                String[] seatIDs = selectedSeatsRaw.split(",");
                BookingDAO bookingDAO = new BookingDAO();
                boolean isSuccess = bookingDAO.processCheckout(userID, showtimeID, seatIDs, totalAmount);
                if (isSuccess) {
                    if (appliedVoucherCode != null && !appliedVoucherCode.trim().isEmpty()) {
                        voucherDAO.decreaseVoucherQuantity(appliedVoucherCode);
                    }
                    request.getSession().setAttribute("MESSAGE", "Đặt vé thành công! Hóa đơn của bạn đã được ghi nhận.");
                    response.sendRedirect("HomeController");
                } else {
                    request.setAttribute("ERROR_MSG", "Rất tiếc, giao dịch thất bại hoặc ghế đã bị đặt. Xin vui lòng thử lại!");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
    
    protected void doHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            HttpSession session = request.getSession();
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");

            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            BookingDAO dao = new BookingDAO();
            ArrayList<OrderHistoryDTO> historyList = dao.getOrderHistoryByUserID(loginUser.getUserID());

            request.setAttribute("HISTORY_LIST", historyList);
            request.getRequestDispatcher("history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

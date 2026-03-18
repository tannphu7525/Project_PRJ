package controller;

import java.io.IOException;
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
                case "booking": // Thanh toán
                case "checkout": // Bấm thanh toán, tạo QR
                case "confirm_qr": // Bấm xác nhận đã chuyển khoản
                    doBooking(request, response);
                    break;
                case "history": // Lịch sử Thanh toán
                    doHistory(request, response);
                    break;
                default:
                    request.setAttribute("error", "Hành động không hợp lệ: " + action);
                    doBooking(request, response);
                    break;
            }
        } catch (Exception e) {
            log("Error at BookingController: " + e.toString());
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
                request.setAttribute("CURRENT_SHOWTIME_ID", showtimeID);
                request.setAttribute("CURRENT_ROOM_ID", roomID);
                request.getRequestDispatcher("seat_map.jsp").forward(request, response);
            } else if (action.equals("checkout")) {
                String selectedSeatsRaw = request.getParameter("selectedSeats");
                int showtimeID = Integer.parseInt(request.getParameter("showtimeID"));
                double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
                String appliedVoucherCode = request.getParameter("appliedVoucherCode");

                HttpSession session = request.getSession();
                UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
                if (loginUser == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                // Lưu tạm vào Session
                session.setAttribute("TEMP_SEATS", selectedSeatsRaw);
                session.setAttribute("TEMP_SHOWTIME", showtimeID);
                session.setAttribute("TEMP_TOTAL", totalAmount);
                session.setAttribute("TEMP_VOUCHER", appliedVoucherCode);

                // TẠO LINK VIETQR
                String bankId = "stb"; // Thay bằng tên viết tắt ngân hàng của bạn (vcb, tpb, bidv...)
                String accountNo = "0344215596"; // Thay bằng STK thật của bạn
                String accountName = "THAI TAN PHU"; // Tên chủ tài khoản không dấu

                // Tạo một mã đơn hàng ngẫu nhiên làm nội dung chuyển khoản
                String orderCode = "VEPHIM" + System.currentTimeMillis();

                // Ép kiểu số tiền bỏ phần thập phân
                long amount = (long) totalAmount;

                // Build link QR (Nhớ encode nội dung để không bị lỗi dấu cách)
                String qrUrl = "https://img.vietqr.io/image/" + bankId + "-" + accountNo + "-compact2.png"
                        + "?amount=" + amount
                        + "&addInfo=" + java.net.URLEncoder.encode(orderCode, "UTF-8")
                        + "&accountName=" + java.net.URLEncoder.encode(accountName, "UTF-8");

                // Gửi dữ liệu sang trang jsp
                request.setAttribute("QR_URL", qrUrl);
                request.setAttribute("TOTAL_AMOUNT_STR", String.format("%,d", amount));
                request.setAttribute("ORDER_INFO", orderCode);

                // Chuyển hướng sang trang quét mã
                request.getRequestDispatcher("payment_qr.jsp").forward(request, response);
            } else if (action.equals("confirm_qr")) {
                HttpSession session = request.getSession();
                UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");

                // Lấy dữ liệu ra
                String selectedSeatsRaw = (String) session.getAttribute("TEMP_SEATS");
                int showtimeID = Integer.parseInt(String.valueOf(session.getAttribute("TEMP_SHOWTIME")));
                double totalAmount = Double.parseDouble(String.valueOf(session.getAttribute("TEMP_TOTAL")));
                String appliedVoucherCode = (String) session.getAttribute("TEMP_VOUCHER");

                if (selectedSeatsRaw != null) {
                    String[] seatIDs = selectedSeatsRaw.split(",");
                    BookingDAO bookingDAO = new BookingDAO();

                    // Lưu Database
                    boolean isSuccess = bookingDAO.processCheckout(loginUser.getUserID(), showtimeID, seatIDs, totalAmount);

                    if (isSuccess) {
                        if (appliedVoucherCode != null && !appliedVoucherCode.trim().isEmpty()) {
                            new VoucherDAO().decreaseVoucherQuantity(appliedVoucherCode);
                        }

                        // Gửi Email
                        final String userEmail = loginUser.getEmail();
                        final String userName = loginUser.getFullName();
                        final double finalAmount = totalAmount;
                        final String finalSeats = selectedSeatsRaw;

                        new Thread(() -> {
                            util.EmailService.sendTicketEmail(userEmail, userName, "Phim Bom Tấn", "Hôm nay", "Suất chiếu của bạn", finalSeats, finalAmount);
                        }).start();

                        session.setAttribute("MESSAGE", "Xác nhận chuyển khoản thành công! Vé E-Ticket đã được gửi qua Email.");
                    }

                    // Xóa Session
                    session.removeAttribute("TEMP_SEATS");
                    session.removeAttribute("TEMP_SHOWTIME");
                    session.removeAttribute("TEMP_TOTAL");
                    session.removeAttribute("TEMP_VOUCHER");
                }
                response.sendRedirect("HomeController");
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
        return "Booking Controller handling VietQR checkout";
    }
}

package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.BookingDAO;
import model.MovieDAO;
import model.MovieDTO;
import model.RoomDAO;
import model.ShowtimeDAO;
import model.ShowtimeDTO;
import model.VoucherDAO;
import model.VoucherDTO;
import model.CinemaDAO;
import model.CinemaDTO;
import model.OrderHistoryDTO;
import model.ReviewDAO;
import model.RoomDTO;
import model.SeatDAO;

public class AdminController extends HttpServlet {

    private static final String ADMIN_MOVIE_PAGE = "admin_movie.jsp";
    private static final String ADMIN_SHOWTIME_PAGE = "admin_showtime.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            adminMovie(request, response);
            return;
        }

        try {
            switch (action) {
                case "adminUser":
                    adminUser(request, response);
                    break;
                case "adminMovie":
                    adminMovie(request, response);
                    break;
                case "adminShowtime":
                    adminShowtime(request, response);
                    break;
                case "adminVoucher":
                    adminVoucher(request, response);
                    break;
                case "adminCinema":
                    adminCinema(request, response);
                    break;
                case "adminRoom":
                    adminRoom(request, response);
                    break;
                case "adminBooking":
                    adminBooking(request, response);
                    break;
                case "adminReview":
                    adminReview(request, response);
                    break;
                default:
                    request.setAttribute("msg", "Hành động quản trị không hợp lệ: " + action);
                    adminMovie(request, response);
                    break;
            }
        } catch (Exception e) {
            log("Error at AdminController: " + e.toString());
            request.setAttribute("msg", "Hệ thống quản trị đang gặp sự cố: " + e.getMessage());
            adminMovie(request, response);
        }
    }

    // MODULE QUẢN LÝ PHIM
    protected void adminMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        MovieDAO dao = new MovieDAO();

        try {
            if (subAction == null || subAction.isEmpty() || subAction.equals("list")) {
                request.setAttribute("LIST_MOVIE", dao.getAllMovie());
                request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);

            } else if (subAction.equals("edit")) {
                int id = 0;
                try {
                    id = Integer.parseInt(request.getParameter("movieID"));
                } catch (NumberFormatException e) {
                    id = 0;
                }

                MovieDTO movieToEdit = dao.getMovieByID(id);
                if (movieToEdit != null) {
                    request.setAttribute("MOVIE_EDIT", movieToEdit);
                    request.setAttribute("msg", "Đã tải thông tin phim: " + movieToEdit.getTitle());
                } else {
                    request.setAttribute("msg", "Không tìm thấy phim có ID = " + id);
                }

                request.setAttribute("LIST_MOVIE", dao.getAllMovie());
                request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);

            } else if (subAction.equals("add")) {
                int idInput = 0;
                try {
                    String idStr = request.getParameter("movieID");
                    if (idStr != null && !idStr.isEmpty()) {
                        idInput = Integer.parseInt(idStr);
                    }
                } catch (NumberFormatException e) {
                    idInput = 0;
                }

                String title = request.getParameter("title");
                String desc = request.getParameter("description");
                String genre = request.getParameter("genre");

                String poster = request.getParameter("existingPoster");
                if (poster == null) {
                    poster = "";
                }

                javax.servlet.http.Part filePart = request.getPart("posterFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String applicationPath = request.getServletContext().getRealPath("");
                    String uploadPath = applicationPath + java.io.File.separator + "pic";

                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    String uniqueFileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    filePart.write(uploadPath + java.io.File.separator + uniqueFileName);
                    poster = "pic/" + uniqueFileName;
                }

                double price = 0;
                try {
                    price = Double.parseDouble(request.getParameter("basePrice"));
                } catch (NumberFormatException e) {
                    price = 0;
                }
                boolean status = request.getParameter("status") != null;

                if (idInput > 0 && dao.getMovieByID(idInput) != null) {
                    request.setAttribute("msg", "Lỗi: ID " + idInput + " đã tồn tại!");
                } else {
                    boolean checkInsert = dao.insertMovie(new MovieDTO(idInput, title, desc, poster, genre, price, status));
                    request.setAttribute("msg", checkInsert ? "Thêm phim mới thành công!" : "Thêm phim thất bại!");
                }

                request.setAttribute("LIST_MOVIE", dao.getAllMovie());
                request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);

            } else if (subAction.equals("delete")) {
                int movieID = 0;
                try {
                    movieID = Integer.parseInt(request.getParameter("movieID"));
                } catch (NumberFormatException e) {
                    request.setAttribute("msg", "ID phim không hợp lệ!");
                    request.setAttribute("LIST_MOVIE", dao.getAllMovie());
                    request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);
                    return;
                }
                boolean checkDelete = dao.deleteMovie(movieID);
                if (checkDelete) {
                    request.setAttribute("msg", "Đã ngừng chiếu bộ phim!");
                }

                request.setAttribute("LIST_MOVIE", dao.getAllMovie());
                request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);

            } else if (subAction.equals("update")) {
                int movieID = Integer.parseInt(request.getParameter("movieID"));
                String title = request.getParameter("title");
                String desc = request.getParameter("description");
                String genre = request.getParameter("genre");

                String poster = request.getParameter("existingPoster");
                if (poster == null) {
                    poster = "";
                }

                javax.servlet.http.Part filePart = request.getPart("posterFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String applicationPath = request.getServletContext().getRealPath("");
                    String uploadPath = applicationPath + java.io.File.separator + "pic";

                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    String uniqueFileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    filePart.write(uploadPath + java.io.File.separator + uniqueFileName);
                    poster = "pic/" + uniqueFileName;
                }

                double price = 0;
                try {
                    price = Double.parseDouble(request.getParameter("basePrice"));
                } catch (NumberFormatException e) {
                    price = 0;
                }
                boolean status = request.getParameter("status") != null;

                boolean checkUpdate = dao.updateMovie(new MovieDTO(movieID, title, desc, poster, genre, price, status));
                request.setAttribute("msg", checkUpdate ? "Cập nhật thành công!" : "Cập nhật thất bại!");

                request.setAttribute("LIST_MOVIE", dao.getAllMovie());
                request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            java.io.StringWriter sw = new java.io.StringWriter();
            e.printStackTrace(new java.io.PrintWriter(sw));
            request.setAttribute("msg", "Lỗi Cụ Thể: " + e.toString() + " - " + sw.toString());
            request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);
        }
    }

    // MODULE QUẢN LÝ LỊCH CHIẾU
    protected void adminShowtime(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        String url = ADMIN_SHOWTIME_PAGE;

        ShowtimeDAO showTimeDAO = new ShowtimeDAO();
        MovieDAO movieDAO = new MovieDAO();
        RoomDAO roomDAO = new RoomDAO();

        try {
            if (subAction == null || subAction.isEmpty() || subAction.equals("list")) {
            } else if (subAction.equals("edit")) {
                int id = 0;
                try { id = Integer.parseInt(request.getParameter("showtimeID")); } catch (NumberFormatException ignored) {}
                request.setAttribute("SHOWTIME_EDIT", showTimeDAO.getShowtimeByID(id));
            } else if (subAction.equals("delete")) {
                int id = 0;
                try { id = Integer.parseInt(request.getParameter("showtimeID")); } catch (NumberFormatException ignored) {}
                boolean check = showTimeDAO.deleteShowtime(id);
                request.setAttribute("msg", check ? "Đã hủy lịch chiếu thành công!" : "Lỗi: Không thể xóa do đã có người đặt vé!");
            } else if (subAction.equals("add") || subAction.equals("update")) {
                int showtimeID = request.getParameter("showtimeID") != null ? Integer.parseInt(request.getParameter("showtimeID")) : 0;
                int movieID = Integer.parseInt(request.getParameter("movieID"));
                int roomID = Integer.parseInt(request.getParameter("roomID"));
                String showDate = request.getParameter("showDate");
                String startTime = request.getParameter("startTime");
                String endTime = request.getParameter("endTime");
                double price = Double.parseDouble(request.getParameter("price"));
                boolean status = request.getParameter("status") != null;

                boolean isConflict = false;
                if (subAction.equals("add")) {
                    isConflict = showTimeDAO.checkConflict(roomID, showDate, startTime, endTime);
                } else {
                    isConflict = showTimeDAO.checkConflictForUpdate(roomID, showDate, startTime, endTime, showtimeID);
                }

                if (isConflict) {
                    request.setAttribute("msg", "LỖI: Trùng lịch! Phòng này đã có phim chiếu trong khung giờ trên.");
                } else {
                    ShowtimeDTO st = new ShowtimeDTO(showtimeID, movieID, roomID, showDate, startTime, endTime, price, status, "", "", "");
                    boolean check = subAction.equals("add") ? showTimeDAO.insertShowtimes(st) : showTimeDAO.updateShowtime(st);
                    request.setAttribute("msg", check ? "Lưu thông tin lịch chiếu thành công!" : "Thao tác thất bại!");
                }
            }

            request.setAttribute("SHOWTIME_LIST", showTimeDAO.getAllShowtimes());
            request.setAttribute("MOVIE_LIST", movieDAO.getActiveMovie()); // Chỉ lấy phim đang mở bán
            request.setAttribute("ROOM_LIST", roomDAO.getAllActiveRoom());

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // MODULE QUẢN LÝ VOUCHER
    protected void adminVoucher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        VoucherDAO dao = new VoucherDAO();

        try {
            if (subAction == null || subAction.isEmpty() || subAction.equals("list")) {
                request.setAttribute("VOUCHER_LIST", dao.getAllVouchers());
                request.getRequestDispatcher("admin_voucher.jsp").forward(request, response);
            } else if (subAction.equals("edit")) {
                String code = request.getParameter("voucherCode");
                VoucherDTO v = dao.getVoucherByCode(code);
                if (v != null) {
                    request.setAttribute("VOUCHER_EDIT", v);
                }
                request.setAttribute("VOUCHER_LIST", dao.getAllVouchers());
                request.getRequestDispatcher("admin_voucher.jsp").forward(request, response);
            } else if (subAction.equals("add")) {
                String code = request.getParameter("voucherCode").toUpperCase().trim();
                int discount = Integer.parseInt(request.getParameter("discountPercent"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String expiryDate = request.getParameter("expiryDate");
                boolean status = request.getParameter("status") != null;

                if (dao.getVoucherByCode(code) != null) {
                    request.getSession().setAttribute("msg", "LỖI: Mã Voucher này đã tồn tại!");
                } else {
                    VoucherDTO newVoucher = new VoucherDTO(0, code, discount, quantity, expiryDate, status);
                    boolean check = dao.insertVoucher(newVoucher);
                    request.getSession().setAttribute("msg", check ? "Thêm Voucher thành công!" : "Thêm thất bại!");
                }
                response.sendRedirect("MainController?action=adminVoucher&subAction=list");
            } else if (subAction.equals("update")) {
                String code = request.getParameter("voucherCode").toUpperCase().trim();
                int discount = Integer.parseInt(request.getParameter("discountPercent"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String expiryDate = request.getParameter("expiryDate");
                boolean status = request.getParameter("status") != null;

                VoucherDTO v = new VoucherDTO(0, code, discount, quantity, expiryDate, status);
                boolean check = dao.updateVoucher(v);
                request.getSession().setAttribute("msg", check ? "Cập nhật thành công!" : "Cập nhật thất bại!");

                response.sendRedirect("MainController?action=adminVoucher&subAction=list");
            } else if (subAction.equals("delete")) {
                String code = request.getParameter("voucherCode");
                boolean check = dao.deleteVoucher(code);
                if (check) {
                    request.getSession().setAttribute("msg", "Đã xóa mã Voucher!");
                }
                response.sendRedirect("MainController?action=adminVoucher&subAction=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            java.io.StringWriter sw = new java.io.StringWriter();
            e.printStackTrace(new java.io.PrintWriter(sw));
            request.getSession().setAttribute("msg", "Lỗi Cụ Thể: " + e.toString() + " - " + sw.toString());
            response.sendRedirect("MainController?action=adminVoucher&subAction=list");
        }
    }

    //QUẢN LÝ RẠP PHIM 
    protected void adminCinema(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        CinemaDAO cinemaDAO = new CinemaDAO();

        try {
            if (subAction == null || subAction.equals("list")) {
                // Default
            } else if ("edit".equals(subAction)) {
                int id = Integer.parseInt(request.getParameter("cinemaID"));
                request.setAttribute("CINEMA_EDIT", cinemaDAO.getCinemaByID(id));
            } else if ("delete".equals(subAction)) {
                int id = Integer.parseInt(request.getParameter("cinemaID"));
                boolean check = cinemaDAO.deleteCinema(id);
                request.setAttribute("msg", check ? "Đã xóa rạp thành công!" : "Lỗi: Không thể xóa rạp (Có thể rạp đang có phòng chiếu). Gợi ý: Hãy tắt trạng thái hoạt động thay vì xóa!");
            } else if ("add".equals(subAction) || "update".equals(subAction)) {
                int cinemaID = request.getParameter("cinemaID") != null ? Integer.parseInt(request.getParameter("cinemaID")) : 0;
                String cinemaName = request.getParameter("cinemaName");
                String location = request.getParameter("location");
                boolean status = request.getParameter("status") != null;

                CinemaDTO cinema = new CinemaDTO(cinemaID, cinemaName, location, status);
                boolean isSuccess = "add".equals(subAction) ? cinemaDAO.addCinema(cinema) : cinemaDAO.updateCinema(cinema);
                request.setAttribute("msg", isSuccess ? "Lưu dữ liệu Rạp phim thành công!" : "Lỗi: Hệ thống không thể lưu.");
            }

            request.setAttribute("CINEMA_LIST", cinemaDAO.getAllCinemas());
            request.getRequestDispatcher("admin_cinema.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("admin_cinema.jsp").forward(request, response);
        }
    }

    // QUẢN LÝ PHÒNG CHIẾU VÀ GHẾ
    protected void adminRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        RoomDAO roomDAO = new RoomDAO();
        CinemaDAO cinemaDAO = new CinemaDAO();
        SeatDAO seatDAO = new SeatDAO();

        try {
            if ("add".equals(subAction)) {
                int cinemaID = Integer.parseInt(request.getParameter("cinemaID"));
                String roomName = request.getParameter("roomName");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                boolean status = request.getParameter("status") != null;

                RoomDTO newRoom = new RoomDTO(0, cinemaID, roomName, capacity, status, "");
                int newRoomID = roomDAO.insertRoom(newRoom);

                if (newRoomID > 0) {
                    // TỰ ĐỘNG SINH GHẾ KHI TẠO PHÒNG THÀNH CÔNG
                    seatDAO.generateSeatsForRoom(newRoomID, capacity);
                    request.setAttribute("msg", "Tạo phòng chiếu và " + capacity + " ghế tự động thành công!");
                } else {
                    request.setAttribute("msg", "Lỗi: Không thể thêm phòng chiếu.");
                }
            } else if ("edit".equals(subAction)) {
                int id = Integer.parseInt(request.getParameter("roomID"));
                request.setAttribute("ROOM_EDIT", roomDAO.getRoomByID(id));
            } else if ("update".equals(subAction)) {
                int roomID = Integer.parseInt(request.getParameter("roomID"));
                int cinemaID = Integer.parseInt(request.getParameter("cinemaID"));
                String roomName = request.getParameter("roomName");
                boolean status = request.getParameter("status") != null;

                RoomDTO room = new RoomDTO(roomID, cinemaID, roomName, 0, status, "");
                boolean check = roomDAO.updateRoom(room);
                request.setAttribute("msg", check ? "Cập nhật thông tin phòng thành công!" : "Cập nhật thất bại!");
            } else if ("delete".equals(subAction)) {
                int id = Integer.parseInt(request.getParameter("roomID"));
                // Xóa ghế trước (vì vướng khóa ngoại)
                seatDAO.deleteSeatsByRoom(id);
                // Sau đó xóa phòng
                boolean check = roomDAO.deleteRoom(id);
                request.setAttribute("msg", check ? "Đã xóa phòng chiếu và toàn bộ ghế!" : "Lỗi: Phòng đang có suất chiếu, không thể xóa!");
            }

            request.setAttribute("ROOM_LIST", roomDAO.getAllRooms());
            request.setAttribute("CINEMA_LIST", cinemaDAO.getAllCinemas());
            request.getRequestDispatcher("admin_room.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("admin_room.jsp").forward(request, response);
        }
    }

    //QUẢN LÝ NGƯỜI DÙNG (USER)
    protected void adminUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        model.UserDAO userDAO = new model.UserDAO();

        try {
            if ("toggleStatus".equals(subAction)) {
                int userID = Integer.parseInt(request.getParameter("userID"));
                boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));

                // Đảo ngược trạng thái hiện tại (Đang 1 thì thành 0, đang 0 thì thành 1)
                boolean check = userDAO.updateUserStatus(userID, !currentStatus);
                request.setAttribute("msg", check ? "Đã cập nhật trạng thái tài khoản!" : "Cập nhật thất bại!");

            } else if ("changeRole".equals(subAction)) {
                int userID = Integer.parseInt(request.getParameter("userID"));
                String newRole = request.getParameter("role");

                boolean check = userDAO.updateUserRole(userID, newRole);
                request.setAttribute("msg", check ? "Đã thay đổi phân quyền thành " + newRole + "!" : "Phân quyền thất bại!");
            }

            // Luôn load lại danh sách User
            request.setAttribute("USER_LIST", userDAO.getAllUsers());
            request.getRequestDispatcher("admin_user.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("admin_user.jsp").forward(request, response);
        }
    }

    // QUẢN LÝ ĐƠN HÀNG VÀ DOANH THU
    protected void adminBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        BookingDAO bookingDAO = new BookingDAO();

        try {
            if ("cancel".equals(subAction)) {
                int orderID = Integer.parseInt(request.getParameter("orderID"));
                boolean check = bookingDAO.cancelOrder(orderID);
                request.setAttribute("msg", check ? "Đã hủy đơn hàng và hoàn vé thành công!" : "Hủy đơn hàng thất bại!");
            }

            // Lấy danh sách toàn bộ đơn hàng
            ArrayList<OrderHistoryDTO> orderList = bookingDAO.getAllOrders();

            // Tính tổng doanh thu (Chỉ tính các đơn Completed)
            double totalRevenue = 0;
            int totalTickets = 0;
            for (OrderHistoryDTO o : orderList) {
                if ("Completed".equalsIgnoreCase(o.getOrderStatus())) {
                    totalRevenue += o.getTotalAmount();
                    totalTickets++; // Tạm tính số lượng đơn thành công
                }
            }

            request.setAttribute("ORDER_LIST", orderList);
            request.setAttribute("TOTAL_REVENUE", totalRevenue);
            request.setAttribute("TOTAL_TICKETS", totalTickets);

            request.getRequestDispatcher("admin_booking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("admin_booking.jsp").forward(request, response);
        }
    }

    // QUẢN LÝ BÌNH LUẬN (REVIEW)
    protected void adminReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        ReviewDAO reviewDAO = new ReviewDAO();

        try {
            if ("delete".equals(subAction)) {
                int reviewID = Integer.parseInt(request.getParameter("reviewID"));
                boolean check = reviewDAO.deleteReview(reviewID);
                request.setAttribute("msg", check ? "Đã xóa bình luận vi phạm thành công!" : "Lỗi: Không thể xóa bình luận này.");
            }

            // Lấy danh sách đổ ra giao diện
            request.setAttribute("REVIEW_LIST", reviewDAO.getAllReviewsForAdmin());
            request.getRequestDispatcher("admin_review.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            log("Error at AdminController: " + e.getMessage());
            request.setAttribute("msg", "Hệ thống đang bận hoặc dữ liệu không hợp lệ. Vui lòng kiểm tra lại thao tác!");
            adminMovie(request, response);
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
        return "Admin Controller Gộp";
    }
}

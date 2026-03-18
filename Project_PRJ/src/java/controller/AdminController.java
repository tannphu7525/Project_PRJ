package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.MovieDAO;
import model.MovieDTO;
import model.RoomDAO;
import model.ShowtimeDAO;
import model.ShowtimeDTO;
import model.VoucherDAO;
import model.VoucherDTO;

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
                case "adminMovie":
                    adminMovie(request, response);
                    break;
                case "adminShowtime":
                    adminShowtime(request, response);
                    break;
                case "adminVoucher":
                    adminVoucher(request, response);
                    break;
                default:
                    request.setAttribute("msg", "Hành động quản trị không hợp lệ: " + action);
                    adminMovie(request, response);
                    break;
            }
        } catch (Exception e) {
            log("Error at AdminController: " + e.toString());
            request.setAttribute("msg", "Hệ thống quản trị đang gặp sự cố: " + e.getMessage());
            // SỬA LỖI 404: Không dùng sendRedirect ở đây nữa, dùng forward luôn
            adminMovie(request, response);
        }
    }

    // ==========================================
    // MODULE QUẢN LÝ PHIM
    // ==========================================
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

                // ==========================================
                // LOGIC XỬ LÝ UPLOAD ẢNH (CHO THÊM MỚI)
                // ==========================================
                String poster = request.getParameter("existingPoster");
                if (poster == null) {
                    poster = "";
                }

                javax.servlet.http.Part filePart = request.getPart("posterFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uploadPath = "D:\\GitHub\\Project_PRJ\\Project_PRJ\\web\\pic";
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir(); // Tự động tạo thư mục pic nếu chưa có
                    }
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    filePart.write(uploadPath + java.io.File.separator + uniqueFileName);
                    poster = "pic/" + uniqueFileName; // Lưu đường dẫn vào biến poster để add vào DB
                }
                // ==========================================

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
                int movieID = Integer.parseInt(request.getParameter("movieID"));
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

                // ==========================================
                // LOGIC XỬ LÝ UPLOAD ẢNH (CHO CẬP NHẬT)
                // ==========================================
                String poster = request.getParameter("existingPoster"); // Giữ lại link ảnh cũ nếu không up ảnh mới
                if (poster == null) {
                    poster = "";
                }

                javax.servlet.http.Part filePart = request.getPart("posterFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uploadPath = "D:\\GitHub\\Project_PRJ\\Project_PRJ\\web\\pic";
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }

                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    filePart.write(uploadPath + java.io.File.separator + uniqueFileName);
                    poster = "pic/" + uniqueFileName; // Ghi đè đường dẫn mới nếu có up ảnh
                }
                // ==========================================

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

    // ==========================================
    // MODULE QUẢN LÝ LỊCH CHIẾU
    // ==========================================
    protected void adminShowtime(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        String url = ADMIN_SHOWTIME_PAGE;

        ShowtimeDAO showTimeDAO = new ShowtimeDAO();
        MovieDAO movieDAO = new MovieDAO();
        RoomDAO roomDAO = new RoomDAO();

        try {
            if (subAction == null || subAction.isEmpty() || subAction.equals("list")) {
                // Giữ nguyên
            } else if (subAction.equals("add")) {
                int movieID = Integer.parseInt(request.getParameter("movieID"));
                int roomID = Integer.parseInt(request.getParameter("roomID"));
                String showDate = request.getParameter("showDate");
                String startTime = request.getParameter("startTime");
                String endTime = request.getParameter("endTime");

                boolean isConflict = showTimeDAO.checkConflict(roomID, showDate, startTime, endTime);
                if (isConflict) {
                    request.setAttribute("msg", "LỖI: Trùng lịch! Phòng này đã có phim chiếu trong khung giờ trên.");
                } else {
                    double price = Double.parseDouble(request.getParameter("price"));
                    boolean status = request.getParameter("status") != null;
                    ShowtimeDTO newShowtime = new ShowtimeDTO(movieID, movieID, roomID, showDate, startTime, startTime,
                            price, status, startTime, showDate, startTime);

                    boolean checkAdd = showTimeDAO.insertShowtimes(newShowtime);
                    request.setAttribute("msg", checkAdd ? "Tạo Lịch chiếu thành công!" : "Tạo Lịch chiếu thất bại!");
                }
            }

            // Luôn load lại dữ liệu rạp sau mỗi thao tác
            request.setAttribute("SHOWTIME_LIST", showTimeDAO.getAllShowtimes());
            request.setAttribute("MOVIE_LIST", movieDAO.getActiveMovie());
            request.setAttribute("ROOM_LIST", roomDAO.getAllActiveRoom());

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // ==========================================
    // MODULE QUẢN LÝ VOUCHER (AJAX)
    // ==========================================
    protected void adminVoucher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subAction = request.getParameter("subAction");
        VoucherDAO dao = new VoucherDAO();

        try {
            // 1. HIỂN THỊ DANH SÁCH VOUCHER
            if (subAction == null || subAction.isEmpty() || subAction.equals("list")) {
                request.setAttribute("VOUCHER_LIST", dao.getAllVouchers());
                request.getRequestDispatcher("admin_voucher.jsp").forward(request, response);
            } // 2. TẢI DỮ LIỆU ĐỂ SỬA
            else if (subAction.equals("edit")) {
                String code = request.getParameter("voucherCode");
                VoucherDTO v = dao.getVoucherByCode(code);
                if (v != null) {
                    request.setAttribute("VOUCHER_EDIT", v);
                }
                request.setAttribute("VOUCHER_LIST", dao.getAllVouchers());
                request.getRequestDispatcher("admin_voucher.jsp").forward(request, response);
            } // 3. THÊM VOUCHER MỚI
            else if (subAction.equals("add")) {
                String code = request.getParameter("voucherCode").toUpperCase().trim();
                int discount = Integer.parseInt(request.getParameter("discountPercent"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String expiryDate = request.getParameter("expiryDate");
                boolean status = request.getParameter("status") != null;

                // Kiểm tra trùng mã
                if (dao.getVoucherByCode(code) != null) {
                    request.getSession().setAttribute("msg", "LỖI: Mã Voucher này đã tồn tại!");
                } else {
                    VoucherDTO newVoucher = new VoucherDTO(0, code, discount, quantity, expiryDate, status);
                    boolean check = dao.insertVoucher(newVoucher);
                    request.getSession().setAttribute("msg", check ? "Thêm Voucher thành công!" : "Thêm thất bại!");
                }
                response.sendRedirect("MainController?action=adminVoucher&subAction=list");
            } // 4. CẬP NHẬT VOUCHER
            else if (subAction.equals("update")) {
                String code = request.getParameter("voucherCode").toUpperCase().trim();
                int discount = Integer.parseInt(request.getParameter("discountPercent"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String expiryDate = request.getParameter("expiryDate");
                boolean status = request.getParameter("status") != null;

                VoucherDTO v = new VoucherDTO(0, code, discount, quantity, expiryDate, status);
                boolean check = dao.updateVoucher(v);
                request.getSession().setAttribute("msg", check ? "Cập nhật thành công!" : "Cập nhật thất bại!");

                response.sendRedirect("MainController?action=adminVoucher&subAction=list");
            } // 5. XÓA VOUCHER
            else if (subAction.equals("delete")) {
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

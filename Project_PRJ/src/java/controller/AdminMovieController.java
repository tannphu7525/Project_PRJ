package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.MovieDAO;
import model.MovieDTO;

@WebServlet(name="AdminMovieController", urlPatterns={"/AdminMovieController"})
public class AdminMovieController extends HttpServlet {
    private static final String ADMIN_MOVIE_PAGE = "admin_movie.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String subAction = request.getParameter("subAction");
        MovieDAO dao = new MovieDAO();
        
        try {
            // TRƯỜNG HỢP 1: HIỂN THỊ DANH SÁCH
            if (subAction == null || subAction.isEmpty() || subAction.equals("list")) {
                ArrayList<MovieDTO> list = dao.getAllMovie();
                // SỬA LỖI: Đổi ADMIN_MOVIE_LIST thành LIST_MOVIE cho khớp với file JSP
                request.setAttribute("LIST_MOVIE", list); 
                request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);
            }
            // TRƯỜNG HỢP 2: LẤY DỮ LIỆU ĐỂ SỬA
            else if (subAction.equals("edit")) {
                int id = 0;
                try {
                    id = Integer.parseInt(request.getParameter("movieID"));
                } catch (NumberFormatException e) {
                    id = 0;
                }
                
                MovieDTO movieToEdit = dao.getMovieByID(id);
                
                if (movieToEdit != null) {
                    request.setAttribute("MOVIE_EDIT", movieToEdit);
                    request.setAttribute("msg", "Đã tìm thấy phim: " + movieToEdit.getTitle());
                } else {
                    request.setAttribute("msg", "Không tìm thấy phim có ID = " + id);
                }
                
                // SỬA LỖI: Đổi ADMIN_MOVIE_LIST thành LIST_MOVIE
                request.setAttribute("LIST_MOVIE", dao.getAllMovie());
                request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);
            }           
            // TRƯỜNG HỢP 3: THÊM PHIM MỚI
            else if (subAction.equals("add")) {
                int idInput = 0;
                try {
                    String idStr = request.getParameter("movieID");
                    if(idStr != null && !idStr.isEmpty()) {
                        idInput = Integer.parseInt(idStr);
                    }
                } catch (NumberFormatException e) {
                    idInput = 0;
                }

                String title = request.getParameter("title");
                String desc = request.getParameter("description");
                String poster = request.getParameter("posterUrl");
                String genre = request.getParameter("genre");
                double price = 0;
                try {
                    price = Double.parseDouble(request.getParameter("basePrice"));
                } catch (NumberFormatException e) {
                    price = 0;
                }
                boolean status = request.getParameter("status") != null;

                if (idInput > 0 && dao.getMovieByID(idInput) != null) {
                    request.getSession().setAttribute("msg", "Lỗi: ID " + idInput + " đã tồn tại! Vui lòng chọn ID khác.");
                } else {
                    MovieDTO movie = new MovieDTO(idInput, title, desc, poster, genre, price, status);
                    boolean checkInsert = dao.insertMovie(movie);
                    
                    if (checkInsert) {
                        request.getSession().setAttribute("msg", "Thêm phim mới thành công!");
                    } else {
                        request.getSession().setAttribute("msg", "Thêm phim thất bại!");
                    }
                }
                
                // SỬA LỖI: Trả về thông qua MainController
                response.sendRedirect("MainController?action=adminMovie&subAction=list");
            }
            
            // TRƯỜNG HỢP 4: XÓA PHIM
            else if (subAction.equals("delete")) {
                int movieID = Integer.parseInt(request.getParameter("movieID"));
                boolean checkDelete = dao.deleteMovie(movieID);              
                
                if (checkDelete) {
                    request.getSession().setAttribute("msg", "Đã ngừng chiếu bộ phim!");
                }
                
                // SỬA LỖI: Trả về thông qua MainController
                response.sendRedirect("MainController?action=adminMovie&subAction=list");
            }
            
            // TRƯỜNG HỢP 5: CẬP NHẬT PHIM
            else if (subAction.equals("update")) {
                int movieID = Integer.parseInt(request.getParameter("movieID"));
                String title = request.getParameter("title");
                String desc = request.getParameter("description");
                String poster = request.getParameter("posterUrl");
                String genre = request.getParameter("genre");
                double price = 0;
                try {
                    price = Double.parseDouble(request.getParameter("basePrice"));
                } catch (NumberFormatException e) {
                    price = 0;
                }            
                boolean status = request.getParameter("status") != null;                
                
                MovieDTO movie = new MovieDTO(movieID, title, desc, poster, genre, price, status);              
                boolean checkUpdate = dao.updateMovie(movie);
                
                if (checkUpdate) {
                    request.getSession().setAttribute("msg", "Cập nhật thành công!");
                } else {
                    request.getSession().setAttribute("msg", "Cập nhật thất bại!");
                }                
                
                // SỬA LỖI: Trả về thông qua MainController
                response.sendRedirect("MainController?action=adminMovie&subAction=list");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("MainController?action=adminMovie&subAction=list");
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
    }
}
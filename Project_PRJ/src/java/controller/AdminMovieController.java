/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

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
   private static final String ADMIN_MOVIE_PAGE = "admin.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String subAction = request.getParameter("subAction");
        MovieDAO dao = new MovieDAO();
        
        try {
            // TRƯỜNG HỢP 1: HIỂN THỊ DANH SÁCH (Mặc định)
            if (subAction == null || subAction.isEmpty() || subAction.equals("list")) {
                ArrayList<MovieDTO> list = dao.getAllMovie();
                request.setAttribute("ADMIN_MOVIE_LIST", list);
                request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);
            }
            // TRƯỜNG HỢP 2: LẤY DỮ LIỆU ĐỂ SỬA (Khi nhấn Enter ở ô ID)
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
                
                // Load lại danh sách và Forward để hiện Form có dữ liệu
                request.setAttribute("ADMIN_MOVIE_LIST", dao.getAllMovie());
                request.getRequestDispatcher(ADMIN_MOVIE_PAGE).forward(request, response);
            }           
            // TRƯỜNG HỢP 3: THÊM PHIM MỚI
            else if (subAction.equals("add")) {
                // 1. Lấy ID 
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

                // 3. Kiểm tra trùng ID
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
                
                response.sendRedirect("AdminMovieController?subAction=list");
            }
            
            // -----------------------------------------------------------
            // TRƯỜNG HỢP 4: XÓA PHIM (Dùng Redirect)
            // -----------------------------------------------------------
            else if (subAction.equals("delete")) {
                int movieID = Integer.parseInt(request.getParameter("movieID"));
                boolean checkDelete = dao.deleteMovie(movieID);              
                
                // SỬA LỖI: Dùng Session
                if (checkDelete) {
                    request.getSession().setAttribute("msg", "Đã ngừng chiếu bộ phim!");
                }
                
                response.sendRedirect("AdminMovieController?subAction=list");
            }
            
            // -----------------------------------------------------------
            // TRƯỜNG HỢP 5: CẬP NHẬT PHIM (Dùng Redirect)
            // -----------------------------------------------------------
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
                
                // Dùng Session (Đã đúng)
                if (checkUpdate) {
                    request.getSession().setAttribute("msg", "Cập nhật thành công!");
                } else {
                    request.getSession().setAttribute("msg", "Cập nhật thất bại!");
                }               
                
                response.sendRedirect("AdminMovieController?subAction=list");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("AdminMovieController?subAction=list");
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
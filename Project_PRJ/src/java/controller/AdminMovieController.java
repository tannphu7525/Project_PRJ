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
        String url = ADMIN_MOVIE_PAGE;
        
        try {
            if (subAction == null || subAction.isEmpty() || subAction.equals("list")) {
                ArrayList<MovieDTO> list = dao.getAllMovie();
                request.setAttribute("ADMIN_MOVIE_LIST", list);
                request.getRequestDispatcher("admin.jsp").forward(request, response);
            }else if (subAction.equals("add")) {
                // Add
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
                MovieDTO movie = new MovieDTO(0, title, desc, poster, genre, price, status);              
                boolean checkInsert = dao.insertMovie(movie);
                if (checkInsert) {
                    request.setAttribute("msg", "Thêm phim mới thành công!");
                }else{
                    request.setAttribute("msg", "Thêm phim thất bại!");
                }
                
                //Load lại toàn bộ đã cập nhật 
                request.setAttribute("ADMIN_MOVIE_LIST", dao.getAllMovie());
                response.sendRedirect("AdminMovieController?subAction=list");
                
            }else if (subAction.equals("delete")) {
                //Delete Movie
                int movieID = Integer.parseInt(request.getParameter("movieID"));
                boolean checkDelete = dao.deleteMovie(movieID);              
                if (checkDelete) {
                    request.setAttribute("msg", "Đã ngừng chiếu bộ phim!");
                }
                //Load lại danh sách
                request.setAttribute("ADMIN_MOVIE_LIST", dao.getAllMovie());
                response.sendRedirect("AdminMovieController?subAction=list");
                
            }else if (subAction.equals("update")) {
                //Update Movie
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
                MovieDTO movie = new MovieDTO(movieID, title, subAction, poster, genre, price, status);              
                boolean checkUpdate = dao.updateMovie(movie);
                if (checkUpdate) {
                    request.setAttribute("msg", "Cập nhật thành công!");
                }else{
                    request.setAttribute("msg", "Cập nhật thất bại!");
                }               
                //Load lại toàn bộ đã cập nhật 
                request.setAttribute("ADMIN_MOVIE_LIST", dao.getAllMovie());    
                response.sendRedirect("AdminMovieController?subAction=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
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

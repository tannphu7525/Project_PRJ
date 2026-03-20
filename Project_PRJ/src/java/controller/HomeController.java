/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.MovieDAO;
import model.MovieDTO;
import model.ShowtimeDAO;
import model.ShowtimeDTO;
import model.UserDTO;

public class HomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        MovieDAO dao = new MovieDAO();

        //XEM CHI TIẾT PHIM
        if ("movieDetail".equals(action)) {
            try {
                int movieID = Integer.parseInt(request.getParameter("id"));
                MovieDTO movie = dao.getMovieByID(movieID);
                if (movie != null) {
                    request.setAttribute("MOVIE_DETAIL", movie);
                    model.ReviewDAO reviewDAO = new model.ReviewDAO();                    
                    // Lấy toàn bộ bình luận 
                    request.setAttribute("REVIEW_LIST", reviewDAO.getReviewsByMovieID(movieID));                  
                    // User có quyền Đánh giá không?
                    boolean canReview = false;
                    HttpSession session = request.getSession();
                    UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
                    if (loginUser != null) {
                        canReview = reviewDAO.checkCanReview(loginUser.getUserID(), movieID);
                    }
                    request.setAttribute("CAN_REVIEW", canReview);
                    request.getRequestDispatcher("movie_detail.jsp").forward(request, response);
                } else {
                    // Phim không tồn tại -> về trang chủ
                    response.sendRedirect(request.getContextPath() + "/HomeController");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/HomeController");
            }
            return;
        } else if ("showtimes".equals(action)) {
            ShowtimeDAO showtimes = new ShowtimeDAO();
            request.setAttribute("LIST_SHOWTIME", showtimes.getAllShowtimes());
            request.getRequestDispatcher("showtimes.jsp").forward(request, response);
            return;
        }

        // Thanh Search Movie và Load List Movie
        String searchKeyword = request.getParameter("search");
        ArrayList<MovieDTO> list;

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            list = dao.searchMovies(searchKeyword);
            request.setAttribute("SEARCH_KEYWORD", searchKeyword);
        } else {
            list = dao.getAllMovie();
        }
        request.setAttribute("LIST_MOVIE", list);

        HttpSession session = request.getSession();
        Object user = session.getAttribute("LOGIN_USER");

        String url = "";
        if (user != null) {
            url = "welcome.jsp";
        } else {
            url = "index.jsp";
        }

        request.getRequestDispatcher(url).forward(request, response);
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

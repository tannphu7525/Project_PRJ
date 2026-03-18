package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.ReviewDAO;
import model.UserDTO;

@WebServlet(name = "ReviewController", urlPatterns = {"/ReviewController"})
public class ReviewController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
        
        // Nếu bị mất session (Chưa đăng nhập) thì đá về Login
        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int movieID = Integer.parseInt(request.getParameter("movieID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            ReviewDAO reviewDAO = new ReviewDAO();           
            // Bảo mật lớp 2: Check lại thực sự được phép rate không
            if (reviewDAO.checkCanReview(loginUser.getUserID(), movieID)) {
                reviewDAO.insertReview(loginUser.getUserID(), movieID, rating, comment);
            }
            
            // Load lại trang Chi tiết phim để thấy comment
            response.sendRedirect("HomeController?action=movieDetail&id=" + movieID);      
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("HomeController");
        }
    }
}
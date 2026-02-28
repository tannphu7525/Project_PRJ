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
import javax.servlet.http.HttpSession;
import model.MovieDAO;
import model.MovieDTO;
import model.UserDTO;

@WebServlet(name="HomeController", urlPatterns={"/HomeController"})
public class HomeController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. Luôn luôn lấy danh sách phim trước (Vì trang nào cũng cần hiện phim)
        MovieDAO dao = new MovieDAO();
        ArrayList<MovieDTO> list = dao.getAllMovie();
        request.setAttribute("LIST_MOVIE", list);

        // 2. Kiểm tra Session để biết đã đăng nhập hay chưa
        HttpSession session = request.getSession();
        Object user = session.getAttribute("LOGIN_USER"); // Lấy user từ session

        String url = "";

        if (user != null) {
            // TRƯỜNG HỢP: ĐÃ ĐĂNG NHẬP
            // Chuyển sang trang welcome.jsp (Giao diện cho thành viên)
            url = "welcome.jsp";
        } else {
            // TRƯỜNG HỢP: CHƯA ĐĂNG NHẬP (KHÁCH)
            // Chuyển sang trang index.jsp (Giao diện có nút Đăng nhập/Đăng ký)
            url = "index.jsp";
        }
        
        // 3. Chuyển hướng đến trang đích đã chọn
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
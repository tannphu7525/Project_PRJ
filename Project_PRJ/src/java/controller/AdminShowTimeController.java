/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.MovieDAO;
import model.RoomDAO;
import model.ShowtimeDAO;
import model.ShowtimeDTO;

@WebServlet(name="AdminShowtimeController", urlPatterns={"/AdminShowtimeController"})
public class AdminShowTimeController extends HttpServlet {

    private static final String ADMIN_SHOWTIME_PAGE = "admin_showtime.jsp";    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");  
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");        
        
        String subAction = request.getParameter("subAction");
        String url = ADMIN_SHOWTIME_PAGE;
        
        ShowtimeDAO showTimeDAO = new ShowtimeDAO();
        MovieDAO movieDAO = new MovieDAO();
        RoomDAO roomDAO = new RoomDAO();
        
        try {
            if (subAction == null || subAction.isEmpty() || subAction.equals("list")) {
                request.setAttribute("SHOWTIME_LIST", showTimeDAO.getAllShowtimes());
                request.setAttribute("MOVIE_LIST", movieDAO.getActiveMovie());
                request.setAttribute("ROOM_LIST", roomDAO.getAllActiveRoom());
            } else if (subAction.equals("add")) {
                int movieID = Integer.parseInt(request.getParameter("movieID"));
                int roomID = Integer.parseInt(request.getParameter("roomID"));
                
                String showDate = request.getParameter("showDate");
                String startTime = request.getParameter("startTime");
                double price = 0;
                try {
                    price = Double.parseDouble(request.getParameter("price"));
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
                boolean status = request.getParameter("status") != null;
                
                ShowtimeDTO newShowtime = new ShowtimeDTO(movieID, movieID, roomID, showDate, startTime, startTime, price, status, startTime, showDate, startTime);
                
                boolean checkAdd = showTimeDAO.insertShowtimes(newShowtime);
                if (checkAdd) {
                    request.setAttribute("msg", "Tạo Lịch chiếu thành công!");
                } else {
                    request.setAttribute("msg", "Tạo Lịch chiếu thất bại!");
                }  
                
                // Sau khi xong thì load lại danh sách
                request.setAttribute("SHOWTIME_LIST", showTimeDAO.getAllShowtimes());
                request.setAttribute("MOVIE_LIST", movieDAO.getActiveMovie());
                request.setAttribute("ROOM_LIST", roomDAO.getAllActiveRoom());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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

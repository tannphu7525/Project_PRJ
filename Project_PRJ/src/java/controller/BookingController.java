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
import model.SeatDAO;
import model.SeatDTO;

@WebServlet(name = "BookingController", urlPatterns = {"/BookingController"})
public class BookingController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");
            if (action == null || action.equals("loadSeats")) {
                int showtimeID = Integer.parseInt(request.getParameter("showtimeID"));
                int roomID = Integer.parseInt(request.getParameter("roomID"));

                SeatDAO seatDAO = new SeatDAO();
                ArrayList<SeatDTO> seatList = seatDAO.getSeatsByShowtime(roomID, showtimeID);
                request.setAttribute("SEAT_LIST", seatList);

                // Ném thêm 2 cái ID này sang JSP để lát nữa khách bấm "Thanh toán" mình còn biết là suất nào
                request.setAttribute("CURRENT_SHOWTIME_ID", showtimeID);
                request.setAttribute("CURRENT_ROOM_ID", roomID);
                request.getRequestDispatcher("seat_map.jsp").forward(request, response);
            } // Luồng 2: Xử lý khi khách bấm nút "Đặt vé" (Sẽ làm ở bước sau)
            else if (action.equals("checkout")) {
                // ... Xử lý Transaction thanh toán sẽ nằm ở đây
            }

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
        return "Short description";
    }// </editor-fold>

}

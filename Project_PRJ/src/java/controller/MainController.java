package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "index.jsp";
    private static final String LOGIN_CONTROLLER = "AuthController";
    private static final String LOGOUT_CONTROLLER = "AuthController";
    private static final String REGISTER_CONTROLLER = "AuthController";
    private static final String ADMIN_MOVIE_CONTROLLER = "AdminController";
    private static final String ADMIN_SHOWTIME_CONTROLLER = "AdminController";
    private static final String ADMIN_VOUCHER_CONTROLLER = "AdminController";
    private static final String ADMIN_CINEMAS_CONTROLLER = "AdminController";
    private static final String ADMIN_ROOM_CONTROLLER = "AdminController";
    private static final String ADMIN_USER_CONTROLLER = "AdminController";
    private static final String ADMIN_BOOKING_CONTROLLER = "AdminController";
    private static final String ADMIN_REVIEW_CONTROLLER = "AdminController";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty() || action.equals("home")) {
            request.getRequestDispatcher("HomeController").forward(request, response);
            return;
        }

        String url = LOGIN_PAGE;
        switch (action) {
            case "login":
                url = LOGIN_CONTROLLER;
                break;
            case "logout":
                url = LOGOUT_CONTROLLER;
                break;
            case "register":
                url = REGISTER_CONTROLLER;
                break;
            case "verifyRegisterOTP":
                url = REGISTER_CONTROLLER;
                break;
            case "resendOTP":
                url = REGISTER_CONTROLLER;
                break;
            case "adminUser":
                url = ADMIN_USER_CONTROLLER;
                break;
            case "adminMovie":
                url = ADMIN_MOVIE_CONTROLLER;
                break;
            case "adminShowtime":
                url = ADMIN_SHOWTIME_CONTROLLER;
                break;
            case "adminVoucher":
                url = ADMIN_VOUCHER_CONTROLLER;
                break;
            case "adminCinema":
                url = ADMIN_CINEMAS_CONTROLLER;
                break;
            case "adminRoom":
                url = ADMIN_ROOM_CONTROLLER;
                break;
            case "adminBooking":
                url = ADMIN_BOOKING_CONTROLLER;
                break;
            case "adminReview":
                url = ADMIN_REVIEW_CONTROLLER;
                break;
            case "checkvoucher":
                url = "VoucherController";
                break;
            default:
                url = LOGIN_PAGE;
                System.err.println("Action không xác định: " + action);
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Main Controller";
    }
}

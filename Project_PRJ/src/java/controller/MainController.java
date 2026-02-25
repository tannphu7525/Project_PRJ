package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "MainController", urlPatterns = { "/MainController" })
public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";
    private static final String LOGIN_CONTROLLER = "LoginController";
    private static final String LOGOUT_CONTROLLER = "LogoutController";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
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
            default:
                url = LOGIN_PAGE;
                System.err.println("[MainController] Action không xác định: " + action);
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // GET → hiển thị trang login
        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Main Controller";
    }
}

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
import model.UserDAO;
import model.UserDTO;

@WebServlet(name = "RegisterController", urlPatterns = {"/RegisterController"})
public class RegisterController extends HttpServlet {

    private static final String ERROR_PAGE = "register.jsp";
    private static final String SUCCESS_PAGE = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String confirmpassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");

        String url = ERROR_PAGE;
        String msg = "";

        try {
            if (!password.equals(confirmpassword)) {
                msg = "Mật khẩu không trùng khớp!";
                request.setAttribute("msg", msg);
            } else {
                UserDAO dao = new UserDAO();
                if (dao.checkDuplicateUsername(username)) {
                    msg = "Username này đã được sử dụng. Vui lòng chọn Username khác";
                    request.setAttribute("msg", msg);
                } else if (dao.checkDuplicateEmail(email)) {
                    msg = "Email này đã được sử dụng để đăng ký tài khoản khác!";
                    request.setAttribute("msg", msg);
                } else {
                    UserDTO newUser = new UserDTO(0, username, password, fullName, "CUSTOMER", true, email);
                    boolean isSuccess = dao.registerUser(newUser);

                    if (isSuccess) {
                        msg = "Đăng ký thành công! Vui lòng đăng nhập.";
                        request.setAttribute("msg", msg);
                        url = SUCCESS_PAGE;
                    } else {
                        msg = "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại.";
                        request.setAttribute("msg", msg);
                    }
                }
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

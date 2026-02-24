/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDAO;
import model.UserDTO;

@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {
    
    private static final String ERROR_PAGE = "error.jsp";
    private static final String ADMIN_PAGE = "admin.jsp";
    private static final String USER_PAGE = "index.jsp";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String txtUsername = request.getParameter("username");
        String txtPassword = request.getParameter("password");
        String checkRemember = request.getParameter("remember");
        
        String url = ERROR_PAGE;
        String msg = "";
        
        if (txtUsername == null || txtUsername.trim().isEmpty() ||  txtPassword == null || txtPassword.trim().isEmpty()) {
            msg = "Vui lòng nhập đầy đủ thông tin Username và Password";
            request.setAttribute("msg", msg);
        } else {
            UserDAO udao = new UserDAO();
            UserDTO user = udao.login(txtUsername, txtPassword);
            if (user == null) {
                msg = "Username hoặc Password không đúng";
                request.setAttribute("msg", msg);
            } else {
                if (!user.isStatus()) {
                    msg = "Tài khoản bị khóa";
                    request.setAttribute("messEr", msg);
                } else {
                    //Session
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    
                    //Cookie
                    Cookie userCookie = new Cookie("c_user", txtUsername);
                    Cookie passwordCookie = new Cookie("c_password", txtPassword);
                    
                    if (checkRemember.equals("ON")) {
                        userCookie.setMaxAge(60 * 60 * 24 * 7);
                        passwordCookie.setMaxAge(60 * 60 * 24 * 7);
                    } else {
                        userCookie.setMaxAge(0);
                        passwordCookie.setMaxAge(0);                        
                    }
                    response.addCookie(userCookie);
                    response.addCookie(passwordCookie);
                    
                    if (user.getRole().equalsIgnoreCase("admin")) {
                        url = ADMIN_PAGE;
                    }else {
                        url = USER_PAGE;
                    }
                }
            }
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
    }// </editor-fold>

}

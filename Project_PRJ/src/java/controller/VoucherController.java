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
import model.VoucherDAO;
import model.VoucherDTO;

@WebServlet(name="VoucherController", urlPatterns={"/VoucherController"})
public class VoucherController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String voucherCode = request.getParameter("voucherCode");
        
        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            out.print("false|0|Vui lòng nhập mã!");
            return;
        }
        
        VoucherDAO voucherDAO = new VoucherDAO();
        VoucherDTO voucher = voucherDAO.getValidVoucher(voucherCode);
        
        if (voucher != null) {
            out.print("true|" + voucher.getDiscountPercent() + "|Áp dụng thành công, giảm " + voucher.getDiscountPercent() + "%");
        }else{
            out.print("false|0|Mã không hợp lệ hoặc đã hết hạn!");
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

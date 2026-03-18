/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.VoucherController to edit this template
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

/**
 *
 * @author Cuong
 */
public class VoucherController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String voucherCode = request.getParameter("voucherCode");

        // 2. NẾU ĐỂ TRỐNG MÀ BẤM
        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            out.print("false|0|Vui lòng nhập mã!");
            return;
        }

        // 3. XUỐNG DB KIỂM TRA MÃ
        VoucherDAO voucherDAO = new VoucherDAO();
        VoucherDTO voucher = voucherDAO.getValidVoucher(voucherCode.trim().toUpperCase());

        // 4. TRẢ KẾT QUẢ CHO JAVASCRIPT
        if (voucher != null) {
            out.print("true|" + voucher.getDiscountPercent() + "|Áp dụng thành công, giảm " + voucher.getDiscountPercent() + "%");
        } else {
            out.print("false|0|Mã không hợp lệ, đã hết lượt hoặc hết hạn!");
        
    }
}

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
/**
 * Handles the HTTP <code>GET</code> method.
 *
 * @param request servlet request
 * @param response servlet response
 * @throws ServletException if a servlet-specific error occurs
 * @throws IOException if an I/O error occurs
 */
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

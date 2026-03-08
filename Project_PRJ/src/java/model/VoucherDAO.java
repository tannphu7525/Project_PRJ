/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBUtils;

/**
 *
 * @author admin
 */
public class VoucherDAO {

    private static final String GET_VALID_VOUCHER = "SELECT *\n"
            + "FROM Vouchers \n"
            + "WHERE VoucherCode = ? \n"
            + "AND Status = 1 \n"
            + "AND Quantity > 0 \n"
            + "AND ExpiryDate >= CAST(GETDATE() AS DATE)";
    private static final String DESC_VOUCHER_QUANTITY = "UPDATE Vouchers SET Quantity = Quantity - 1 WHERE VoucherCode = ? AND Quantity > 0";
    public VoucherDTO getValidVoucher(String voucherCode) {
        VoucherDTO voucher = null;
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(GET_VALID_VOUCHER)) {
            stm.setString(1, voucherCode);
            try ( ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    voucher = new VoucherDTO(
                            rs.getInt("VoucherID"),
                            rs.getString("VoucherCode"),
                            rs.getInt("DiscountPercent"),
                            rs.getInt("Quantity"),
                            rs.getString("ExpiryDate"),
                            rs.getBoolean("Status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return voucher;
    }
    // 2. Hàm trừ số lượng Voucher đi 1 (Gọi hàm này KHI VÀ CHỈ KHI thanh toán thành công)
    public boolean decreaseVoucherQuantity(String voucherCode) {
        boolean isUpdated = false;

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(DESC_VOUCHER_QUANTITY)) {

            stm.setString(1, voucherCode);
            int rs = stm.executeUpdate();
            if (rs > 0) isUpdated = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isUpdated;
    }
}

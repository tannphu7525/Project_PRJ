package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import util.DBUtils;

public class VoucherDAO {

    // ==========================================
    // CÁC HÀM DÀNH CHO KHÁCH HÀNG (MUA VÉ)
    // ==========================================
    
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
            try (ResultSet rs = stm.executeQuery()) {
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

    // ==========================================
    // CÁC HÀM DÀNH CHO ADMIN (QUẢN LÝ VOUCHER)
    // ==========================================

    // 1. Lấy toàn bộ danh sách Voucher (Cả hết hạn lẫn chưa hết hạn)
    public ArrayList<VoucherDTO> getAllVouchers() {
        ArrayList<VoucherDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers ORDER BY VoucherID DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                list.add(new VoucherDTO(
                        rs.getInt("VoucherID"),
                        rs.getString("VoucherCode"),
                        rs.getInt("DiscountPercent"),
                        rs.getInt("Quantity"),
                        rs.getString("ExpiryDate"),
                        rs.getBoolean("Status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy thông tin 1 Voucher dựa vào Mã Code (Để đưa lên form Sửa)
    public VoucherDTO getVoucherByCode(String voucherCode) {
        VoucherDTO voucher = null;
        String sql = "SELECT * FROM Vouchers WHERE VoucherCode = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, voucherCode);
            try (ResultSet rs = stm.executeQuery()) {
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

    // 3. Thêm một Voucher mới
    public boolean insertVoucher(VoucherDTO v) {
        String sql = "INSERT INTO Vouchers (VoucherCode, DiscountPercent, Quantity, ExpiryDate, Status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, v.getVoucherCode());
            stm.setInt(2, v.getDiscountPercent());
            stm.setInt(3, v.getQuantity());
            stm.setString(4, v.getExpiryDate());
            stm.setBoolean(5, v.isStatus());
            
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Cập nhật Voucher
    public boolean updateVoucher(VoucherDTO v) {
        String sql = "UPDATE Vouchers SET DiscountPercent = ?, Quantity = ?, ExpiryDate = ?, Status = ? WHERE VoucherCode = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, v.getDiscountPercent());
            stm.setInt(2, v.getQuantity());
            stm.setString(3, v.getExpiryDate());
            stm.setBoolean(4, v.isStatus());
            stm.setString(5, v.getVoucherCode());
            
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Xóa Voucher
    public boolean deleteVoucher(String voucherCode) {
        String sql = "DELETE FROM Vouchers WHERE VoucherCode = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, voucherCode);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
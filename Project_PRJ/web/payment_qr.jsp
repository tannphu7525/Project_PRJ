<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thanh toán vé</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; background-color: #f4f4f4; padding-top: 50px; }
        .qr-container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); display: inline-block; }
        .btn-confirm { display: inline-block; margin-top: 20px; padding: 12px 25px; background-color: #E50914; color: white; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .btn-confirm:hover { background-color: #b20710; }
    </style>
</head>
<body>
    <div class="qr-container">
        <h2 style="color: #333;">Quét mã QR để thanh toán</h2>
        <p>Sử dụng App ngân hàng để quét mã. Thông tin sẽ được điền tự động.</p>
        
        <img src="${QR_URL}" alt="Mã QR Thanh Toán" style="width: 300px; height: 300px; border: 1px solid #ddd; border-radius: 8px;">
        
        <h3>Tổng tiền: <span style="color: #E50914;">${TOTAL_AMOUNT_STR} VNĐ</span></h3>
        <p>Mã đơn hàng: <b>${ORDER_INFO}</b></p>

        <br>
        <a href="BookingController?action=confirm_qr" class="btn-confirm">Tôi đã chuyển khoản thành công</a>
    </div>
</body>
</html>
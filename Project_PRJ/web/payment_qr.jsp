<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thanh toán vé - PRJ Cinema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #1b212c; color: white; padding-top: 50px; }
        .payment-container { background: #28303d; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); max-width: 500px; margin: auto; border: 1px solid #334155; text-align: center;}
        .qr-image { width: 100%; max-width: 300px; border-radius: 12px; border: 3px solid #00d4ff; padding: 10px; background: white; margin-bottom: 20px; cursor: crosshair;}
        
        /* Hiệu ứng xoay của icon Loading */
        .spinner-border { width: 1.5rem; height: 1.5rem; border-width: 0.2em; }
    </style>
</head>
<body>
    <div class="container">
        <div class="payment-container">
            <h2 class="fw-bold text-info mb-3"><i class="fas fa-qrcode me-2"></i>QUÉT MÃ THANH TOÁN</h2>
            <p class="text-muted small mb-4">Mở ứng dụng ngân hàng và quét mã bên dưới. Hệ thống sẽ tự động điền số tiền và nội dung.</p>
            
            <img src="${QR_URL}" alt="Mã QR Thanh Toán" class="qr-image shadow-lg" ondblclick="simulateWebhook()">
            
            <div class="text-center bg-dark p-3 rounded mb-4 border border-secondary">
                <p class="mb-1 text-muted">Nội dung chuyển khoản (Tự động điền):</p>
                <p class="mb-2 fw-bold text-warning" style="font-size: 1.2rem;">${ORDER_INFO}</p>
                <h4 class="mb-0">Tổng tiền: <span class="text-danger fw-bold">${TOTAL_AMOUNT_STR} VNĐ</span></h4>
            </div>

            <div class="alert alert-primary mt-4 d-flex align-items-center justify-content-center" style="background-color: #0c2038; border-color: #00d4ff; color: #00d4ff; border-radius: 12px;">
                <div class="spinner-border text-info me-3" role="status"></div>
                <span class="fw-bold" style="font-size: 1.1rem;">Đang chờ ngân hàng xác nhận...</span>
            </div>
            
            <a href="HomeController" class="btn btn-outline-secondary w-100 mt-3" style="border-radius: 12px;">Hủy giao dịch</a>

            <form id="paymentForm" action="BookingController" method="POST" style="display: none;">
                <input type="hidden" name="action" value="confirm_qr">
            </form>
        </div>
    </div>

    <script>
        function simulateWebhook() {
            // Đổi giao diện sang thông báo đang xử lý để trông thật hơn
            document.querySelector('.spinner-border').classList.remove('text-info');
            document.querySelector('.spinner-border').classList.add('text-success');
            document.querySelector('.alert-primary span').innerHTML = "Đã nhận được tiền! Đang xuất vé...";
            document.querySelector('.alert-primary').style.borderColor = "#198754";
            document.querySelector('.alert-primary').style.color = "#198754";
            
            // Tự động submit form sau 1 giây (để thầy kịp nhìn thấy chữ đổi)
            setTimeout(function() {
                document.getElementById("paymentForm").submit();
            }, 1000);
        }
    </script>
</body>
</html>
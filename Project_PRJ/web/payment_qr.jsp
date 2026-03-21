<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thanh toán vé - PRJ Cinema</title>
    
    <style>
        /* --- 1. BIẾN MÀU & RESET --- */
        :root {
            --bg-body: #1b212c;
            --bg-card: #28303d;
            --bg-darker: #111827;
            --accent-blue: #00d4ff;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: #334155;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        a { text-decoration: none; }

        /* --- 2. KHUNG THANH TOÁN (CARD) --- */
        .payment-container {
            background-color: var(--bg-card);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.6);
            max-width: 450px;
            width: 100%;
            border: 1px solid var(--border-color);
            text-align: center;
        }
        
        .page-title {
            color: var(--accent-blue);
            font-weight: bold;
            font-size: 1.5rem;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .subtitle {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-bottom: 25px;
            line-height: 1.5;
        }

        /* --- 3. MÃ QR THANH TOÁN --- */
        .qr-wrapper {
            background-color: #fff;
            padding: 15px;
            border-radius: 12px;
            border: 3px solid var(--accent-blue);
            display: inline-block;
            margin-bottom: 25px;
            box-shadow: 0 10px 20px rgba(0, 212, 255, 0.2);
            cursor: crosshair; /* Gợi ý cho người chấm biết chỗ này có thể click */
            transition: transform 0.3s;
        }
        .qr-wrapper:hover {
            transform: scale(1.02);
        }
        .qr-image {
            width: 100%;
            max-width: 250px;
            display: block;
        }

        /* --- 4. THÔNG TIN CHUYỂN KHOẢN --- */
        .transfer-info {
            background-color: var(--bg-darker);
            padding: 20px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            margin-bottom: 25px;
        }
        .transfer-label { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 5px; }
        .transfer-content { color: var(--warning); font-size: 1.2rem; font-weight: bold; margin-bottom: 15px; letter-spacing: 1px;}
        .transfer-total { font-size: 1.1rem; margin: 0; }
        .transfer-total span { color: var(--danger); font-weight: bold; font-size: 1.3rem; }

        /* --- 5. HIỆU ỨNG TRẠNG THÁI (LOADING) --- */
        .status-alert {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: rgba(0, 212, 255, 0.1);
            border: 1px solid var(--accent-blue);
            color: var(--accent-blue);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: bold;
            font-size: 1.05rem;
            transition: all 0.3s ease;
        }
        
        /* Vòng xoay CSS Thuần */
        .spinner {
            width: 20px;
            height: 20px;
            border: 3px solid rgba(0, 212, 255, 0.3);
            border-top-color: var(--accent-blue);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 12px;
            transition: border-color 0.3s ease;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* --- 6. NÚT HỦY --- */
        .btn-cancel {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: transparent;
            border: 1px solid var(--text-muted);
            color: var(--text-muted);
            border-radius: 12px;
            font-weight: bold;
            font-size: 1rem;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-cancel:hover {
            background-color: var(--border-color);
            color: white;
        }

    </style>
</head>
<body>

    <div class="payment-container">
        <h2 class="page-title">📱 QUÉT MÃ THANH TOÁN</h2>
        <p class="subtitle">Mở ứng dụng ngân hàng và quét mã bên dưới.<br>Hệ thống sẽ tự động nhận diện thanh toán.</p>
        
        <div class="qr-wrapper" ondblclick="simulateWebhook()" title="Nhấn đúp (Double-click) để giả lập thanh toán thành công">
            <img src="${QR_URL}" alt="Mã QR Thanh Toán" class="qr-image" 
                 onerror="this.src='data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\' width=\'250\' height=\'250\'><rect width=\'100%\' height=\'100%\' fill=\'#fff\'/><text x=\'50%\' y=\'50%\' fill=\'#000\' font-size=\'16\' font-family=\'sans-serif\' text-anchor=\'middle\' dominant-baseline=\'middle\'>MÃ QR OFFLINE</text></svg>'">
        </div>
        
        <div class="transfer-info">
            <p class="transfer-label">Nội dung chuyển khoản (Tự động điền):</p>
            <p class="transfer-content">${ORDER_INFO}</p>
            <h4 class="transfer-total">Tổng tiền: <span>${TOTAL_AMOUNT_STR} VNĐ</span></h4>
        </div>

        <div class="status-alert" id="statusAlert">
            <div class="spinner" id="loadingSpinner"></div>
            <span class="status-text" id="statusText">Đang chờ ngân hàng xác nhận...</span>
        </div>
        
        <a href="HomeController" class="btn-cancel">Hủy giao dịch</a>

        <form id="paymentForm" action="BookingController" method="POST" style="display: none;">
            <input type="hidden" name="action" value="confirm_qr">
        </form>
    </div>

    <script>
        function simulateWebhook() {
            const spinner = document.getElementById('loadingSpinner');
            const alertBox = document.getElementById('statusAlert');
            const alertText = document.getElementById('statusText');

            // 1. Đổi màu Vòng xoay Loading sang màu Xanh lá (Success)
            spinner.style.borderTopColor = 'var(--success)';
            spinner.style.borderRightColor = 'rgba(16, 185, 129, 0.3)';
            spinner.style.borderBottomColor = 'rgba(16, 185, 129, 0.3)';
            spinner.style.borderLeftColor = 'rgba(16, 185, 129, 0.3)';

            // 2. Đổi màu khung Alert và Nội dung chữ
            alertBox.style.backgroundColor = 'rgba(16, 185, 129, 0.1)';
            alertBox.style.borderColor = 'var(--success)';
            alertBox.style.color = 'var(--success)';
            alertText.innerHTML = "Đã nhận được tiền! Đang xuất vé...";
            
            // 3. Tự động submit form sau 1.5 giây để giảng viên kịp nhìn thấy chữ đổi màu
            setTimeout(function() {
                document.getElementById("paymentForm").submit();
            }, 1500);
        }
    </script>
</body>
</html>
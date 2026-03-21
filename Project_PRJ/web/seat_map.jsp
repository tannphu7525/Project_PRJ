<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Sơ Đồ Ghế Ngồi - PRJ Cinema</title>

        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #111827;
                --bg-card: #1f2937;
                --bg-darker: #0b0f19;
                --accent-blue: #0ea5e9;
                --accent-hover: #0284c7;
                --accent-red: #E50914;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --border-color: #334155;
                --success: #10b981;
                --warning: #f59e0b;
                --danger: #ef4444;
            }
            * { box-sizing: border-box; margin: 0; padding: 0; }
            body {
                background-color: var(--bg-body);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                color: var(--text-main);
                line-height: 1.6;
                padding-bottom: 50px;
            }
            a { text-decoration: none; }

            /* --- 2. THANH ĐIỀU HƯỚNG (NAVBAR) --- */
            .navbar {
                background-color: var(--bg-darker);
                box-shadow: 0 4px 15px rgba(0,0,0,0.5);
                border-bottom: 1px solid var(--border-color);
                position: sticky;
                top: 0;
                z-index: 1000;
                margin-bottom: 40px;
            }
            .navbar-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 20px;
                max-width: 1200px;
                margin: 0 auto;
            }
            .navbar-brand {
                color: var(--accent-blue);
                font-size: 1.5rem;
                font-weight: bold;
                letter-spacing: 1px;
                text-transform: uppercase;
            }
            .btn-outline-light {
                border: 1px solid var(--text-muted);
                color: var(--text-main);
                padding: 8px 20px;
                border-radius: 20px;
                font-weight: bold;
                transition: 0.3s;
                font-size: 0.9rem;
            }
            .btn-outline-light:hover { background-color: var(--text-muted); color: var(--bg-darker); }

            /* --- 3. BỐ CỤC CHÍNH (LAYOUT THAY BOOTSTRAP) --- */
            .container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
            
            .booking-layout {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 30px;
                align-items: flex-start;
            }
            @media (max-width: 992px) {
                .booking-layout { grid-template-columns: 1fr; }
            }

            /* --- 4. CỘT TRÁI: SƠ ĐỒ GHẾ --- */
            .cinema-container {
                background-color: var(--bg-card);
                border-radius: 12px;
                border: 1px solid var(--border-color);
                padding: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                overflow-x: auto; /* Cho phép cuộn ngang nếu màn hình quá nhỏ */
            }
            .page-title {
                color: var(--accent-blue);
                font-weight: bold;
                text-transform: uppercase;
                border-bottom: 2px solid var(--border-color);
                padding-bottom: 15px;
                margin-bottom: 30px;
                text-align: center;
                font-size: 1.6rem;
            }

            /* Chú thích ghế */
            .legend {
                display: flex;
                justify-content: center;
                gap: 20px;
                margin-bottom: 40px;
                flex-wrap: wrap;
            }
            .legend-item { display: flex; align-items: center; gap: 8px; font-weight: 500; font-size: 0.95rem; }
            .legend-box { width: 20px; height: 20px; border-radius: 4px; box-shadow: 0 2px 5px rgba(0,0,0,0.5); }

            /* Màn hình */
            .screen {
                background-color: #fff;
                height: 70px;
                width: 90%;
                max-width: 600px;
                margin: 0 auto 60px auto;
                transform: rotateX(-45deg);
                box-shadow: 0 15px 40px rgba(255, 255, 255, 0.3);
                border-radius: 50% 50% 0 0 / 100% 100% 0 0;
                color: #111;
                font-weight: 900;
                font-size: 20px;
                line-height: 70px;
                text-align: center;
                letter-spacing: 5px;
            }

            /* CSS Lưới cho ghế */
            .seat-wrapper { text-align: center; }
            .seat-container {
                display: inline-grid;
                grid-template-columns: repeat(10, 45px);
                gap: 12px;
                justify-content: center;
                position: relative;
            }

            /* Khung Best View */
            .sweet-spot-frame {
                position: absolute;
                grid-row: 4 / 8;
                grid-column: 3 / 9;
                border: 2px dashed var(--accent-blue);
                border-radius: 8px;
                background-color: rgba(14, 165, 233, 0.05);
                pointer-events: none;
                z-index: 0;
                top: -6px; bottom: -6px; left: -6px; right: -6px;
            }
            .sweet-spot-frame::after {
                content: 'BEST VIEW';
                position: absolute;
                top: -12px;
                left: 50%;
                transform: translateX(-50%);
                background: var(--bg-card);
                color: var(--accent-blue);
                padding: 2px 12px;
                font-size: 11px;
                font-weight: bold;
                border: 1px solid var(--accent-blue);
                border-radius: 10px;
                letter-spacing: 1px;
            }

            /* Thiết kế ghế */
            .seat {
                width: 45px;
                height: 40px;
                border-radius: 6px 6px 2px 2px;
                font-size: 13px;
                font-weight: bold;
                line-height: 40px;
                cursor: pointer;
                transition: all 0.2s ease-in-out;
                position: relative;
                z-index: 1;
                box-shadow: 0 4px 6px rgba(0,0,0,0.3);
                text-align: center;
                user-select: none;
            }
            .seat.normal { background-color: #475569; border-bottom: 5px solid #334155; color: #fff; }
            .seat.vip { background-color: var(--warning); color: #000; border-bottom: 5px solid #d97706; }
            .seat.booked { background-color: #991b1b; color: #fff; border-bottom: 5px solid #7f1d1d; cursor: not-allowed; opacity: 0.7; }
            .seat.couple { background-color: #ec4899; color: #000; border-bottom: 5px solid #be185d; grid-column: span 2; width: 100%; }
            
            .seat.selected {
                background-color: var(--success) !important;
                color: #fff;
                border-bottom: 5px solid #047857;
                transform: translateY(-5px) scale(1.1);
                box-shadow: 0 10px 15px rgba(16, 185, 129, 0.4);
            }
            .seat:hover:not(.booked) { transform: translateY(-3px) scale(1.05); }

            /* --- 5. CỘT PHẢI: BẢNG THANH TOÁN --- */
            .checkout-panel {
                background: var(--bg-darker);
                padding: 25px;
                border-radius: 12px;
                border: 1px solid var(--border-color);
                position: sticky;
                top: 90px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            }
            .panel-heading {
                color: var(--text-muted);
                font-size: 1rem;
                margin-bottom: 12px;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-weight: bold;
            }
            
            .selected-seats-box {
                background: var(--bg-card);
                padding: 15px;
                border-radius: 8px;
                border: 1px dashed var(--border-color);
                min-height: 60px;
                margin-bottom: 25px;
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                gap: 8px;
            }
            .seat-badge {
                background-color: var(--border-color);
                color: white;
                padding: 5px 12px;
                border-radius: 6px;
                font-size: 0.9rem;
                font-weight: bold;
            }

            /* Box Voucher */
            .voucher-box {
                display: flex;
                gap: 10px;
                margin-bottom: 8px;
            }
            .voucher-box input {
                flex: 1;
                padding: 12px 15px;
                border-radius: 8px;
                border: 1px solid var(--border-color);
                background: var(--bg-card);
                color: var(--warning);
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1px;
                outline: none;
            }
            .voucher-box input:focus { border-color: var(--accent-blue); }
            .voucher-box button {
                padding: 10px 20px;
                border-radius: 8px;
                border: none;
                background: var(--accent-blue);
                color: #fff;
                font-weight: bold;
                cursor: pointer;
                transition: 0.3s;
            }
            .voucher-box button:hover { background: var(--accent-hover); }
            .voucher-msg { font-size: 0.85rem; font-weight: bold; height: 20px; margin-bottom: 15px; }

            /* Tổng tiền */
            .total-price-box {
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid var(--border-color);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .total-label { font-size: 1.2rem; color: var(--text-muted); font-weight: bold; }
            .total-amount {
                font-size: 2rem;
                color: var(--warning);
                font-weight: 900;
                text-shadow: 0 2px 10px rgba(245, 158, 11, 0.3);
            }

            /* Nút thanh toán */
            .btn-checkout {
                background: var(--accent-red);
                color: white;
                border: none;
                padding: 15px;
                font-size: 1.1rem;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                width: 100%;
                margin-top: 25px;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .btn-checkout:hover {
                background: #ff0f1a;
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(229, 9, 20, 0.4);
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="navbar-container">
                <a class="navbar-brand" href="HomeController">PRJ CINEMA</a>
                <a href="HomeController" class="btn-outline-light">← Trở về trang chủ</a>
            </div>
        </nav>

        <div class="container">
            <div class="booking-layout">

                <div class="cinema-container">
                    <h2 class="page-title">🚪 PHÒNG SỐ ${CURRENT_ROOM_ID}</h2>

                    <div class="legend">
                        <div class="legend-item"><div class="legend-box" style="background: #475569;"></div> Thường</div>
                        <div class="legend-item"><div class="legend-box" style="background: var(--warning);"></div> VIP</div>
                        <div class="legend-item"><div class="legend-box" style="background: #ec4899;"></div> Couple</div>
                        <div class="legend-item"><div class="legend-box" style="background: #991b1b;"></div> Đã Bán</div>
                        <div class="legend-item"><div class="legend-box" style="background: var(--success);"></div> Đang Chọn</div>
                    </div>

                    <div class="screen">MÀN HÌNH</div>

                    <div class="seat-wrapper">
                        <div class="seat-container">
                            <div class="sweet-spot-frame"></div>
                            
                            <c:forEach var="seat" items="${SEAT_LIST}">
                                <div class="seat ${seat.booked ? 'booked' : (seat.seatType == 'Couple' ? 'couple' : (seat.seatType == 'VIP' ? 'vip' : 'normal'))}" 
                                     data-seatid="${seat.seatID}" 
                                     data-seatname="${seat.seatName}"
                                     data-seattype="${seat.seatType}" 
                                     onclick="${seat.booked ? '' : 'toggleSeat(this)'}"> 
                                    ${seat.seatName}
                                </div>
                            </c:forEach>
                            
                        </div>
                    </div>
                </div>

                <div class="checkout-panel">

                    <div class="panel-heading">💺 Ghế bạn chọn</div>
                    <div class="selected-seats-box" id="displaySelectedSeats">
                        <span class="text-muted" style="font-size: 0.95rem;">Chưa chọn ghế nào...</span>
                    </div>

                    <div class="panel-heading">🎫 Mã Giảm Giá</div>
                    <div class="voucher-box">
                        <input type="text" id="voucherCodeInput" placeholder="Nhập mã..." oninput="onVoucherInputChange()">
                        <button type="button" onclick="applyVoucher()">ÁP DỤNG</button>
                    </div>
                    <div id="voucherMessage" class="voucher-msg"></div>

                    <div class="total-price-box">
                        <span class="total-label">Tổng Tiền:</span>
                        <span class="total-amount"><span id="displayTotalPrice">0</span> ₫</span>
                    </div>

                    <form action="BookingController" method="POST" id="bookingForm">
                        <input type="hidden" name="action" value="checkout">
                        <input type="hidden" name="showtimeID" value="${CURRENT_SHOWTIME_ID}">
                        <input type="hidden" name="selectedSeats" id="selectedSeatsInput">
                        <input type="hidden" name="totalAmount" id="totalAmountInput">
                        <input type="hidden" name="appliedVoucherCode" id="appliedVoucherInput"> 

                        <button type="button" class="btn-checkout" onclick="submitBooking()">
                            💳 THANH TOÁN NGAY
                        </button>
                    </form>
                </div>

            </div>
        </div>

        <script>
            let selectedSeatIDs = [];
            let selectedSeatNames = [];
            let baseTotalPrice = 0;
            let currentDiscountPercent = 0;

            function updatePriceUI() {
                let finalPrice = baseTotalPrice - (baseTotalPrice * currentDiscountPercent / 100);
                document.getElementById('displayTotalPrice').innerText = finalPrice.toLocaleString('vi-VN');
                document.getElementById('totalAmountInput').value = finalPrice;
            }

            function onVoucherInputChange() {
                let currentInput = document.getElementById("voucherCodeInput").value.trim();
                let appliedCode = document.getElementById('appliedVoucherInput').value;

                if (appliedCode !== "" && currentInput !== appliedCode) {
                    currentDiscountPercent = 0;
                    document.getElementById('appliedVoucherInput').value = "";

                    let msgBox = document.getElementById("voucherMessage");
                    msgBox.style.color = "var(--warning)";
                    msgBox.innerText = "Mã đã gỡ do thay đổi. Vui lòng áp dụng lại!";

                    updatePriceUI();
                }
            }

            function toggleSeat(element) {
                let seatID = element.getAttribute('data-seatid');
                let seatName = element.getAttribute('data-seatname');
                let seatType = element.getAttribute('data-seattype');

                let price = 0;
                if (seatType === 'Couple') price = 150000;
                else if (seatType === 'VIP') price = 100000;
                else price = 70000;

                element.classList.toggle('selected');

                if (element.classList.contains('selected')) {
                    selectedSeatIDs.push(seatID);
                    selectedSeatNames.push(seatName);
                    baseTotalPrice += price;
                } else {
                    selectedSeatIDs = selectedSeatIDs.filter(id => id !== seatID);
                    selectedSeatNames = selectedSeatNames.filter(name => name !== seatName);
                    baseTotalPrice -= price;
                }

                // Cập nhật lại giao diện hiển thị ghế (Không dùng FontAwesome nữa)
                let seatsHtml = "";
                if (selectedSeatNames.length > 0) {
                    selectedSeatNames.forEach(name => {
                        seatsHtml += `<span class="seat-badge">💺 ${name}</span>`;
                    });
                } else {
                    seatsHtml = `<span style="color: #94a3b8; font-size: 0.95rem;">Chưa chọn ghế nào...</span>`;
                }

                document.getElementById('displaySelectedSeats').innerHTML = seatsHtml;
                updatePriceUI();
            }

            function applyVoucher() {
                if (baseTotalPrice === 0) {
                    alert("Vui lòng chọn ghế trước khi áp dụng mã giảm giá!");
                    return;
                }

                let code = document.getElementById("voucherCodeInput").value.trim();
                let msgBox = document.getElementById("voucherMessage");

                if (code === "") {
                    msgBox.style.color = "var(--danger)";
                    msgBox.innerText = "Vui lòng nhập mã!";
                    currentDiscountPercent = 0;
                    document.getElementById('appliedVoucherInput').value = "";
                    updatePriceUI();
                    return;
                }

                msgBox.style.color = "var(--warning)";
                msgBox.innerText = "Đang kiểm tra...";

                fetch('VoucherController?voucherCode=' + code)
                        .then(response => response.text())
                        .then(text => {
                            let dataArray = text.split("|");
                            let isValid = dataArray[0].trim();
                            let discount = parseInt(dataArray[1].trim());
                            let message = dataArray[2].trim();

                            if (isValid === "true") {
                                msgBox.style.color = "var(--success)";
                                msgBox.innerText = message;
                                currentDiscountPercent = discount;
                                document.getElementById('appliedVoucherInput').value = code;
                            } else {
                                msgBox.style.color = "var(--danger)";
                                msgBox.innerText = message;
                                currentDiscountPercent = 0;
                                document.getElementById('appliedVoucherInput').value = "";
                            }
                            updatePriceUI();
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            msgBox.style.color = "var(--danger)";
                            msgBox.innerText = "Lỗi kết nối máy chủ!";
                        });
            }

            function submitBooking() {
                if (selectedSeatIDs.length === 0) {
                    alert("Vui lòng chọn ít nhất 1 ghế trước khi thanh toán!");
                    return;
                }
                document.getElementById('selectedSeatsInput').value = selectedSeatIDs.join(',');
                document.getElementById('bookingForm').submit();
            }
        </script>
    </body>
</html>
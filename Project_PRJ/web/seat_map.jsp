<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Sơ Đồ Ghế Ngồi - PRJ Cinema</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <style>
            :root {
                --bg-body: #111827;
                --bg-card: #1f2937;
                --accent-blue: #00d4ff;
                --accent-red: #E50914;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --border-color: #334155;
            }
            body {
                font-family: 'Roboto', sans-serif;
                background-color: var(--bg-body);
                color: var(--text-main);
                padding-bottom: 50px;
            }

            /* --- NAVBAR ĐỒNG BỘ --- */
            .navbar {
                background-color: #0b0f19;
                box-shadow: 0 4px 15px rgba(0,0,0,0.5);
                border-bottom: 1px solid var(--border-color);
                margin-bottom: 30px;
            }
            .navbar-brand {
                color: var(--accent-blue) !important;
                font-size: 1.5rem;
                letter-spacing: 1px;
            }

            /* --- BỐ CỤC KHUNG CHỨA (CHIA 2 CỘT) --- */
            .cinema-container {
                background-color: var(--bg-card);
                border-radius: 12px;
                border: 1px solid var(--border-color);
                padding: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }
            .page-title {
                color: var(--accent-blue);
                font-weight: bold;
                text-transform: uppercase;
                border-bottom: 2px solid var(--border-color);
                padding-bottom: 15px;
                margin-bottom: 30px;
                text-align: center;
            }

            /* --- SƠ ĐỒ GHẾ NGỒI --- */
            .legend {
                display: flex;
                justify-content: center;
                gap: 25px;
                margin-bottom: 40px;
                flex-wrap: wrap;
            }
            .legend div {
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 500;
                font-size: 0.95rem;
            }
            .box {
                width: 25px;
                height: 25px;
                border-radius: 4px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.5);
            }

            .screen {
                background-color: #fff;
                height: 70px;
                width: 90%;
                margin: 0 auto 60px auto;
                transform: rotateX(-45deg);
                box-shadow: 0 15px 40px rgba(255, 255, 255, 0.3);
                border-radius: 50% 50% 0 0 / 100% 100% 0 0;
                color: #111;
                font-weight: 900;
                font-size: 24px;
                line-height: 70px;
                text-align: center;
                letter-spacing: 5px;
            }

            .seat-wrapper {
                text-align: center;
            }
            .seat-container {
                display: grid;
                grid-template-columns: repeat(10, 45px);
                gap: 12px;
                justify-content: center;
                position: relative;
                display: inline-grid;
            }

            /* Khung Best View */
            .sweet-spot-frame {
                position: absolute;
                grid-row: 4 / 8;
                grid-column: 3 / 9;
                border: 2px dashed var(--accent-blue);
                border-radius: 8px;
                background-color: rgba(0, 212, 255, 0.05);
                pointer-events: none;
                z-index: 0;
                top: -6px;
                bottom: -6px;
                left: -6px;
                right: -6px;
            }
            .sweet-spot-frame::after {
                content: 'BEST VIEW';
                position: absolute;
                top: -14px;
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

            /* Thiết kế từng ghế */
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
            }
            .seat.normal {
                background-color: #475569;
                border-bottom: 5px solid #334155;
                color: #fff;
            }
            .seat.vip {
                background-color: #F59E0B;
                color: #000;
                border-bottom: 5px solid #D97706;
            }
            .seat.booked {
                background-color: #991B1B;
                color: #fff;
                border-bottom: 5px solid #7F1D1D;
                cursor: not-allowed;
                opacity: 0.7;
            }
            .seat.couple {
                background-color: #EC4899;
                color: #000;
                border-bottom: 5px solid #BE185D;
                grid-column: span 2;
                width: 100%;
            }
            .seat.selected {
                background-color: #10B981 !important;
                color: #fff;
                border-bottom: 5px solid #047857;
                transform: translateY(-5px) scale(1.1);
                box-shadow: 0 10px 15px rgba(16, 185, 129, 0.4);
            }

            .seat:hover:not(.booked) {
                transform: translateY(-3px) scale(1.05);
            }

            /* --- KHU VỰC THANH TOÁN (CỘT PHẢI) --- */
            .checkout-panel {
                background: #0f172a;
                padding: 25px;
                border-radius: 12px;
                border: 1px solid var(--border-color);
                position: sticky;
                top: 90px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            }
            .checkout-panel h4 {
                color: var(--text-muted);
                font-size: 1rem;
                margin-bottom: 15px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .selected-seats-box {
                background: #1e293b;
                padding: 15px;
                border-radius: 8px;
                border: 1px dashed #475569;
                min-height: 60px;
                margin-bottom: 20px;
                font-size: 1.1rem;
                font-weight: bold;
                color: #10B981;
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                gap: 5px;
            }
            .seat-badge {
                background-color: #334155;
                color: white;
                padding: 5px 10px;
                border-radius: 6px;
                font-size: 0.9rem;
            }

            /* Giao diện Voucher */
            .voucher-box {
                display: flex;
                gap: 10px;
                margin-bottom: 5px;
            }
            .voucher-box input {
                flex: 1;
                padding: 12px 15px;
                border-radius: 8px;
                border: 1px solid var(--border-color);
                background: #1e293b;
                color: #F59E0B;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .voucher-box input:focus {
                outline: none;
                border-color: var(--accent-blue);
                box-shadow: 0 0 0 2px rgba(0, 212, 255, 0.2);
            }
            .voucher-box button {
                padding: 10px 20px;
                border-radius: 8px;
                border: none;
                background: var(--accent-blue);
                color: #000;
                font-weight: bold;
                cursor: pointer;
                transition: 0.3s;
            }
            .voucher-box button:hover {
                background: #00b8e6;
                transform: translateY(-2px);
            }

            .total-price-box {
                margin-top: 25px;
                padding-top: 20px;
                border-top: 1px solid var(--border-color);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .total-price-box span:first-child {
                font-size: 1.2rem;
                color: var(--text-muted);
                font-weight: bold;
            }
            .total-price-box span:last-child {
                font-size: 2rem;
                color: #F59E0B;
                font-weight: 900;
                text-shadow: 0 2px 10px rgba(245, 158, 11, 0.3);
            }

            .btn-checkout {
                background: var(--accent-red);
                color: white;
                border: none;
                padding: 15px;
                font-size: 1.2rem;
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

        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold" href="HomeController">
                    <i class="fas fa-film me-2"></i>PRJ CINEMA
                </a>
                <div class="d-flex align-items-center">
                    <a href="HomeController" class="btn btn-outline-light btn-sm rounded-pill px-3">
                        <i class="fas fa-arrow-left me-2"></i> Trở về trang chủ
                    </a>
                </div>
            </div>
        </nav>

        <div class="container mb-5">
            <div class="row g-4">

                <div class="col-lg-8">
                    <div class="cinema-container">
                        <h2 class="page-title"><i class="fas fa-door-open me-3"></i>PHÒNG SỐ ${CURRENT_ROOM_ID}</h2>

                        <div class="legend">
                            <div><div class="box" style="background: #475569;"></div> Thường</div>
                            <div><div class="box" style="background: #F59E0B;"></div> VIP</div>
                            <div><div class="box" style="background: #EC4899;"></div> Couple</div>
                            <div><div class="box" style="background: #991B1B;"></div> Đã Bán</div>
                            <div><div class="box" style="background: #10B981;"></div> Đang Chọn</div>
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
                </div>

                <div class="col-lg-4">
                    <div class="checkout-panel">

                        <h4><i class="fas fa-couch me-2"></i>Ghế bạn chọn</h4>
                        <div class="selected-seats-box" id="displaySelectedSeats">
                            <span class="text-muted" style="font-size: 0.95rem; font-weight: normal;">Chưa chọn ghế nào...</span>
                        </div>

                        <h4><i class="fas fa-ticket-alt me-2"></i>Mã Giảm Giá</h4>
                        <div class="voucher-box">
                            <input type="text" id="voucherCodeInput" placeholder="Nhập mã..." oninput="onVoucherInputChange()">
                            <button type="button" onclick="applyVoucher()">ÁP DỤNG</button>
                        </div>
                        <div id="voucherMessage" style="font-size: 13px; font-weight: bold; height: 18px; margin-bottom: 5px;"></div>

                        <div class="total-price-box">
                            <span>Tổng Tiền:</span>
                            <span><span id="displayTotalPrice">0</span> ₫</span>
                        </div>

                        <form action="BookingController" method="POST" id="bookingForm">
                            <input type="hidden" name="action" value="checkout">
                            <input type="hidden" name="showtimeID" value="${CURRENT_SHOWTIME_ID}">
                            <input type="hidden" name="selectedSeats" id="selectedSeatsInput">
                            <input type="hidden" name="totalAmount" id="totalAmountInput">
                            <input type="hidden" name="appliedVoucherCode" id="appliedVoucherInput"> 

                            <button type="button" class="btn-checkout" onclick="submitBooking()">
                                <i class="fas fa-credit-card me-2"></i> THANH TOÁN NGAY
                            </button>
                        </form>
                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

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
                                        msgBox.style.color = "#F59E0B";
                                        msgBox.innerText = "Mã đã gỡ do thay đổi. Vui lòng áp dụng lại!";

                                        updatePriceUI();
                                    }
                                }

                                function toggleSeat(element) {
                                    let seatID = element.getAttribute('data-seatid');
                                    let seatName = element.getAttribute('data-seatname');
                                    let seatType = element.getAttribute('data-seattype');

                                    let price = 0;
                                    if (seatType === 'Couple')
                                        price = 150000;
                                    else if (seatType === 'VIP')
                                        price = 100000;
                                    else
                                        price = 70000;

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

                                    // Cập nhật lại giao diện hiển thị ghế bằng các thẻ Badge cho đẹp
                                    let seatsHtml = "";
                                    if (selectedSeatNames.length > 0) {
                                        selectedSeatNames.forEach(name => {
                                            seatsHtml += `<span class="seat-badge"><i class="fas fa-couch text-warning me-1"></i>${name}</span>`;
                                        });
                                    } else {
                                        seatsHtml = `<span class="text-muted" style="font-size: 0.95rem; font-weight: normal;">Chưa chọn ghế nào...</span>`;
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
                                        msgBox.style.color = "#E50914";
                                        msgBox.innerText = "Vui lòng nhập mã!";
                                        currentDiscountPercent = 0;
                                        document.getElementById('appliedVoucherInput').value = "";
                                        updatePriceUI();
                                        return;
                                    }

                                    msgBox.style.color = "#F59E0B";
                                    msgBox.innerText = "Đang kiểm tra...";

                                    fetch('VoucherController?voucherCode=' + code)
                                            .then(response => response.text())
                                            .then(text => {
                                                let dataArray = text.split("|");
                                                let isValid = dataArray[0].trim();
                                                let discount = parseInt(dataArray[1].trim());
                                                let message = dataArray[2].trim();

                                                if (isValid === "true") {
                                                    msgBox.style.color = "#10B981";
                                                    msgBox.innerText = message;
                                                    currentDiscountPercent = discount;
                                                    document.getElementById('appliedVoucherInput').value = code;
                                                } else {
                                                    msgBox.style.color = "#E50914";
                                                    msgBox.innerText = message;
                                                    currentDiscountPercent = 0;
                                                    document.getElementById('appliedVoucherInput').value = "";
                                                }
                                                updatePriceUI();
                                            })
                                            .catch(error => {
                                                console.error('Error:', error);
                                                msgBox.style.color = "#E50914";
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
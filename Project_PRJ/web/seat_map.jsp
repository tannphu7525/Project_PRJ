<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sơ Đồ Ghế Ngồi - PRJ Cinema</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #222; color: #fff; text-align: center; }
            .legend { margin: 20px 0; display: flex; justify-content: center; gap: 20px; }
            .legend div { display: flex; align-items: center; gap: 5px; }
            .box { width: 20px; height: 20px; border-radius: 4px; }
            .screen {
                background-color: #fff; height: 70px; width: 80%; margin: 20px auto 50px auto;
                transform: rotateX(-45deg); box-shadow: 0 15px 30px rgba(255, 255, 255, 0.4);
                border-radius: 50% 50% 0 0 / 100% 100% 0 0; color: #444; font-weight: bold; font-size: 20px; line-height: 70px;
            }
            .seat-container {
                display: grid; grid-template-columns: repeat(10, 40px); gap: 12px;
                justify-content: center; margin-bottom: 30px; position: relative;
            }
            .sweet-spot-frame {
                position: absolute; grid-row: 4 / 8; grid-column: 3 / 9;
                border: 2px dashed #00FFFF; border-radius: 8px; background-color: rgba(0, 255, 255, 0.05);
                pointer-events: none; z-index: 0; top: -6px; bottom: -6px; left: -6px; right: -6px; 
            }
            .sweet-spot-frame::after {
                content: 'BEST VIEW'; position: absolute; top: -12px; left: 50%; transform: translateX(-50%);
                background: #222; color: #00FFFF; padding: 2px 12px; font-size: 10px; font-weight: bold;
                border: 1px solid #00FFFF; border-radius: 10px; letter-spacing: 1px;
            }
            .seat {
                width: 40px; height: 35px; border-radius: 5px 5px 0 0; font-size: 12px; font-weight: bold;
                line-height: 35px; cursor: pointer; transition: transform 0.2s; position: relative; z-index: 1;
            }
            .seat.normal { background-color: #444; border-bottom: 4px solid #666; }
            .seat.vip { background-color: #FFD700; color: #000; border-bottom: 4px solid #B8860B; }
            .seat.booked { background-color: #E50914; color: #fff; border-bottom: 4px solid #8B0000; cursor: not-allowed; }
            .seat.couple { background-color: #FF69B4; color: #000; border-bottom: 4px solid #C71585; grid-column: span 2; width: 100%; }
            .seat.selected { background-color: #00FF00 !important; color: #000; border-bottom: 4px solid #008000; transform: scale(1.1); }
            .seat:hover:not(.booked) { transform: scale(1.1); }
            .checkout-panel { background: #333; padding: 20px; margin-top: 30px; border-radius: 10px; display: inline-block; text-align: left; min-width: 400px;}
            .btn-checkout { background: #E50914; color: white; border: none; padding: 12px 30px; font-size: 18px; border-radius: 5px; cursor: pointer; font-weight: bold; width: 100%; margin-top: 15px;}
            .btn-checkout:hover { background: #ff0f1a; }
            
            /* CSS Giao diện Voucher */
            .voucher-box { display: flex; gap: 10px; margin-top: 15px; margin-bottom: 5px; }
            .voucher-box input { flex: 1; padding: 10px; border-radius: 5px; border: 1px solid #555; background: #222; color: #FFD700; font-weight: bold; text-transform: uppercase; }
            .voucher-box button { padding: 10px 20px; border-radius: 5px; border: none; background: #00FFFF; color: #000; font-weight: bold; cursor: pointer; }
            .voucher-box button:hover { background: #00cccc; }
        </style>
    </head>
    <body>

        <h2>ĐẶT VÉ PHIM - PHÒNG SỐ ${CURRENT_ROOM_ID}</h2>

        <div class="legend">
            <div><div class="box normal" style="background: #444;"></div> Ghế Thường</div>
            <div><div class="box vip" style="background: #FFD700;"></div> Ghế VIP</div>
            <div><div class="box couple" style="background: #FF69B4;"></div> Ghế Couple</div>
            <div><div class="box booked" style="background: #E50914;"></div> Đã Bán</div>
            <div><div class="box selected" style="background: #00FF00;"></div> Đang Chọn</div>
        </div>

        <div class="screen">MÀN HÌNH</div>

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

        <div class="checkout-panel">
            <h3 style="margin-top: 0;">Ghế bạn chọn: <span id="displaySelectedSeats" style="color:#00FF00;">Chưa chọn ghế nào</span></h3>
            
            <div class="voucher-box">
                <input type="text" id="voucherCodeInput" placeholder="Nhập mã giảm giá..." oninput="onVoucherInputChange()">
                <button type="button" onclick="applyVoucher()">ÁP DỤNG</button>
            </div>
            <div id="voucherMessage" style="font-size: 14px; font-weight: bold; margin-bottom: 15px; height: 20px;"></div>
            
            <h3>Tổng tiền: <span id="displayTotalPrice" style="color:#FFD700;">0</span> VNĐ</h3>

            <form action="BookingController" method="POST" id="bookingForm">
                <input type="hidden" name="action" value="checkout">
                <input type="hidden" name="showtimeID" value="${CURRENT_SHOWTIME_ID}">
                <input type="hidden" name="selectedSeats" id="selectedSeatsInput">
                <input type="hidden" name="totalAmount" id="totalAmountInput">
                
                <input type="hidden" name="appliedVoucherCode" id="appliedVoucherInput"> 
                
                <button type="button" class="btn-checkout" onclick="submitBooking()">TIẾN HÀNH THANH TOÁN</button>
            </form>
        </div>

        <script>
            let selectedSeatIDs = [];
            let selectedSeatNames = [];
            let baseTotalPrice = 0; // Tiền gốc (chưa giảm)
            let currentDiscountPercent = 0; // % Giảm giá hiện tại

            // HÀM 1: Tính toán lại tổng tiền hiển thị (Cập nhật Real-time)
            function updatePriceUI() {
                // Tính tiền = Tiền gốc - (Tiền gốc * % giảm / 100)
                let finalPrice = baseTotalPrice - (baseTotalPrice * currentDiscountPercent / 100);
                
                // Cập nhật lên màn hình
                document.getElementById('displayTotalPrice').innerText = finalPrice.toLocaleString('vi-VN');
                // Gán vào Form ẩn để mang qua Backend
                document.getElementById('totalAmountInput').value = finalPrice;
            }
            
            // Hàm Tự động hủy mã nếu khách hàng xóa hoặc sửa chữ trong ô nhập
            function onVoucherInputChange() {
                let currentInput = document.getElementById("voucherCodeInput").value.trim();
                let appliedCode = document.getElementById('appliedVoucherInput').value;

                // Nếu trước đó đã áp dụng mã (appliedCode khác rỗng)
                // Nhưng bây giờ khách lại sửa/xóa ô text khác đi -> Tự động gỡ mã ngay lập tức
                if (appliedCode !== "" && currentInput !== appliedCode) {
                    currentDiscountPercent = 0; // Trả % giảm về 0
                    document.getElementById('appliedVoucherInput').value = ""; // Xóa mã trong form ẩn
                    
                    let msgBox = document.getElementById("voucherMessage");
                    msgBox.style.color = "#FFD700"; // Màu vàng cảnh báo
                    msgBox.innerText = "Mã giảm giá đã bị gỡ do thay đổi. Vui lòng bấm Áp dụng lại!";
                    
                    // Lập tức tính lại tiền (trả về giá gốc)
                    updatePriceUI();
                }
            }
            
            // HÀM 2: Click chọn ghế
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

                document.getElementById('displaySelectedSeats').innerText =
                        selectedSeatNames.length > 0 ? selectedSeatNames.join(', ') : "Chưa chọn ghế nào";

                // Thay vì tự set format tiền, gọi hàm updatePriceUI để nó tính toán chung với Voucher
                updatePriceUI();
            }

            // HÀM 3: Xử lý Gọi API Voucher (Giao tiếp Plain Text)
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

                msgBox.style.color = "#FFD700";
                msgBox.innerText = "Đang kiểm tra...";

                // Gọi AJAX ngầm đến Servlet
                fetch('VoucherController?voucherCode=' + code)
                .then(response => response.text())
                .then(text => {
                    // Cắt chuỗi Plain Text trả về: "true|15|Áp dụng thành công..."
                    let dataArray = text.split("|");
                    let isValid = dataArray[0].trim();
                    let discount = parseInt(dataArray[1].trim());
                    let message = dataArray[2].trim();

                    if (isValid === "true") {
                        msgBox.style.color = "#00FF00"; // Màu xanh lá
                        msgBox.innerText = message;
                        
                        // Chốt giảm giá
                        currentDiscountPercent = discount;
                        document.getElementById('appliedVoucherInput').value = code; // Lưu mã vào form ẩn
                    } else {
                        msgBox.style.color = "#E50914"; // Màu đỏ
                        msgBox.innerText = message;
                        
                        // Hủy giảm giá nếu mã sai
                        currentDiscountPercent = 0;
                        document.getElementById('appliedVoucherInput').value = "";
                    }
                    
                    // Lập tức tính lại và nhảy số tiền trên màn hình
                    updatePriceUI();
                })
                .catch(error => {
                    console.error('Error:', error);
                    msgBox.style.color = "#E50914";
                    msgBox.innerText = "Lỗi kết nối máy chủ!";
                });
            }

            // HÀM 4: Submit gửi đơn đi
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
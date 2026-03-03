<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sơ Đồ Ghế Ngồi - PRJ Cinema</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #222;
                color: #fff;
                text-align: center;
            }

            /* Chú thích màu ghế */
            .legend {
                margin: 20px 0;
                display: flex;
                justify-content: center;
                gap: 20px;
            }
            .legend div {
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .box {
                width: 20px;
                height: 20px;
                border-radius: 4px;
            }

            /* Hiệu ứng Màn hình chiếu cong */
            .screen {
                background-color: #fff;
                height: 70px;
                width: 80%;
                margin: 20px auto 50px auto;
                transform: rotateX(-45deg);
                box-shadow: 0 15px 30px rgba(255, 255, 255, 0.4);
                border-radius: 50% 50% 0 0 / 100% 100% 0 0;
                color: #444;
                font-weight: bold;
                font-size: 20px;
                line-height: 70px;
            }

            /* Lưới Sơ đồ ghế (Ma trận 10 cột) */
            .seat-container {
                display: grid;
                grid-template-columns: repeat(10, 40px); /* 10 ghế 1 hàng */
                gap: 12px;
                justify-content: center;
                margin-bottom: 30px;
                position: relative;
            }
            
            .sweet-spot-frame {
                position: absolute; /* Rút khỏi luồng để không đẩy các ghế khác bị lệch */
                grid-row: 4 / 8;    /* Căng từ Hàng D (4) đến hết Hàng G (7) */
                grid-column: 3 / 9; /* Căng từ Cột 3 đến hết Cột 8 */
                border: 2px dashed #00FFFF; /* Khung nét đứt màu Cyan Neon */
                border-radius: 8px;
                background-color: rgba(0, 255, 255, 0.05); /* Phủ lớp nền sáng mờ */
                pointer-events: none; /* QUAN TRỌNG: Cho phép chuột click XUYÊN QUA khung để chọn ghế */
                z-index: 0;
                /* Bung rộng khung ra một chút để không dính sát vào mép ghế */
                top: -6px; bottom: -6px; left: -6px; right: -6px; 
            }

            /* Nhãn dán chữ BEST VIEW trên viền khung */
            .sweet-spot-frame::after {
                content: 'BEST VIEW';
                position: absolute;
                top: -12px;
                left: 50%;
                transform: translateX(-50%);
                background: #222;
                color: #00FFFF;
                padding: 2px 12px;
                font-size: 10px;
                font-weight: bold;
                border: 1px solid #00FFFF;
                border-radius: 10px;
                letter-spacing: 1px;
            }
            /* Kết thúc đoạn khung Best View */         

            /* Style chung cho 1 chiếc ghế */
            .seat {
                width: 40px;
                height: 35px;
                border-radius: 5px 5px 0 0;
                font-size: 12px;
                font-weight: bold;
                line-height: 35px;
                cursor: pointer;
                transition: transform 0.2s;
            }

            /* Phân loại màu ghế */
            .seat.normal {
                background-color: #444;
                border-bottom: 4px solid #666;
            } /* Ghế thường */
            .seat.vip {
                background-color: #FFD700;
                color: #000;
                border-bottom: 4px solid #B8860B;
            } /* Ghế VIP */
            .seat.booked {
                background-color: #E50914;
                color: #fff;
                border-bottom: 4px solid #8B0000;
                cursor: not-allowed;
            } /* Ghế bị mua */
            .seat.couple {
                background-color: #FF69B4; /* Màu hồng */
                color: #000;
                border-bottom: 4px solid #C71585;
                grid-column: span 2; /* Bắt ghế này giãn dài chiếm 2 cột */
                width: 100%;
            }
            /* Hiệu ứng khi khách click chọn */
            .seat.selected {
                background-color: #00FF00 !important;
                color: #000;
                border-bottom: 4px solid #008000;
                transform: scale(1.1);
            }
            .seat:hover:not(.booked) {
                transform: scale(1.1);
            }

            /* Nút Thanh toán */
            .checkout-panel {
                background: #333;
                padding: 20px;
                margin-top: 30px;
                border-radius: 10px;
            }
            .btn-checkout {
                background: #E50914;
                color: white;
                border: none;
                padding: 10px 30px;
                font-size: 18px;
                border-radius: 5px;
                cursor: pointer;
                font-weight: bold;
            }
            .btn-checkout:hover {
                background: #ff0f1a;
            }
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
                     data-seattype="${seat.seatType}" onclick="${seat.booked ? '' : 'toggleSeat(this)'}"
                     onclick="${seat.booked ? '' : 'toggleSeat(this)'}"> 
                    ${seat.seatName}
                </div>

            </c:forEach>
        </div>

        <div class="checkout-panel">
            <h3>Ghế bạn chọn: <span id="displaySelectedSeats" style="color:#00FF00;">Chưa chọn ghế nào</span></h3>
            <h3>Tổng tiền: <span id="displayTotalPrice" style="color:#FFD700;">0</span> VNĐ</h3>

            <form action="BookingController" method="POST" id="bookingForm">
                <input type="hidden" name="action" value="checkout">
                <input type="hidden" name="showtimeID" value="${CURRENT_SHOWTIME_ID}">
                <input type="hidden" name="selectedSeats" id="selectedSeatsInput">
                <input type="hidden" name="totalAmount" id="totalAmountInput">
                <button type="button" class="btn-checkout" onclick="submitBooking()">TIẾN HÀNH THANH TOÁN</button>
            </form>
        </div>

        <script>
            let selectedSeatIDs = [];
            let selectedSeatNames = [];
            let totalPrice = 0;

            function toggleSeat(element) {
                let seatID = element.getAttribute('data-seatid');
                let seatName = element.getAttribute('data-seatname');
                let seatType = element.getAttribute('data-seattype');

                // Định giá tiền trực tiếp
                let price = 0;
                if (seatType === 'Couple')
                    price = 150000;
                else if (seatType === 'VIP')
                    price = 100000;
                else
                    price = 70000; // Ghế thường

                element.classList.toggle('selected');

                if (element.classList.contains('selected')) {
                    selectedSeatIDs.push(seatID);
                    selectedSeatNames.push(seatName);
                    totalPrice += price; // Cộng tiền
                } else {
                    selectedSeatIDs = selectedSeatIDs.filter(id => id !== seatID);
                    selectedSeatNames = selectedSeatNames.filter(name => name !== seatName);
                    totalPrice -= price; // Trừ tiền
                }

                // Cập nhật giao diện mượt mà
                document.getElementById('displaySelectedSeats').innerText =
                        selectedSeatNames.length > 0 ? selectedSeatNames.join(', ') : "Chưa chọn ghế nào";

                // Format tiền tệ cho đẹp (VD: 150000 -> 150,000)
                document.getElementById('displayTotalPrice').innerText = totalPrice.toLocaleString('vi-VN');
            }

            function submitBooking() {
                if (selectedSeatIDs.length === 0) {
                    alert("Vui lòng chọn ít nhất 1 ghế trước khi thanh toán!");
                    return;
                }

                document.getElementById('selectedSeatsInput').value = selectedSeatIDs.join(',');
                document.getElementById('totalAmountInput').value = totalPrice; // Gửi tổng tiền về Controller

                document.getElementById('bookingForm').submit();
            }
        </script>
    </body>
</html>
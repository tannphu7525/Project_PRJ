<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch Sử Đặt Vé - PRJ Cinema</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #111;
                color: #fff;
                padding: 20px;
            }
            .container {
                max-width: 1000px;
                margin: auto;
                background: #222;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.5);
            }
            h2 {
                text-align: center;
                color: #FFD700;
                border-bottom: 2px solid #444;
                padding-bottom: 10px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #444;
                vertical-align: middle;
            }
            th {
                background-color: #333;
                color: #FFD700;
            }
            tr:hover {
                background-color: #333;
            }
            .btn-home {
                display: inline-block;
                margin-bottom: 15px;
                padding: 10px 20px;
                background: #E50914;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-weight: bold;
            }
            .btn-home:hover {
                background: #ff0f1a;
            }
            .seat-tag {
                display: inline-block;
                background: #FF69B4;
                color: #000;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: bold;
                letter-spacing: 1px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="HomeController" class="btn-home">⬅ Về Trang Chủ</a>
            <h2>LỊCH SỬ ĐẶT VÉ CỦA BẠN</h2>

            <table>
                <thead>
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Thời gian đặt</th>
                        <th>Phim</th>
                        <th>Rạp - Phòng</th>
                        <th>Suất chiếu</th>
                        <th>Ghế ngồi</th>
                        <th>Tổng tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty HISTORY_LIST}">
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 30px; color: #aaa;">
                                    Bạn chưa có lịch sử giao dịch nào. Hãy đặt vé ngay!
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${HISTORY_LIST}" varStatus="loop">
                                <tr>
                                    <td style="font-weight: bold; color: #fff;">
                                        #${fn:length(HISTORY_LIST) - loop.index}
                                    </td>

                                    <td style="color: #bbb;">
                                        <fmt:formatDate value="${item.orderDate}" pattern="HH:mm - dd/MM/yyyy"/>
                                    </td>

                                    <td style="font-weight: bold; color: #00FFFF;">${item.movieTitle}</td>

                                    <td>${item.cinemaName} <br> <small style="color:#aaa;">(${item.roomName})</small></td>

                                    <td>
                                        <fmt:formatDate value="${item.showDate}" pattern="dd/MM/yyyy"/> <br> 
                                        <small style="color:#FFD700; font-weight: bold;">
                                            <fmt:formatDate value="${item.startTime}" pattern="HH:mm"/>
                                        </small>
                                    </td>

                                    <td><span class="seat-tag">${item.seats}</span></td>

                                    <td style="color: #00FF00; font-weight: bold; font-size: 1.1em;">
                                        <fmt:formatNumber value="${item.totalAmount}" type="number" pattern="#,###"/> VNĐ
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Lịch Sử Đặt Vé - PRJ Cinema</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <style>
            /* Bảng màu đồng bộ toàn hệ thống */
            :root {
                --bg-body: #111827;
                --bg-card: #1f2937;
                --accent-blue: #00d4ff;
                --border-color: #334155;
            }
            body {
                background-color: var(--bg-body);
                font-family: 'Roboto', sans-serif;
                color: #f8fafc; /* Màu chữ mặc định là trắng sáng */
                overflow-x: hidden;
            }
            
            /* Navbar */
            .navbar {
                background-color: #0b0f19;
                border-bottom: 1px solid var(--border-color);
                box-shadow: 0 4px 15px rgba(0,0,0,0.5);
            }
            .navbar-brand {
                color: var(--accent-blue) !important;
                letter-spacing: 1px;
            }

            /* Khối chứa nội dung */
            .history-card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.4);
            }
            .card-title {
                color: #FFD700; /* Màu vàng Gold sáng */
                border-bottom: 2px solid var(--border-color);
                padding-bottom: 15px;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            /* Bảng dữ liệu */
            .table-dark {
                background-color: transparent;
            }
            .table-dark th {
                background-color: #111827;
                color: var(--accent-blue); /* Tiêu đề cột màu xanh sáng */
                border-color: var(--border-color);
                text-transform: uppercase;
                font-size: 0.95rem;
            }
            .table-dark td {
                background-color: var(--bg-card);
                border-color: var(--border-color);
                vertical-align: middle;
            }
            
            /* Tem hiển thị Ghế */
            .seat-tag {
                display: inline-block;
                background-color: #e11d48; /* Đỏ hồng nổi bật */
                color: #ffffff;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 0.95rem;
                font-weight: bold;
                letter-spacing: 1px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            }
            
            /* Ghi đè hiệu ứng hover của bảng */
            .table-hover>tbody>tr:hover>td {
                background-color: #334155 !important;
                color: #fff !important;
            }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg sticky-top mb-4">
            <div class="container">
                <a class="navbar-brand fw-bold fs-4" href="HomeController">
                    <i class="fas fa-film me-2"></i>PRJ CINEMA
                </a>
                <div class="d-flex align-items-center">
                    <a href="HomeController" class="btn btn-outline-light btn-sm rounded-pill px-4 fw-bold">
                        <i class="fas fa-arrow-left me-2"></i> Về Trang Chủ
                    </a>
                </div>
            </div>
        </nav>

        <div class="container mb-5">
            <div class="history-card">
                
                <h2 class="card-title text-center mb-4">
                    <i class="fas fa-history me-2"></i> Lịch Sử Đặt Vé Của Bạn
                </h2>

                <div class="table-responsive">
                    <table class="table table-dark table-hover table-bordered align-middle text-center mb-0">
                        <thead>
                            <tr>
                                <th>Mã Đơn</th>
                                <th>Thời gian đặt</th>
                                <th class="text-start">Phim</th>
                                <th>Rạp - Phòng</th>
                                <th>Suất chiếu</th>
                                <th>Ghế ngồi</th>
                                <th class="text-end">Tổng tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty HISTORY_LIST}">
                                    <tr>
                                        <td colspan="7" class="text-center py-5">
                                            <i class="fas fa-ticket-alt fs-1 text-light mb-3 d-block"></i>
                                            <span class="text-white fs-5 fw-medium">Bạn chưa có lịch sử giao dịch nào. Hãy đặt vé ngay!</span>
                                            <br>
                                            <a href="HomeController" class="btn btn-info mt-3 rounded-pill fw-bold px-5 text-dark">
                                                Mua vé ngay
                                            </a>
                                        </td>
                                    </tr>
                                </c:when>
                                
                                <c:otherwise>
                                    <c:forEach var="item" items="${HISTORY_LIST}" varStatus="loop">
                                        <tr>
                                            <td class="fw-bold text-white fs-5">
                                                #${fn:length(HISTORY_LIST) - loop.index}
                                            </td>

                                            <td class="text-light fw-medium">
                                                <fmt:formatDate value="${item.orderDate}" pattern="HH:mm - dd/MM/yyyy"/>
                                            </td>

                                            <td class="text-start fw-bold text-info fs-5">
                                                ${item.movieTitle}
                                            </td>

                                            <td>
                                                <span class="text-white fw-bold">${item.cinemaName}</span> <br> 
                                                <span class="text-light small">(${item.roomName})</span>
                                            </td>

                                            <td>
                                                <span class="text-white fw-medium"><fmt:formatDate value="${item.showDate}" pattern="dd/MM/yyyy"/></span> <br> 
                                                <span class="text-warning fw-bold fs-6">
                                                    <i class="far fa-clock me-1"></i><fmt:formatDate value="${item.startTime}" pattern="HH:mm"/>
                                                </span>
                                            </td>

                                            <td>
                                                <span class="seat-tag">${item.seats}</span>
                                            </td>

                                            <td class="text-end text-success fw-bold fs-5">
                                                <fmt:formatNumber value="${item.totalAmount}" type="number" pattern="#,###"/> ₫
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
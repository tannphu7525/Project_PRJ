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

        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #111827;
                --bg-card: #1f2937;
                --bg-darker: #0b0f19;
                --accent-blue: #0ea5e9;
                --accent-hover: #0284c7;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --border-color: #334155;
                --success: #10b981;
                --warning: #f59e0b;
                --danger: #e11d48;
                --gold: #FFD700;
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
            
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }

            /* --- 2. THANH ĐIỀU HƯỚNG (NAVBAR) --- */
            .navbar {
                background-color: var(--bg-darker);
                border-bottom: 1px solid var(--border-color);
                box-shadow: 0 4px 15px rgba(0,0,0,0.5);
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

            /* --- 3. KHUNG CHỨA NỘI DUNG (CARD) --- */
            .history-card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.4);
            }
            .card-title {
                color: var(--gold);
                border-bottom: 2px solid var(--border-color);
                padding-bottom: 15px;
                margin-bottom: 25px;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-align: center;
                font-size: 1.8rem;
            }

            /* --- 4. BẢNG DỮ LIỆU --- */
            .table-responsive { overflow-x: auto; }
            .custom-table {
                width: 100%;
                border-collapse: collapse;
                text-align: center;
                min-width: 900px;
            }
            .custom-table th, .custom-table td {
                border: 1px solid var(--border-color);
                padding: 15px;
            }
            .custom-table th {
                background-color: var(--bg-darker);
                color: var(--accent-blue);
                text-transform: uppercase;
                font-size: 0.9rem;
                letter-spacing: 0.5px;
            }
            .custom-table td {
                background-color: var(--bg-card);
                vertical-align: middle;
            }
            .custom-table tr:hover td { background-color: #2a364a; } /* Hiệu ứng hover mượt hơn */

            /* --- 5. ĐỊNH DẠNG TEXT TRONG BẢNG --- */
            .text-start { text-align: left; }
            .text-end { text-align: right; }
            .text-center { text-align: center; }
            .fw-bold { font-weight: bold; }
            .fw-medium { font-weight: 500; }
            
            .text-white { color: #ffffff; }
            .text-light { color: #f8fafc; }
            .text-muted { color: var(--text-muted); }
            .text-info { color: var(--info); }
            .text-warning { color: var(--warning); }
            .text-success { color: var(--success); }
            
            .fs-5 { font-size: 1.25rem; }
            .fs-6 { font-size: 1rem; }
            .small { font-size: 0.85rem; }

            /* Tem hiển thị Mã Đơn & Ghế */
            .id-tag {
                background-color: #475569;
                color: white;
                padding: 5px 10px;
                border-radius: 6px;
                font-weight: bold;
                letter-spacing: 1px;
            }
            .seat-tag {
                display: inline-block;
                background-color: var(--danger); 
                color: #ffffff;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 0.95rem;
                font-weight: bold;
                letter-spacing: 1px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            }

            /* --- 6. TRẠNG THÁI TRỐNG (EMPTY STATE) --- */
            .empty-state {
                text-align: center;
                padding: 60px 20px;
            }
            .empty-state p {
                font-size: 1.2rem;
                font-weight: 500;
                margin-bottom: 20px;
            }
            .btn-info {
                background-color: var(--info);
                color: white;
                padding: 12px 40px;
                border-radius: 30px;
                font-weight: bold;
                font-size: 1.1rem;
                display: inline-block;
                transition: 0.3s;
                border: none;
            }
            .btn-info:hover { background-color: var(--accent-hover); }

        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="navbar-container">
                <a class="navbar-brand" href="HomeController">PRJ CINEMA</a>
                <div>
                    <a href="HomeController" class="btn-outline-light">
                        ← Về Trang Chủ
                    </a>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="history-card">
                
                <h2 class="card-title">Lịch Sử Đặt Vé Của Bạn</h2>

                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Thứ tự</th>
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
                                        <td colspan="7" class="empty-state">
                                            <p>Bạn chưa có lịch sử giao dịch nào. Hãy đặt vé ngay!</p>
                                            <a href="HomeController" class="btn-info">Mua vé ngay</a>
                                        </td>
                                    </tr>
                                </c:when>
                                
                                <c:otherwise>
                                    <c:forEach var="item" items="${HISTORY_LIST}" varStatus="loop">
                                        <tr>
                                            <td>
                                                <span class="id-tag">#${fn:length(HISTORY_LIST) - loop.index}</span>
                                            </td>

                                            <td class="text-light fw-medium">
                                                <fmt:formatDate value="${item.orderDate}" pattern="HH:mm - dd/MM/yyyy"/>
                                            </td>

                                            <td class="text-start fw-bold text-info fs-5">
                                                ${item.movieTitle}
                                            </td>

                                            <td>
                                                <div class="text-white fw-bold">${item.cinemaName}</div>
                                                <div class="text-muted small">(${item.roomName})</div>
                                            </td>

                                            <td>
                                                <div class="text-white fw-medium">
                                                    <fmt:formatDate value="${item.showDate}" pattern="dd/MM/yyyy"/>
                                                </div>
                                                <div class="text-warning fw-bold">
                                                    <fmt:formatDate value="${item.startTime}" pattern="HH:mm"/>
                                                </div>
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

    </body>
</html>
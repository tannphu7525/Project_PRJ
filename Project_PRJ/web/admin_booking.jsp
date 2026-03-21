<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Doanh Thu & Đơn Hàng - PRJ Cinema</title>
        
        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #111827; 
                --bg-card: #1f2937;
                --bg-darker: #0b0f19;
                --accent-blue: #3b82f6;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --border-color: #334155;
                --success: #10b981;
                --danger: #ef4444;
                --warning: #f59e0b;
                --info: #0ea5e9;
            }
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                background-color: var(--bg-body);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                color: var(--text-main);
                display: flex;
                flex-direction: column;
                height: 100vh;
                overflow: hidden;
            }
            a { text-decoration: none; }

            /* --- 2. THANH ĐIỀU HƯỚNG (NAVBAR) --- */
            .navbar {
                background-color: var(--bg-darker);
                border-bottom: 1px solid var(--border-color);
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                z-index: 10;
            }
            .navbar-brand {
                color: var(--accent-blue);
                font-size: 1.4rem;
                font-weight: bold;
                letter-spacing: 1px;
                text-transform: uppercase;
            }
            .navbar-brand span { color: var(--text-muted); font-size: 0.9rem; font-weight: normal; margin-left: 10px; text-transform: none;}
            
            .user-area { display: flex; align-items: center; }
            .user-greeting { margin-right: 20px; font-size: 0.95rem; color: var(--text-muted); }
            .user-greeting b { color: var(--text-main); font-weight: bold; }
            .btn-logout {
                border: 1px solid var(--danger);
                color: var(--danger);
                padding: 8px 20px;
                border-radius: 20px;
                font-weight: bold;
                transition: 0.3s;
            }
            .btn-logout:hover { background-color: var(--danger); color: white; }

            /* --- 3. BỐ CỤC CHÍNH (WRAPPER) --- */
            .wrapper {
                display: flex;
                flex: 1;
                overflow: hidden;
            }

            /* --- 4. CSS DỰ PHÒNG CHO SIDEBAR (Phòng trường hợp file include cần) --- */
            .sidebar {
                width: 260px;
                background-color: var(--bg-darker);
                border-right: 1px solid var(--border-color);
                overflow-y: auto;
                padding-top: 20px;
            }
            .sidebar-link {
                color: var(--text-muted);
                padding: 15px 25px;
                display: block;
                font-weight: 500;
                font-size: 1.05rem;
                border-bottom: 1px solid #1a2333;
                transition: 0.3s;
            }
            .sidebar-link:hover, .sidebar-link.active {
                background-color: var(--bg-card);
                color: var(--accent-blue);
                border-left: 5px solid var(--accent-blue);
            }

            /* --- 5. CỘT PHẢI (MAIN CONTENT) --- */
            .main-content {
                flex: 1;
                padding: 30px;
                overflow-y: auto;
            }
            .page-title {
                font-size: 1.6rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 25px;
                font-weight: bold;
            }

            /* --- 6. THÔNG BÁO (ALERT) --- */
            .alert {
                background-color: rgba(14, 165, 233, 0.15);
                border: 1px solid var(--info);
                color: #38bdf8;
                padding: 15px 20px;
                border-radius: 8px;
                margin-bottom: 25px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-weight: bold;
            }
            .alert-close {
                background: transparent;
                border: none;
                color: white;
                font-size: 1.2rem;
                cursor: pointer;
                opacity: 0.7;
            }
            .alert-close:hover { opacity: 1; }

            /* --- 7. THẺ THỐNG KÊ (STAT CARDS) TỰ CODE LƯỚI --- */
            .stat-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr); /* Chia 2 cột đều nhau */
                gap: 20px;
                margin-bottom: 30px;
            }
            .stat-card {
                background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
                padding: 25px;
                border-radius: 10px;
                border-left: 5px solid var(--accent-blue);
                box-shadow: 0 5px 15px rgba(0,0,0,0.4);
            }
            .stat-card.green { border-left-color: var(--success); }
            
            .stat-card p {
                color: var(--text-muted);
                font-size: 0.95rem;
                text-transform: uppercase;
                font-weight: bold;
                margin-bottom: 10px;
            }
            .stat-card h3 {
                font-size: 2rem;
                color: var(--accent-blue);
            }
            .stat-card.green h3 { color: var(--success); }

            /* --- 8. KHUNG BẢNG VÀ BẢNG DỮ LIỆU --- */
            .admin-card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }
            .card-title {
                color: var(--accent-blue);
                border-left: 4px solid var(--accent-blue);
                padding-left: 15px;
                margin-bottom: 25px;
                font-size: 1.2rem;
                text-transform: uppercase;
            }

            .table-responsive { overflow-x: auto; }
            .custom-table {
                width: 100%;
                border-collapse: collapse;
                text-align: center;
                min-width: 1000px; /* Chống co rúm bảng */
            }
            .custom-table th, .custom-table td {
                border: 1px solid var(--border-color);
                padding: 12px 15px;
            }
            .custom-table th {
                background-color: var(--bg-darker);
                color: var(--accent-blue);
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.5px;
            }
            .custom-table td { background-color: var(--bg-card); vertical-align: middle; }
            .custom-table tr:hover td { background-color: #253347; }
            
            .text-left { text-align: left; }
            .fw-bold { font-weight: bold; }
            .text-light { color: var(--text-main); }
            .text-muted { color: var(--text-muted); font-size: 0.85rem; }
            .text-accent { color: var(--accent-blue); }
            .text-warning { color: var(--warning); }
            
            /* --- 9. NHÃN (BADGE) & NÚT THAO TÁC (BUTTON) --- */
            .badge {
                padding: 6px 10px;
                border-radius: 6px;
                font-size: 0.8rem;
                font-weight: bold;
                display: inline-block;
            }
            .bg-secondary { background-color: #475569; color: white; letter-spacing: 1px;}
            .bg-success { background-color: rgba(16, 185, 129, 0.2); color: var(--success); border: 1px solid var(--success); }
            .bg-danger { background-color: rgba(239, 68, 68, 0.2); color: var(--danger); border: 1px solid var(--danger); }

            .btn-action-sm {
                border: 1px solid var(--danger);
                color: var(--danger);
                background: transparent;
                padding: 6px 12px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.85rem;
                font-weight: bold;
                transition: 0.3s;
                display: inline-block;
            }
            .btn-action-sm:hover {
                background-color: var(--danger);
                color: white;
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <a class="navbar-brand" href="HomeController">
                PRJ CINEMA <span>| Hệ thống Quản trị</span>
            </a>
            <div class="user-area">
                <a href="MainController?action=logout" class="btn-logout">Log Out</a>
            </div>
        </nav>

        <div class="wrapper">
            
            <jsp:include page="admin_sidebar.jsp" />

            <div class="main-content">
                <h2 class="page-title">Thống Kê Doanh Thu & Đơn Hàng</h2>

                <c:if test="${not empty msg}">
                    <div class="alert" id="infoAlert">
                        <span>Hệ thống: ${msg}</span>
                        <button class="alert-close" onclick="document.getElementById('infoAlert').style.display='none'">X</button>
                    </div>
                </c:if>

                <div class="stat-grid">
                    <div class="stat-card">
                        <p>Tổng Doanh Thu</p>
                        <h3><fmt:formatNumber value="${TOTAL_REVENUE}" type="number" pattern="#,###"/> VNĐ</h3>
                    </div>
                    <div class="stat-card green">
                        <p>Đơn Đặt Thành Công</p>
                        <h3>${TOTAL_TICKETS} Đơn</h3>
                    </div>
                </div>

                <div class="admin-card">
                    <h4 class="card-title">Chi Tiết Đơn Hàng</h4>
                    
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Mã Đơn</th>
                                    <th>Khách Hàng</th>
                                    <th class="text-left">Phim</th>
                                    <th>Thông tin Rạp</th>
                                    <th>Suất Chiếu</th>
                                    <th>Ghế</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái</th>
                                    <th>Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${ORDER_LIST}">
                                    <tr>
                                        <td><span class="badge bg-secondary">#${o.orderID}</span></td>
                                        <td class="fw-bold text-light">${o.userName}</td>
                                        <td class="text-left text-accent fw-bold">${o.movieTitle}</td>
                                        <td>
                                            <div style="font-size: 0.9rem;">${o.cinemaName}</div>
                                            <div class="text-muted">${o.roomName}</div>
                                        </td>
                                        <td>
                                            <div style="font-size: 0.9rem;">${o.showDate}</div>
                                            <div class="text-warning fw-bold">${o.startTime}</div>
                                        </td>
                                        <td class="fw-bold">${o.seats}</td>
                                        <td class="text-warning fw-bold">
                                            <fmt:formatNumber value="${o.totalAmount}" type="number" pattern="#,###"/> ₫
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${o.orderStatus == 'Completed'}">
                                                    <span class="badge bg-success">Thành công</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Đã hủy</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${o.orderStatus == 'Completed'}">
                                                <a href="MainController?action=adminBooking&subAction=cancel&orderID=${o.orderID}" 
                                                   class="btn-action-sm" 
                                                   onclick="return confirm('Xác nhận hủy đơn hàng #${o.orderID} và giải phóng ghế trống?');">
                                                   Hủy Vé
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div> 
        </div> 

    </body>
</html>
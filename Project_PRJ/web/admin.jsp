<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Admin Dashboard - PRJ Cinema</title>

        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #111827; 
                --bg-card: #1f2937;
                --bg-darker: #0b0f19;
                --accent-blue: #3b82f6;
                --accent-hover: #2563eb;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --border-color: #334155;
                --success: #10b981;
                --danger: #ef4444;
                --warning: #f59e0b;
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
                overflow: hidden; /* Cố định trang, chỉ cho cuộn phần nội dung */
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
            }
            .navbar-brand span { color: var(--text-muted); font-size: 0.9rem; font-weight: normal; margin-left: 10px; }
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

            /* --- 4. CỘT TRÁI (SIDEBAR) --- */
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
            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
            }
            .page-header h2 { font-size: 1.5rem; text-transform: uppercase; letter-spacing: 1px; }
            .btn-action {
                background-color: #0ea5e9;
                color: white;
                padding: 10px 20px;
                border-radius: 20px;
                font-weight: bold;
                transition: 0.3s;
                border: none;
                cursor: pointer;
            }
            .btn-action:hover { background-color: #0284c7; }

            /* --- 6. KHUNG (CARD) & FORM GRID TỰ TẠO --- */
            .admin-card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 30px;
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

            /* Hệ thống lưới Grid thay thế Bootstrap */
            .form-grid {
                display: grid;
                grid-template-columns: repeat(12, 1fr);
                gap: 20px;
            }
            .col-6 { grid-column: span 6; }
            .col-3 { grid-column: span 3; }
            .col-2 { grid-column: span 2; }
            .col-12 { grid-column: span 12; }

            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #cbd5e1;
                font-size: 0.95rem;
            }
            .form-control, .form-select {
                width: 100%;
                background-color: #0f172a;
                border: 1px solid var(--border-color);
                color: white;
                padding: 10px 15px;
                border-radius: 6px;
                font-family: inherit;
                font-size: 1rem;
            }
            .form-control:focus, .form-select:focus {
                outline: none;
                border-color: var(--accent-blue);
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
            }
            
            .btn-submit {
                background-color: var(--accent-blue);
                color: white;
                border: none;
                padding: 12px 40px;
                border-radius: 30px;
                font-weight: bold;
                cursor: pointer;
                transition: 0.3s;
                font-size: 1rem;
            }
            .btn-submit:hover { background-color: var(--accent-hover); }

            /* --- 7. BẢNG DỮ LIỆU (TABLE) --- */
            .table-responsive { overflow-x: auto; }
            .custom-table {
                width: 100%;
                border-collapse: collapse;
                text-align: center;
                min-width: 900px;
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
            .text-accent { color: var(--accent-blue); }
            .text-warning { color: var(--warning); }
            .text-danger { color: var(--danger); }
            
            .badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: bold;
                display: inline-block;
            }
            .bg-success { background-color: rgba(16, 185, 129, 0.2); color: var(--success); border: 1px solid var(--success); }
            .bg-danger { background-color: rgba(239, 68, 68, 0.2); color: var(--danger); border: 1px solid var(--danger); }

            /* --- 8. THÔNG BÁO (ALERT) --- */
            .alert {
                background-color: rgba(16, 185, 129, 0.15);
                border: 1px solid var(--success);
                color: #34d399;
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
            
            /* Cấu hình checkbox trạng thái */
            .status-container {
                display: flex;
                align-items: center;
                height: 100%;
                padding-top: 25px; /* Để căn bằng với các input khác */
            }
            .status-checkbox {
                width: 20px;
                height: 20px;
                cursor: pointer;
                accent-color: var(--success);
            }
            .status-label {
                margin-left: 10px;
                color: var(--success);
                font-weight: bold;
                cursor: pointer;
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <a class="navbar-brand" href="MainController?action=adminMovie&subAction=list">
                PRJ CINEMA <span>| Hệ thống Quản trị</span>
            </a>
            <a href="MainController?action=logout" class="btn-logout">Log Out</a>
        </nav>

        <div class="wrapper">
            
            <div class="sidebar">
                <a href="HomeController" class="sidebar-link">Trang chủ</a>
                <a href="MainController?action=adminMovie" class="sidebar-link">Quản lý Phim</a>
                <a href="MainController?action=adminShowtime&subAction=list" class="sidebar-link active">Quản lý Lịch chiếu</a>
                <a href="MainController?action=adminVoucher" class="sidebar-link">Quản lý Voucher</a>
                <a href="#" class="sidebar-link" style="color: #475569; pointer-events: none;">Quản lý User (Sắp ra mắt)</a>
            </div>

            <div class="main-content">
                
                <div class="page-header">
                    <h2>Quản Lý Lịch Chiếu</h2>
                    <a href="MainController?action=adminShowtime&subAction=list" class="btn-action">Tải lại dữ liệu</a>
                </div>

                <c:if test="${not empty msg}">
                    <div class="alert" id="successAlert">
                        <span>Trạng thái: ${msg}</span>
                        <button class="alert-close" onclick="document.getElementById('successAlert').style.display='none'">X</button>
                    </div>
                </c:if>

                <div class="admin-card">
                    <h4 class="card-title">Thêm Lịch Chiếu Mới</h4>

                    <form action="MainController" method="POST">
                        <input type="hidden" name="action" value="adminShowtime">
                        <input type="hidden" name="subAction" value="add">

                        <div class="form-grid">
                            <div class="col-6">
                                <label class="form-label">Chọn Phim:</label>
                                <select name="movieID" class="form-select" required>
                                    <c:forEach var="movie" items="${MOVIE_LIST}">
                                        <option value="${movie.movieID}">${movie.title}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-6">
                                <label class="form-label">Chọn Phòng chiếu:</label>
                                <select name="roomID" class="form-select" required>
                                    <option value="" disabled selected>-- Hãy chọn phòng chiếu --</option>
                                    <c:forEach var="room" items="${ROOM_LIST}">
                                        <option value="${room.roomID}">[ ${room.cinemaName} ] - ${room.roomName} (Sức chứa: ${room.capacity})</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-3">
                                <label class="form-label">Ngày chiếu:</label>
                                <input type="date" name="showDate" class="form-control" required>
                            </div>

                            <div class="col-2">
                                <label class="form-label">Bắt đầu:</label>
                                <input type="time" name="startTime" class="form-control" required>
                            </div>

                            <div class="col-2">
                                <label class="form-label">Kết thúc:</label>
                                <input type="time" name="endTime" class="form-control" required>
                            </div>

                            <div class="col-3">
                                <label class="form-label">Giá vé (VNĐ):</label>
                                <input type="number" name="price" class="form-control" value="80000" min="0" required>
                            </div>

                            <div class="col-2">
                                <div class="status-container">
                                    <input type="checkbox" name="status" id="statusCheck" class="status-checkbox" checked>
                                    <label for="statusCheck" class="status-label">Mở Bán</label>
                                </div>
                            </div>

                            <div class="col-12" style="text-align: right; margin-top: 15px;">
                                <button type="submit" class="btn-submit">Lưu Lịch Chiếu</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="admin-card">
                    <h4 class="card-title">Danh sách Lịch Chiếu</h4>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Mã</th>
                                    <th class="text-left">Tên Phim</th>
                                    <th>Rạp</th>
                                    <th>Phòng</th>
                                    <th>Ngày chiếu</th>
                                    <th>Bắt đầu</th>
                                    <th>Kết thúc</th>
                                    <th>Giá vé</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="st" items="${SHOWTIME_LIST}">
                                    <tr>
                                        <td>${st.showtimeID}</td>
                                        <td class="text-left text-accent fw-bold">${st.movieTitle}</td>
                                        <td>${st.cinemaName}</td>
                                        <td>${st.roomName}</td>
                                        <td>${st.showDate}</td>
                                        <td class="fw-bold">${fn:substring(st.startTime, 0, 5)}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${st.endTime != null}">${fn:substring(st.endTime, 0, 5)}</c:when>
                                                <c:otherwise><span class="text-danger" style="font-style: italic;">N/A</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-warning fw-bold">
                                            <fmt:formatNumber value="${st.price}" type="number" pattern="#,###"/> ₫
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${st.status}">
                                                    <span class="badge bg-success">Mở bán</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Đã khóa</span>
                                                </c:otherwise>
                                            </c:choose>
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
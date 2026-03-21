<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản lý Lịch chiếu - PRJ Cinema</title>

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
                --info: #0ea5e9;
                --secondary: #64748b;
            }
            * { box-sizing: border-box; margin: 0; padding: 0; }
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
            .wrapper { display: flex; flex: 1; overflow: hidden; }

            /* CSS DỰ PHÒNG SIDEBAR */
            .sidebar { width: 260px; background-color: var(--bg-darker); border-right: 1px solid var(--border-color); overflow-y: auto; padding-top: 20px; }
            .sidebar-link { color: var(--text-muted); padding: 15px 25px; display: block; font-weight: 500; font-size: 1.05rem; border-bottom: 1px solid #1a2333; transition: 0.3s; }
            .sidebar-link:hover, .sidebar-link.active { background-color: var(--bg-card); color: var(--accent-blue); border-left: 5px solid var(--accent-blue); }

            /* MAIN CONTENT */
            .main-content { flex: 1; padding: 30px; overflow-y: auto; }
            .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
            .page-title { font-size: 1.6rem; text-transform: uppercase; font-weight: bold; }
            
            .btn-action {
                background-color: var(--info);
                color: white;
                padding: 10px 20px;
                border-radius: 20px;
                font-weight: bold;
                border: none;
                cursor: pointer;
                transition: 0.3s;
            }
            .btn-action:hover { background-color: #0284c7; }

            /* --- 4. THÔNG BÁO (ALERT) --- */
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
            .alert-close { background: transparent; border: none; color: white; font-size: 1.2rem; cursor: pointer; opacity: 0.7; }
            .alert-close:hover { opacity: 1; }

            /* --- 5. KHUNG & FORM --- */
            .admin-card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }
            .card-header-flex {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .card-title {
                color: var(--accent-blue);
                border-left: 4px solid var(--accent-blue);
                padding-left: 15px;
                font-size: 1.2rem;
                text-transform: uppercase;
                font-weight: bold;
            }
            .card-title-no-margin { margin-bottom: 0; }

            .form-grid { display: grid; grid-template-columns: repeat(12, 1fr); gap: 20px; }
            .col-6 { grid-column: span 6; }
            .col-3 { grid-column: span 3; }
            .col-2 { grid-column: span 2; }
            .col-12 { grid-column: span 12; }

            .form-label { display: block; margin-bottom: 8px; font-weight: 500; color: #cbd5e1; font-size: 0.95rem; }
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
            .form-control:focus, .form-select:focus { outline: none; border-color: var(--accent-blue); box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);}

            /* TRẠNG THÁI CHECKBOX */
            .status-container { display: flex; align-items: center; height: 100%; padding-top: 25px;}
            .status-checkbox { width: 20px; height: 20px; cursor: pointer; accent-color: var(--success); }
            .status-label { margin-left: 10px; color: var(--success); font-weight: bold; cursor: pointer; }

            /* FORM BUTTONS */
            .form-actions { display: flex; justify-content: flex-end; gap: 15px; margin-top: 15px; }
            .btn { padding: 10px 30px; border-radius: 30px; font-weight: bold; cursor: pointer; border: none; font-size: 0.95rem; transition: 0.3s; }
            .btn-primary { background-color: var(--accent-blue); color: white; }
            .btn-primary:hover { background-color: var(--accent-hover); }
            .btn-secondary { background-color: transparent; border: 1px solid var(--secondary); color: var(--text-main); }
            .btn-secondary:hover { background-color: var(--secondary); }

            /* Ô TÌM KIẾM TRONG BẢNG */
            .search-box { display: flex; }
            .search-input { 
                width: 280px; 
                background-color: #0f172a; 
                color: white; 
                border: 1px solid var(--border-color); 
                padding: 8px 15px; 
                border-radius: 4px 0 0 4px; 
                outline: none;
            }
            .search-input:focus { border-color: var(--info); }
            .search-btn { 
                background-color: var(--info); 
                color: white; 
                border: none; 
                padding: 8px 15px; 
                border-radius: 0 4px 4px 0; 
                font-weight: bold; 
                cursor: pointer; 
            }

            /* --- 6. BẢNG DỮ LIỆU --- */
            .table-responsive { overflow-x: auto; }
            .custom-table { width: 100%; border-collapse: collapse; text-align: center; min-width: 900px; }
            .custom-table th, .custom-table td { border: 1px solid var(--border-color); padding: 12px 15px; }
            .custom-table th { background-color: var(--bg-darker); color: var(--accent-blue); text-transform: uppercase; font-size: 0.85rem; }
            .custom-table td { background-color: var(--bg-card); vertical-align: middle; }
            .custom-table tr:hover td { background-color: #253347; }
            
            .text-left { text-align: left; }
            .fw-bold { font-weight: bold; }
            .text-light { color: var(--text-main); }
            .text-accent { color: var(--accent-blue); }
            .text-warning { color: var(--warning); }
            .text-danger { color: var(--danger); font-style: italic; }
            
            .badge { padding: 6px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: bold; display: inline-block; }
            .bg-secondary { background-color: #475569; color: white; letter-spacing: 1px;}
            .bg-success { background-color: rgba(16, 185, 129, 0.2); color: var(--success); border: 1px solid var(--success); }
            .bg-danger { background-color: rgba(239, 68, 68, 0.2); color: var(--danger); border: 1px solid var(--danger); }

            .action-buttons { display: flex; justify-content: center; gap: 8px; }
            .btn-sm { padding: 5px 12px; border-radius: 4px; font-size: 0.85rem; font-weight: bold; background: transparent; cursor: pointer; border: 1px solid; }
            .btn-edit { border-color: var(--warning); color: var(--warning); }
            .btn-edit:hover { background-color: var(--warning); color: #000; }
            .btn-delete { border-color: var(--danger); color: var(--danger); }
            .btn-delete:hover { background-color: var(--danger); color: white; }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <a class="navbar-brand" href="HomeController">
                PRJ CINEMA <span>| Hệ thống Quản trị</span>
            </a>
            <a href="MainController?action=logout" class="btn-logout">Log Out</a>
        </nav>

        <div class="wrapper">
            <jsp:include page="admin_sidebar.jsp" />

            <div class="main-content">
                
                <div class="page-header">
                    <h2 class="page-title">Quản Lý Lịch Chiếu</h2>
                    <a href="MainController?action=adminShowtime&subAction=list" class="btn-action">Tải lại dữ liệu</a>
                </div>

                <c:if test="${not empty msg}">
                    <div class="alert" id="systemAlert">
                        <span>Hệ thống: ${msg}</span>
                        <button class="alert-close" onclick="document.getElementById('systemAlert').style.display='none'">X</button>
                    </div>
                </c:if>

                <div class="admin-card">
                    <h4 class="card-title">${not empty SHOWTIME_EDIT ? 'Sửa Lịch Chiếu' : 'Thêm Lịch Chiếu Mới'}</h4>

                    <form action="MainController" method="POST" class="form-grid">
                        <input type="hidden" name="action" value="adminShowtime">
                        <input type="hidden" name="subAction" value="${not empty SHOWTIME_EDIT ? 'update' : 'add'}">
                        <input type="hidden" name="showtimeID" value="${not empty SHOWTIME_EDIT ? SHOWTIME_EDIT.showtimeID : '0'}">

                        <div class="col-6">
                            <label class="form-label">Chọn Phim:</label>
                            <select name="movieID" class="form-select" required>
                                <c:forEach var="movie" items="${MOVIE_LIST}">
                                    <option value="${movie.movieID}" ${SHOWTIME_EDIT.movieID == movie.movieID ? 'selected' : ''}>${movie.title}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-6">
                            <label class="form-label">Chọn Phòng chiếu:</label>
                            <select name="roomID" class="form-select" required>
                                <c:forEach var="room" items="${ROOM_LIST}">
                                    <option value="${room.roomID}" ${SHOWTIME_EDIT.roomID == room.roomID ? 'selected' : ''}>[ ${room.cinemaName} ] - ${room.roomName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-3">
                            <label class="form-label">Ngày chiếu:</label>
                            <input type="date" name="showDate" class="form-control" value="${SHOWTIME_EDIT.showDate}" required>
                        </div>

                        <div class="col-2">
                            <label class="form-label">Bắt đầu:</label>
                            <input type="time" name="startTime" class="form-control" value="${fn:substring(SHOWTIME_EDIT.startTime, 0, 5)}" required>
                        </div>

                        <div class="col-2">
                            <label class="form-label">Kết thúc:</label>
                            <input type="time" name="endTime" class="form-control" value="${fn:substring(SHOWTIME_EDIT.endTime, 0, 5)}" required>
                        </div>

                        <div class="col-3">
                            <label class="form-label">Giá vé (VNĐ):</label>
                            <input type="number" name="price" class="form-control" value="${not empty SHOWTIME_EDIT ? SHOWTIME_EDIT.price : '80000'}" min="0" required>
                        </div>

                        <div class="col-2">
                            <div class="status-container">
                                <input type="checkbox" name="status" id="statusCheck" class="status-checkbox" ${empty SHOWTIME_EDIT or SHOWTIME_EDIT.status ? 'checked' : ''}>
                                <label for="statusCheck" class="status-label">Mở Bán</label>
                            </div>
                        </div>

                        <div class="col-12 form-actions">
                            <c:if test="${not empty SHOWTIME_EDIT}">
                                <a href="MainController?action=adminShowtime&subAction=list" class="btn btn-secondary">Hủy Sửa</a>
                            </c:if>
                            <button type="submit" class="btn btn-primary">Lưu Lịch Chiếu</button>
                        </div>
                    </form>
                </div>

                <div class="admin-card">
                    <div class="card-header-flex">
                        <h4 class="card-title card-title-no-margin">Danh sách Lịch Chiếu</h4>

                        <form action="MainController" method="GET" class="search-box">
                            <input type="hidden" name="action" value="adminShowtime">
                            <input type="hidden" name="subAction" value="search">
                            <input type="text" name="keyword" class="search-input" placeholder="Nhập Tên phim, Rạp..." value="${param.keyword}">
                            <button type="submit" class="search-btn">Tìm</button>
                        </form>
                    </div>

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
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="st" items="${SHOWTIME_LIST}">
                                    <tr>
                                        <td><span class="badge bg-secondary">${st.showtimeID}</span></td>
                                        <td class="text-left text-accent fw-bold">${st.movieTitle}</td>
                                        <td>${st.cinemaName}</td>
                                        <td>${st.roomName}</td>
                                        <td>${st.showDate}</td>
                                        <td class="fw-bold text-light">${fn:substring(st.startTime, 0, 5)}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${st.endTime != null}">${fn:substring(st.endTime, 0, 5)}</c:when>
                                                <c:otherwise><span class="text-danger">Chưa cập nhật</span></c:otherwise>
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
                                        <td>
                                            <div class="action-buttons">
                                                <a href="MainController?action=adminShowtime&subAction=edit&showtimeID=${st.showtimeID}" class="btn-sm btn-edit">Sửa</a>
                                                <a href="MainController?action=adminShowtime&subAction=delete&showtimeID=${st.showtimeID}" class="btn-sm btn-delete" onclick="return confirm('Bạn có chắc muốn hủy suất chiếu này không?');">Hủy</a>
                                            </div>
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
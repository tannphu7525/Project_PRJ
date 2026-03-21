<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản Lý Phòng Chiếu - PRJ Cinema</title>
        
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

            /* --- 4. CSS DỰ PHÒNG SIDEBAR --- */
            .sidebar { width: 260px; background-color: var(--bg-darker); border-right: 1px solid var(--border-color); overflow-y: auto; padding-top: 20px; }
            .sidebar-link { color: var(--text-muted); padding: 15px 25px; display: block; font-weight: 500; font-size: 1.05rem; border-bottom: 1px solid #1a2333; transition: 0.3s; }
            .sidebar-link:hover, .sidebar-link.active { background-color: var(--bg-card); color: var(--accent-blue); border-left: 5px solid var(--accent-blue); }

            /* --- 5. CỘT PHẢI (MAIN CONTENT) --- */
            .main-content { flex: 1; padding: 30px; overflow-y: auto; }
            .page-title { font-size: 1.6rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 25px; font-weight: bold; }

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
            .alert-close { background: transparent; border: none; color: white; font-size: 1.2rem; cursor: pointer; opacity: 0.7; }
            .alert-close:hover { opacity: 1; }

            /* --- 7. KHUNG BẢNG VÀ FORM LƯỚI --- */
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
                font-weight: bold;
            }

            /* Hệ thống lưới Grid 12 cột */
            .form-grid {
                display: grid;
                grid-template-columns: repeat(12, 1fr);
                gap: 20px;
            }
            .col-4 { grid-column: span 4; }
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
            .form-control[readonly] { background-color: #1e293b; color: #94a3b8; cursor: not-allowed; }

            .warning-text { color: var(--warning); font-size: 0.8rem; margin-top: 5px; display: block; font-style: italic; }

            /* Cấu hình checkbox trạng thái */
            .status-container {
                display: flex;
                align-items: center;
                height: 100%;
                padding-top: 25px; 
            }
            .status-checkbox { width: 20px; height: 20px; cursor: pointer; accent-color: var(--success); }
            .status-label { margin-left: 10px; color: var(--success); font-weight: bold; cursor: pointer; }

            /* Các nút bấm Form */
            .form-actions { display: flex; justify-content: flex-end; gap: 15px; margin-top: 10px; }
            .btn {
                padding: 10px 30px;
                border-radius: 30px;
                font-weight: bold;
                cursor: pointer;
                border: none;
                transition: 0.3s;
                font-size: 0.95rem;
            }
            .btn-primary { background-color: var(--accent-blue); color: white; }
            .btn-primary:hover { background-color: var(--accent-hover); }
            .btn-secondary { background-color: transparent; border: 1px solid var(--secondary); color: var(--text-main); }
            .btn-secondary:hover { background-color: var(--secondary); }

            /* --- 8. BẢNG DỮ LIỆU --- */
            .table-responsive { overflow-x: auto; }
            .custom-table { width: 100%; border-collapse: collapse; text-align: center; min-width: 800px; }
            .custom-table th, .custom-table td { border: 1px solid var(--border-color); padding: 14px 15px; }
            .custom-table th { background-color: var(--bg-darker); color: var(--accent-blue); text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; }
            .custom-table td { background-color: var(--bg-card); vertical-align: middle; }
            .custom-table tr:hover td { background-color: #253347; }
            
            .text-left { text-align: left; }
            .fw-bold { font-weight: bold; }
            .text-accent { color: var(--accent-blue); }
            .text-warning { color: var(--warning); }
            
            .badge { padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: bold; display: inline-block; }
            .bg-success { background-color: rgba(16, 185, 129, 0.2); color: var(--success); border: 1px solid var(--success); }
            .bg-danger { background-color: rgba(239, 68, 68, 0.2); color: var(--danger); border: 1px solid var(--danger); }

            /* Nút thao tác trong bảng (Sửa, Xóa) */
            .action-buttons { display: flex; justify-content: center; gap: 8px; }
            .btn-sm { padding: 5px 12px; border-radius: 4px; font-size: 0.85rem; font-weight: bold; border: 1px solid transparent; background: transparent; transition: 0.3s; cursor: pointer; }
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
                <h2 class="page-title">Quản Lý Phòng Chiếu & Ghế</h2>

                <c:if test="${not empty msg}">
                    <div class="alert" id="systemAlert">
                        <span>Hệ thống: ${msg}</span>
                        <button class="alert-close" onclick="document.getElementById('systemAlert').style.display='none'">X</button>
                    </div>
                </c:if>

                <div class="admin-card">
                    <h4 class="card-title">${not empty ROOM_EDIT ? 'Sửa Thông Tin Phòng Chiếu' : 'Thêm Phòng Chiếu Mới'}</h4>
                    
                    <form action="MainController" method="POST">
                        <input type="hidden" name="action" value="adminRoom">
                        <input type="hidden" name="subAction" value="${not empty ROOM_EDIT ? 'update' : 'add'}">
                        <input type="hidden" name="roomID" value="${not empty ROOM_EDIT ? ROOM_EDIT.roomID : '0'}">

                        <div class="form-grid">
                            <div class="col-4">
                                <label class="form-label">Thuộc Rạp Phim:</label>
                                <select name="cinemaID" class="form-select" required>
                                    <option value="" disabled ${empty ROOM_EDIT ? 'selected' : ''}>-- Chọn Rạp Phim --</option>
                                    <c:forEach var="cinema" items="${CINEMA_LIST}">
                                        <option value="${cinema.cinemaID}" ${ROOM_EDIT.cinemaID == cinema.cinemaID ? 'selected' : ''}>${cinema.cinemaName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-3">
                                <label class="form-label">Tên Phòng:</label>
                                <input type="text" name="roomName" class="form-control" value="${ROOM_EDIT.roomName}" placeholder="VD: Phòng 1" required>
                            </div>

                            <div class="col-3">
                                <label class="form-label">Sức chứa (Tổng ghế):</label>
                                <input type="number" name="capacity" class="form-control" value="${not empty ROOM_EDIT ? ROOM_EDIT.capacity : '50'}" min="10" ${not empty ROOM_EDIT ? 'readonly' : 'required'}>
                                <span class="warning-text">* Không thể sửa sức chứa sau khi tạo để tránh hỏng sơ đồ ghế</span>
                            </div>

                            <div class="col-2">
                                <div class="status-container">
                                    <input type="checkbox" name="status" id="statusCheck" class="status-checkbox" ${empty ROOM_EDIT or ROOM_EDIT.status ? 'checked' : ''}>
                                    <label for="statusCheck" class="status-label">Hoạt động</label>
                                </div>
                            </div>

                            <div class="col-12 form-actions">
                                <c:if test="${not empty ROOM_EDIT}">
                                    <a href="MainController?action=adminRoom" class="btn btn-secondary">Hủy Sửa</a>
                                </c:if>
                                <button type="submit" class="btn btn-primary">Lưu Phòng Chiếu</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="admin-card">
                    <h4 class="card-title">Danh sách Phòng chiếu</h4>
                    
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Mã Phòng</th>
                                    <th class="text-left">Tên Rạp</th>
                                    <th>Tên Phòng</th>
                                    <th>Sức chứa (Ghế)</th>
                                    <th>Trạng Thái</th>
                                    <th>Thao Tác</th>                            
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="room" items="${ROOM_LIST}">
                                    <tr>
                                        <td>${room.roomID}</td>
                                        <td class="text-left fw-bold text-accent">${room.cinemaName}</td>
                                        <td>${room.roomName}</td>
                                        <td class="fw-bold text-warning">${room.capacity}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${room.status}">
                                                    <span class="badge bg-success">Mở cửa</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Đang sửa chữa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="MainController?action=adminRoom&subAction=edit&roomID=${room.roomID}" class="btn-sm btn-edit">Sửa</a>
                                                <a href="MainController?action=adminRoom&subAction=delete&roomID=${room.roomID}" class="btn-sm btn-delete" onclick="return confirm('Toàn bộ sơ đồ ghế của phòng này sẽ bị xóa. Tiếp tục?');">Xóa</a>
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
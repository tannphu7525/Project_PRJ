<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản Lý Phòng Chiếu - PRJ Cinema</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --bg-body: #111827;
                --bg-card: #1f2937;
                --accent-blue: #00d4ff;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --border-color: #334155;
            }
            body {
                background-color: var(--bg-body);
                color: var(--text-main);
                overflow-x: hidden;
            }
            .navbar {
                background-color: #0b0f19;
                border-bottom: 1px solid var(--border-color);
                box-shadow: 0 4px 15px rgba(0,0,0,0.5);
                z-index: 1030;
            }
            .navbar-brand {
                color: var(--accent-blue) !important;
                font-size: 1.5rem;
                letter-spacing: 1px;
            }
            .sidebar {
                background-color: #0b0f19;
                min-height: calc(100vh - 60px);
                border-right: 1px solid var(--border-color);
                padding-top: 20px;
                position: sticky;
                top: 60px;
            }
            .sidebar-link {
                color: var(--text-muted);
                padding: 15px 25px;
                display: block;
                text-decoration: none;
                font-weight: 500;
                font-size: 1.1rem;
                border-bottom: 1px solid #1f2937;
                transition: all 0.3s ease;
            }
            .sidebar-link:hover, .sidebar-link.active {
                background-color: var(--bg-card);
                color: var(--accent-blue);
                border-left: 5px solid var(--accent-blue);
            }
            .sidebar-link i {
                width: 30px;
            }
            .main-content {
                padding: 30px;
            }
            .admin-card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                margin-bottom: 30px;
            }
            .card-title {
                color: var(--accent-blue);
                border-left: 4px solid var(--accent-blue);
                padding-left: 15px;
                font-weight: bold;
                margin-bottom: 25px;
                text-transform: uppercase;
            }
            .table-dark {
                background-color: transparent;
            }
            .table-dark th {
                background-color: #111827;
                color: var(--accent-blue);
                border-color: var(--border-color);
            }
            .table-dark td {
                background-color: var(--bg-card);
                border-color: var(--border-color);
                vertical-align: middle;
            }
            .form-control, .form-select {
                background-color: #0f172a;
                border: 1px solid var(--border-color);
                color: white;
            }
            .form-control:focus, .form-select:focus {
                border-color: var(--accent-blue);
                color: white;
                background-color: #0f172a;
                box-shadow: none;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container-fluid px-4">
                <a class="navbar-brand fw-bold" href="#"><i class="fas fa-film me-2"></i>PRJ CINEMA <span class="text-white fs-6 ms-2 fw-normal">| Hệ thống Quản trị</span></a>
                <a href="MainController?action=logout" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold"><i class="fas fa-sign-out-alt me-1"></i> Thoát</a>
            </div>
        </nav>

        <div class="container-fluid">
            <div class="row">   
                <jsp:include page="admin_sidebar.jsp" />

                <div class="col-md-9 col-lg-10 main-content">
                    <h2 class="fw-bold mb-4 text-white">QUẢN LÝ PHÒNG CHIẾU & GHẾ</h2>

                    <c:if test="${not empty msg}">
                        <div class="alert alert-info alert-dismissible fade show fw-bold" role="alert">
                            <i class="fas fa-info-circle me-2"></i> ${msg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="admin-card">
                        <h4 class="card-title"><i class="fas fa-plus-circle me-2"></i>Thông tin Phòng chiếu</h4>
                        <form action="MainController" method="POST" class="row g-3">
                            <input type="hidden" name="action" value="adminRoom">
                            <input type="hidden" name="subAction" value="${not empty ROOM_EDIT ? 'update' : 'add'}">
                            <input type="hidden" name="roomID" value="${not empty ROOM_EDIT ? ROOM_EDIT.roomID : '0'}">

                            <div class="col-md-4">
                                <label class="form-label text-muted">Thuộc Rạp Phim:</label>
                                <select name="cinemaID" class="form-select" required>
                                    <option value="" disabled ${empty ROOM_EDIT ? 'selected' : ''}>-- Chọn Rạp Phim --</option>

                                    <c:forEach var="cinema" items="${CINEMA_LIST}">
                                        <option value="${cinema.cinemaID}" ${ROOM_EDIT.cinemaID == cinema.cinemaID ? 'selected' : ''}>${cinema.cinemaName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label text-muted">Tên Phòng:</label>
                                <input type="text" name="roomName" class="form-control" value="${ROOM_EDIT.roomName}" placeholder="VD: Phòng 1" required>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label text-muted">Sức chứa (Tổng ghế):</label>
                                <input type="number" name="capacity" class="form-control" value="${not empty ROOM_EDIT ? ROOM_EDIT.capacity : '50'}" min="10" ${not empty ROOM_EDIT ? 'readonly' : 'required'}>
                                <small class="text-warning" style="font-size: 0.8rem;">* Không thể sửa sức chứa sau khi tạo để tránh hỏng sơ đồ ghế</small>
                            </div>

                            <div class="col-md-2 d-flex align-items-center">
                                <div class="form-check form-switch mt-3">
                                    <input class="form-check-input" type="checkbox" name="status" id="statusSwitch" ${empty ROOM_EDIT or ROOM_EDIT.status ? 'checked' : ''} style="width: 2.5em; height: 1.25em;">
                                    <label class="form-check-label ms-2 text-success fw-bold">Hoạt động</label>
                                </div>
                            </div>

                            <div class="col-12 mt-4 text-end">
                                <c:if test="${not empty ROOM_EDIT}">
                                    <a href="MainController?action=adminRoom" class="btn btn-secondary fw-bold px-4 rounded-pill me-2">Hủy Sửa</a>
                                </c:if>
                                <button type="submit" class="btn btn-primary fw-bold px-5 rounded-pill">
                                    <i class="fas fa-save me-2"></i>Lưu Phòng
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="admin-card">
                        <h4 class="card-title"><i class="fas fa-list me-2"></i>Danh sách Phòng chiếu</h4>
                        <div class="table-responsive">
                            <table class="table table-dark table-hover table-bordered align-middle text-center mb-0">
                                <thead>
                                    <tr>
                                        <th>Mã Phòng</th>
                                        <th class="text-start">Tên Rạp</th>
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
                                            <td class="text-start fw-bold text-accent">${room.cinemaName}</td>
                                            <td>${room.roomName}</td>
                                            <td class="fw-bold text-warning">${room.capacity}</td>
                                            <td>
                                                <span class="badge ${room.status ? 'bg-success' : 'bg-danger'} px-3 py-2">
                                                    ${room.status ? 'Mở cửa' : 'Đang sửa chữa'}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="MainController?action=adminRoom&subAction=edit&roomID=${room.roomID}" class="btn btn-sm btn-outline-warning" title="Sửa"><i class="fas fa-edit"></i></a>
                                                <a href="MainController?action=adminRoom&subAction=delete&roomID=${room.roomID}" class="btn btn-sm btn-outline-danger" title="Xóa" onclick="return confirm('Toàn bộ sơ đồ ghế của phòng này sẽ bị xóa. Tiếp tục?');"><i class="fas fa-trash"></i></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div> 
            </div> 
        </div> 
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
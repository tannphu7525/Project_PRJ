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

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

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
                font-family: 'Roboto', sans-serif;
                color: var(--text-main);
                overflow-x: hidden;
            }
            /* NAVBAR */
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

            /* SIDEBAR MENU CỐ ĐỊNH */
            .sidebar {
                background-color: #0b0f19;
                border-right: 1px solid var(--border-color);
                padding-top: 20px;
                position: sticky;
                top: 70px; 
                height: calc(100vh - 70px); 
                overflow-y: auto; 
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
            .sidebar-link i { width: 30px; }
            
            /* Tùy chỉnh thanh cuộn Sidebar */
            .sidebar::-webkit-scrollbar { width: 6px; }
            .sidebar::-webkit-scrollbar-thumb { background-color: #334155; border-radius: 10px; }

            /* MAIN CONTENT */
            .main-content {
                padding: 30px;
                background-color: var(--bg-body);
                min-height: calc(100vh - 70px);
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

            /* TABLES & FORMS */
            .table-dark { background-color: transparent; }
            .table-dark th { background-color: #111827; color: var(--accent-blue); border-color: var(--border-color); }
            .table-dark td { background-color: var(--bg-card); border-color: var(--border-color); vertical-align: middle; }
            .form-label { font-weight: 500; color: #cbd5e1; }
            .form-control, .form-select { background-color: #0f172a; border: 1px solid var(--border-color); color: white; }
            .form-control:focus, .form-select:focus { border-color: var(--accent-blue); color: white; background-color: #0f172a; box-shadow: 0 0 0 0.25rem rgba(0, 212, 255, 0.25); }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container-fluid px-4">
                <a class="navbar-brand fw-bold" href="HomeController">
                    <i class="fas fa-film me-2"></i>PRJ CINEMA <span class="text-white fs-6 ms-2 fw-normal">| Hệ thống Quản trị</span>
                </a>
                <div class="d-flex align-items-center">
                    
                    <a href="MainController?action=logout" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold">
                        <i class="fas fa-sign-out-alt me-1"></i> Thoát
                    </a>
                </div>
            </div>
        </nav>

        <div class="container-fluid">
            <div class="row">

                <div class="col-md-3 col-lg-2 p-0 sidebar d-none d-md-block">
                    <a href="HomeController" class="sidebar-link">
                        <i class="fas fa-home"></i> Trang chủ
                    </a>

                    <a href="MainController?action=adminMovie&subAction=list" class="sidebar-link">
                        <i class="fas fa-video"></i> Quản lý Phim
                    </a>

                    <a href="MainController?action=adminShowtime&subAction=list" class="sidebar-link active">
                        <i class="fas fa-calendar-alt"></i> Quản lý Lịch chiếu
                    </a>

                    <a href="MainController?action=adminVoucher" class="sidebar-link">
                        <i class="fas fa-ticket-alt"></i> Quản lý Voucher
                    </a>
                </div>

                <div class="col-md-9 col-lg-10 main-content">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold mb-0 text-white">QUẢN LÝ LỊCH CHIẾU</h2>
                        <a href="MainController?action=adminShowtime&subAction=list" class="btn btn-info px-4 rounded-pill fw-bold">
                            <i class="fas fa-sync-alt me-2"></i>Tải lại dữ liệu
                        </a>
                    </div>

                    <c:if test="${not empty msg}">
                        <div class="alert alert-success alert-dismissible fade show fw-bold" role="alert">
                            <i class="fas fa-check-circle me-2"></i> ${msg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="admin-card">
                        <h4 class="card-title"><i class="fas fa-calendar-plus me-2"></i>Thêm Lịch Chiếu Mới</h4>

                        <form action="MainController" method="POST" class="row g-3">
                            <input type="hidden" name="action" value="adminShowtime">
                            <input type="hidden" name="subAction" value="add">

                            <div class="col-md-6">
                                <label class="form-label">Chọn Phim:</label>
                                <select name="movieID" class="form-select" required>
                                    <c:forEach var="movie" items="${MOVIE_LIST}">
                                        <option value="${movie.movieID}">${movie.title}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Chọn Phòng chiếu:</label>
                                <select name="roomID" class="form-select" required>
                                    <option value="" disabled selected>-- Hãy chọn phòng chiếu --</option>
                                    <c:forEach var="room" items="${ROOM_LIST}">
                                        <option value="${room.roomID}">[ ${room.cinemaName} ] - ${room.roomName} (Sức chứa: ${room.capacity})</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Ngày chiếu:</label>
                                <input type="date" name="showDate" class="form-control" required>
                            </div>

                            <div class="col-md-2">
                                <label class="form-label">Giờ bắt đầu:</label>
                                <input type="time" name="startTime" class="form-control" required>
                            </div>

                            <div class="col-md-2">
                                <label class="form-label">Giờ kết thúc:</label>
                                <input type="time" name="endTime" class="form-control" required>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Giá vé suất này (VNĐ):</label>
                                <input type="number" name="price" class="form-control" value="80000" min="0" required>
                            </div>

                            <div class="col-md-2 d-flex align-items-end">
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input" type="checkbox" name="status" id="statusSwitch" checked style="width: 2.5em; height: 1.25em;">
                                    <label class="form-check-label ms-2 text-success fw-bold" for="statusSwitch">Mở Bán</label>
                                </div>
                            </div>

                            <div class="col-12 mt-4 text-end">
                                <button type="submit" class="btn btn-primary fw-bold px-5 rounded-pill">
                                    <i class="fas fa-save me-2"></i>Lưu Lịch Chiếu
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="admin-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="card-title mb-0"><i class="fas fa-list me-2"></i>Danh sách Lịch Chiếu</h4>
                            
                            <form action="MainController" method="GET" class="d-flex">
                                <input type="hidden" name="action" value="adminShowtime">
                                <input type="hidden" name="subAction" value="search">
                                <input type="text" name="keyword" class="form-control me-2" placeholder="Nhập Tên phim, Rạp..." value="${param.keyword}" style="width: 280px; background-color: #0f172a; color: white; border: 1px solid #334155;">
                                <button type="submit" class="btn btn-info fw-bold"><i class="fas fa-search"></i></button>
                            </form>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-dark table-hover table-bordered align-middle text-center mb-0">
                                <thead>
                                    <tr>
                                        <th>Mã</th>
                                        <th class="text-start">Tên Phim</th>
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
                                            <td><span class="badge bg-secondary fs-6">${st.showtimeID}</span></td>
                                            <td class="text-start text-accent fw-bold">${st.movieTitle}</td>
                                            <td>${st.cinemaName}</td>
                                            <td>${st.roomName}</td>
                                            <td>${st.showDate}</td>
                                            <td class="fw-bold text-light">${fn:substring(st.startTime, 0, 5)}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${st.endTime != null}">${fn:substring(st.endTime, 0, 5)}</c:when>
                                                    <c:otherwise><span class="text-danger fst-italic">Chưa cập nhật</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-warning fw-bold">
                                                <fmt:formatNumber value="${st.price}" type="number" pattern="#,###"/> ₫
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${st.status}">
                                                        <span class="badge bg-success px-3 py-2">Mở bán</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger px-3 py-2">Đã khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div> </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
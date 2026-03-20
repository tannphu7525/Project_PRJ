<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản Lý Người Dùng - PRJ Cinema</title>
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
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container-fluid px-4">
                <a class="navbar-brand fw-bold" href="#"><i class="fas fa-film me-2"></i>PRJ CINEMA <span class="text-white fs-6 ms-2 fw-normal">| Hệ thống Quản trị</span></a>
                <div class="d-flex align-items-center">
                    <span class="me-3 text-muted small">Xin chào, <b>${sessionScope.LOGIN_USER.fullName}</b></span>
                    <a href="MainController?action=logout" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold"><i class="fas fa-sign-out-alt me-1"></i> Thoát</a>
                </div>
            </div>
        </nav>

        <div class="container-fluid">
            <div class="row">   
                <jsp:include page="admin_sidebar.jsp" />

                <div class="col-md-9 col-lg-10 main-content">
                    <h2 class="fw-bold mb-4 text-white">QUẢN LÝ NGƯỜI DÙNG</h2>

                    <c:if test="${not empty msg}">
                        <div class="alert alert-info alert-dismissible fade show fw-bold" role="alert">
                            <i class="fas fa-info-circle me-2"></i> ${msg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="admin-card">
                        <h4 class="card-title"><i class="fas fa-users-cog me-2"></i>Danh sách Tài khoản</h4>
                        <div class="table-responsive">
                            <table class="table table-dark table-hover table-bordered align-middle text-center mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th class="text-start">Username</th>
                                        <th class="text-start">Họ và Tên</th>
                                        <th class="text-start">Email</th>
                                        <th>Vai trò</th>
                                        <th>Trạng Thái</th>
                                        <th>Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${USER_LIST}">
                                        <tr>
                                            <td>${u.userID}</td>
                                            <td class="text-start fw-bold text-light">${u.username}</td>
                                            <td class="text-start">${u.fullName}</td>
                                            <td class="text-start text-muted">${u.email}</td>
                                            <td>
                                                <span class="badge ${u.role eq 'ADMIN' ? 'bg-warning text-dark' : 'bg-secondary'} px-3 py-2">
                                                    ${u.role}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge ${u.status ? 'bg-success' : 'bg-danger'} px-3 py-2">
                                                    ${u.status ? 'Hoạt động' : 'Bị Khóa'}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.userID eq sessionScope.LOGIN_USER.userID}">
                                                        <span class="text-muted fst-italic small">Tài khoản của bạn</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="MainController?action=adminUser&subAction=toggleStatus&userID=${u.userID}&currentStatus=${u.status}" 
                                                           class="btn btn-sm ${u.status ? 'btn-outline-danger' : 'btn-outline-success'} me-1" 
                                                           title="${u.status ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}"
                                                           onclick="return confirm('Xác nhận ${u.status ? 'Khóa' : 'Mở khóa'} tài khoản này?');">
                                                            <i class="fas ${u.status ? 'fa-ban' : 'fa-unlock'}"></i>
                                                        </a>

                                                        <c:choose>
                                                            <c:when test="${u.role eq 'CUSTOMER'}">
                                                                <a href="MainController?action=adminUser&subAction=changeRole&userID=${u.userID}&role=ADMIN" 
                                                                   class="btn btn-sm btn-outline-warning" title="Nâng cấp lên Admin"
                                                                   onclick="return confirm('Cấp quyền Quản trị viên cho người dùng này?');">
                                                                    <i class="fas fa-level-up-alt"></i>
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="MainController?action=adminUser&subAction=changeRole&userID=${u.userID}&role=CUSTOMER" 
                                                                   class="btn btn-sm btn-outline-secondary" title="Hạ quyền xuống Customer"
                                                                   onclick="return confirm('Hạ quyền người dùng này xuống Khách hàng?');">
                                                                    <i class="fas fa-level-down-alt"></i>
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
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
        </div> 
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản Lý Người Dùng - PRJ Cinema</title>
        
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
            .user-area { display: flex; align-items: center; }
            .btn-logout {
                border: 1px solid var(--danger);
                color: var(--danger);
                padding: 6px 18px;
                border-radius: 20px;
                font-weight: bold;
                transition: 0.3s;
                font-size: 0.85rem;
            }
            .btn-logout:hover { background-color: var(--danger); color: white; }

            /* --- 3. BỐ CỤC CHÍNH --- */
            .wrapper { display: flex; flex: 1; overflow: hidden; }
            .sidebar { width: 240px; background-color: var(--bg-darker); border-right: 1px solid var(--border-color); overflow-y: auto; padding-top: 20px; }
            .sidebar-link { color: var(--text-muted); padding: 15px 25px; display: block; font-weight: 500; border-bottom: 1px solid #1a2333; transition: 0.3s; }
            .sidebar-link:hover, .sidebar-link.active { background-color: var(--bg-card); color: var(--accent-blue); border-left: 5px solid var(--accent-blue); }

            /* --- 4. NỘI DUNG CHÍNH --- */
            .main-content { flex: 1; padding: 30px; overflow-y: auto; }
            .page-title { font-size: 1.6rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 25px; font-weight: bold; }

            /* Thông báo */
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
            .alert-close { background: transparent; border: none; color: white; font-size: 1.2rem; cursor: pointer; }

            /* Khung bảng */
            .admin-card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }
            .card-title { color: var(--accent-blue); border-left: 4px solid var(--accent-blue); padding-left: 15px; margin-bottom: 25px; text-transform: uppercase; font-weight: bold; }

            /* Table */
            .table-responsive { overflow-x: auto; }
            .custom-table { width: 100%; border-collapse: collapse; text-align: center; min-width: 950px; font-size: 0.9rem; }
            .custom-table th, .custom-table td { border: 1px solid var(--border-color); padding: 12px 10px; }
            .custom-table th { background-color: var(--bg-darker); color: var(--accent-blue); text-transform: uppercase; font-size: 0.8rem; }
            .custom-table tr:hover td { background-color: #253347; }
            .text-left { text-align: left; }

            /* Badges */
            .badge { padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; display: inline-block; }
            .bg-secondary { background-color: #475569; color: white;}
            .bg-warning { background-color: var(--warning); color: #000; }
            .bg-success { background-color: var(--success); color: white; }
            .bg-danger { background-color: var(--danger); color: white; }

            /* --- 5. TỐI ƯU CỘT THAO TÁC --- */
            .action-buttons { 
                display: grid; 
                grid-template-columns: 1fr 1fr; 
                gap: 6px; 
                width: 200px; 
                margin: 0 auto; 
            }

            .btn-action-sm {
                display: flex;
                align-items: center;
                justify-content: center;
                height: 30px;
                border-radius: 4px;
                font-size: 0.7rem;
                font-weight: 800;
                text-transform: uppercase;
                transition: all 0.2s ease;
                border: 1px solid;
                background: transparent;
                cursor: pointer;
                white-space: nowrap;
            }

            /* Màu sắc riêng biệt cho từng loại nút */
            .btn-lock { color: #f87171; border-color: rgba(248, 113, 113, 0.4); }
            .btn-lock:hover { background-color: var(--danger); color: white; border-color: var(--danger); }

            .btn-unlock { color: #34d399; border-color: rgba(52, 211, 153, 0.4); }
            .btn-unlock:hover { background-color: var(--success); color: white; border-color: var(--success); }

            .btn-upgrade { color: #fbbf24; border-color: rgba(251, 191, 36, 0.4); }
            .btn-upgrade:hover { background-color: var(--warning); color: black; border-color: var(--warning); }

            .btn-downgrade { color: #94a3b8; border-color: rgba(148, 163, 184, 0.4); }
            .btn-downgrade:hover { background-color: var(--secondary); color: white; border-color: var(--secondary); }

            .self-account-msg { 
                font-style: italic; 
                color: var(--secondary); 
                font-size: 0.8rem;
                background: rgba(255,255,255,0.05);
                padding: 5px;
                border-radius: 4px;
                display: block;
            }

        </style>
    </head>
    <body>

        <nav class="navbar">
            <a class="navbar-brand" href="HomeController">PRJ CINEMA <span>| Admin Control</span></a>
            <div class="user-area">
                <a href="MainController?action=logout" class="btn-logout">LOG OUT</a>
            </div>
        </nav>

        <div class="wrapper">
            <jsp:include page="admin_sidebar.jsp" />

            <div class="main-content">
                <h2 class="page-title">Quản Lý Người Dùng</h2>

                <c:if test="${not empty msg}">
                    <div class="alert" id="infoAlert">
                        <span>Hệ thống: ${msg}</span>
                        <button class="alert-close" onclick="document.getElementById('infoAlert').style.display='none'">✖</button>
                    </div>
                </c:if>

                <div class="admin-card">
                    <h4 class="card-title">Danh sách Tài khoản</h4>
                    
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th width="50">ID</th>
                                    <th class="text-left">Username</th>
                                    <th class="text-left">Họ và Tên</th>
                                    <th class="text-left">Email</th>
                                    <th width="100">Vai trò</th>
                                    <th width="120">Trạng Thái</th>
                                    <th width="220">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${USER_LIST}">
                                    <tr>
                                        <td>${u.userID}</td>
                                        <td class="text-left fw-bold text-light">${u.username}</td>
                                        <td class="text-left">${u.fullName}</td>
                                        <td class="text-left text-muted">${u.email}</td>
                                        <td>
                                            <span class="badge ${u.role eq 'ADMIN' ? 'bg-warning' : 'bg-secondary'}">
                                                ${u.role}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${u.status ? 'bg-success' : 'bg-danger'}">
                                                ${u.status ? 'Hoạt động' : 'Bị Khóa'}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.userID eq sessionScope.LOGIN_USER.userID}">
                                                    <span class="self-account-msg">Tài khoản hiện tại</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="action-buttons">
                                                        <c:choose>
                                                            <c:when test="${u.status}">
                                                                <a href="MainController?action=adminUser&subAction=toggleStatus&userID=${u.userID}&currentStatus=${u.status}" 
                                                                   class="btn-action-sm btn-lock" 
                                                                   onclick="return confirm('Khóa người dùng này?');">Khóa</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="MainController?action=adminUser&subAction=toggleStatus&userID=${u.userID}&currentStatus=${u.status}" 
                                                                   class="btn-action-sm btn-unlock" 
                                                                   onclick="return confirm('Mở khóa người dùng này?');">Mở Khóa</a>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <c:choose>
                                                            <c:when test="${u.role eq 'CUSTOMER'}">
                                                                <a href="MainController?action=adminUser&subAction=changeRole&userID=${u.userID}&role=ADMIN" 
                                                                   class="btn-action-sm btn-upgrade"
                                                                   onclick="return confirm('Cấp quyền Admin cho người dùng này?');">Lên Admin</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="MainController?action=adminUser&subAction=changeRole&userID=${u.userID}&role=CUSTOMER" 
                                                                   class="btn-action-sm btn-downgrade"
                                                                   onclick="return confirm('Hạ quyền người dùng này?');">Hạ Quyền</a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
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
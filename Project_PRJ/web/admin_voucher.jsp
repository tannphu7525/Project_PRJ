<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản lý Voucher - PRJ Cinema</title>

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
            
            .user-area { display: flex; align-items: center; }
            .user-greeting { margin-right: 20px; font-size: 0.95rem; color: var(--text-muted); }
            .user-greeting b { color: var(--warning); font-weight: bold; }
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
            .page-title { font-size: 1.6rem; text-transform: uppercase; font-weight: bold; margin: 0; }
            
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

            /* --- 5. KHUNG & FORM LƯỚI --- */
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
                font-size: 1.2rem;
                text-transform: uppercase;
                font-weight: bold;
                margin-bottom: 25px;
            }

            /* Chia 4 cột đều nhau */
            .form-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
            .col-full { grid-column: 1 / -1; }

            .form-label { display: block; margin-bottom: 8px; font-weight: 500; color: #cbd5e1; font-size: 0.95rem; }
            .form-control {
                width: 100%;
                background-color: #0f172a;
                border: 1px solid var(--border-color);
                color: white;
                padding: 10px 15px;
                border-radius: 6px;
                font-family: inherit;
                font-size: 1rem;
            }
            .form-control:focus { outline: none; border-color: var(--accent-blue); box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);}
            .form-control[readonly] { background-color: #1e293b; color: #94a3b8; cursor: not-allowed; }

            .text-uppercase { text-transform: uppercase; }
            .warning-text { color: var(--danger); font-size: 0.85rem; font-style: italic; margin-top: 5px; display: block; }

            /* Trạng thái & Nút Form */
            .form-footer {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid var(--border-color);
            }
            .status-container { display: flex; align-items: center; }
            .status-checkbox { width: 20px; height: 20px; cursor: pointer; accent-color: var(--success); }
            .status-label { margin-left: 10px; color: var(--success); font-weight: bold; cursor: pointer; }

            .form-actions { display: flex; gap: 15px; }
            .btn { padding: 10px 30px; border-radius: 30px; font-weight: bold; cursor: pointer; border: none; font-size: 0.95rem; transition: 0.3s; }
            .btn-primary { background-color: var(--accent-blue); color: white; }
            .btn-primary:hover { background-color: var(--accent-hover); }
            .btn-secondary { background-color: transparent; border: 1px solid var(--secondary); color: var(--text-main); }
            .btn-secondary:hover { background-color: var(--secondary); }

            /* --- 6. BẢNG DỮ LIỆU --- */
            .table-responsive { overflow-x: auto; }
            .custom-table { width: 100%; border-collapse: collapse; text-align: center; min-width: 800px; }
            .custom-table th, .custom-table td { border: 1px solid var(--border-color); padding: 12px 15px; }
            .custom-table th { background-color: var(--bg-darker); color: var(--accent-blue); text-transform: uppercase; font-size: 0.85rem; }
            .custom-table td { background-color: var(--bg-card); vertical-align: middle; }
            .custom-table tr:hover td { background-color: #253347; }
            
            .text-left { text-align: left; }
            .fw-bold { font-weight: bold; }
            .text-info { color: var(--info); }
            .text-warning { color: var(--warning); }
            
            .badge { padding: 6px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: bold; display: inline-block; }
            .bg-secondary { background-color: #475569; color: white;}
            .bg-success { background-color: rgba(16, 185, 129, 0.2); color: var(--success); border: 1px solid var(--success); }
            .bg-primary { background-color: rgba(59, 130, 246, 0.2); color: var(--accent-blue); border: 1px solid var(--accent-blue); }
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
            <div class="user-area">
                <a href="MainController?action=logout" class="btn-logout">Log Out</a>
            </div>
        </nav>

        <div class="wrapper">
            <jsp:include page="admin_sidebar.jsp" />

            <div class="main-content">
                
                <div class="page-header">
                    <h2 class="page-title">Quản Lý Voucher</h2>
                    <a href="MainController?action=adminVoucher&subAction=list" class="btn-action">Tải lại dữ liệu</a>
                </div>

                <c:if test="${not empty msg}">
                    <div class="alert" id="systemAlert">
                        <span>Hệ thống: ${msg}</span>
                        <button class="alert-close" onclick="document.getElementById('systemAlert').style.display='none'">X</button>
                    </div>
                </c:if>

                <div class="admin-card">
                    <h4 class="card-title">
                        <c:choose>
                            <c:when test="${not empty VOUCHER_EDIT}">
                                <span style="color: var(--warning);">Cập Nhật Voucher: ${VOUCHER_EDIT.voucherCode}</span>
                            </c:when>
                            <c:otherwise>Thêm Voucher Mới</c:otherwise>
                        </c:choose>
                    </h4>

                    <form action="MainController" method="POST">
                        <input type="hidden" name="action" value="adminVoucher">
                        <input type="hidden" name="subAction" value="${not empty VOUCHER_EDIT ? 'update' : 'add'}">

                        <div class="form-grid">
                            <div>
                                <label class="form-label" style="color: var(--warning);">Mã Voucher (Code):</label>
                                <input type="text" name="voucherCode" class="form-control text-uppercase fw-bold" required 
                                       value="${VOUCHER_EDIT.voucherCode}" 
                                       ${not empty VOUCHER_EDIT ? 'readonly' : ''} 
                                       placeholder="VD: GIAITHUONG50">
                                <c:if test="${not empty VOUCHER_EDIT}">
                                    <span class="warning-text">Lưu ý: Không thể sửa mã Code</span>
                                </c:if>
                            </div>

                            <div>
                                <label class="form-label">Giảm giá (%):</label>
                                <input type="number" name="discountPercent" class="form-control" required min="1" max="100" value="${not empty VOUCHER_EDIT ? VOUCHER_EDIT.discountPercent : '10'}">
                            </div>

                            <div>
                                <label class="form-label">Số lượng (Lượt dùng):</label>
                                <input type="number" name="quantity" class="form-control" required min="0" value="${not empty VOUCHER_EDIT ? VOUCHER_EDIT.quantity : '100'}">
                            </div>

                            <div>
                                <label class="form-label">Hạn sử dụng:</label>
                                <input type="date" name="expiryDate" class="form-control" required value="${VOUCHER_EDIT.expiryDate}">
                            </div>
                        </div>

                        <div class="form-footer">
                            <div class="status-container">
                                <input type="checkbox" name="status" id="statusCheck" class="status-checkbox" ${empty VOUCHER_EDIT or VOUCHER_EDIT.status ? 'checked' : ''}>
                                <label for="statusCheck" class="status-label">Kích hoạt (Active)</label>
                            </div>

                            <div class="form-actions">
                                <c:if test="${not empty VOUCHER_EDIT}">
                                    <a href="MainController?action=adminVoucher&subAction=list" class="btn btn-secondary">Hủy Sửa</a>
                                </c:if>
                                <button type="submit" class="btn btn-primary">Lưu Voucher</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="admin-card">
                    <h4 class="card-title">Danh sách Voucher hệ thống</h4>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th class="text-left">Mã Voucher</th>
                                    <th>Giảm giá (%)</th>
                                    <th>Lượt còn lại</th>
                                    <th>Hạn sử dụng</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="v" items="${VOUCHER_LIST}">
                                    <tr>
                                        <td class="text-left text-warning fw-bold" style="font-size: 1.1rem;">${v.voucherCode}</td>
                                        <td class="fw-bold text-info">${v.discountPercent}%</td>
                                        <td>
                                            <span class="badge ${v.quantity > 0 ? 'bg-primary' : 'bg-danger'}">${v.quantity}</span>
                                        </td>
                                        <td>${v.expiryDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${v.status and v.quantity > 0}">
                                                    <span class="badge bg-success">Đang chạy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Ngưng / Hết lượt</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="MainController?action=adminVoucher&subAction=edit&voucherCode=${v.voucherCode}" class="btn-sm btn-edit">Sửa</a>
                                                <a href="MainController?action=adminVoucher&subAction=delete&voucherCode=${v.voucherCode}" class="btn-sm btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa mã giảm giá này?');">Xóa</a>
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
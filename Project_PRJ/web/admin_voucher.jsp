<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản lý Voucher - PRJ Cinema</title>

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
            .navbar { background-color: #0b0f19; border-bottom: 1px solid var(--border-color); box-shadow: 0 4px 15px rgba(0,0,0,0.5); z-index: 1030; }
            .navbar-brand { color: var(--accent-blue) !important; font-size: 1.5rem; letter-spacing: 1px; }

            /* SIDEBAR */
            .sidebar { background-color: #0b0f19; border-right: 1px solid var(--border-color); padding-top: 20px; position: sticky; top: 70px; height: calc(100vh - 70px); overflow-y: auto; }
            .sidebar-link { color: var(--text-muted); padding: 15px 25px; display: block; text-decoration: none; font-weight: 500; font-size: 1.1rem; border-bottom: 1px solid #1f2937; transition: all 0.3s ease; }
            .sidebar-link:hover, .sidebar-link.active { background-color: var(--bg-card); color: var(--accent-blue); border-left: 5px solid var(--accent-blue); }
            .sidebar-link i { width: 30px; }
            .sidebar::-webkit-scrollbar { width: 6px; }
            .sidebar::-webkit-scrollbar-thumb { background-color: #334155; border-radius: 10px; }

            /* MAIN CONTENT */
            .main-content { padding: 30px; min-height: calc(100vh - 70px); }
            .admin-card { background-color: var(--bg-card); border: 1px solid var(--border-color); border-radius: 12px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); margin-bottom: 30px; }
            .card-title { color: var(--accent-blue); border-left: 4px solid var(--accent-blue); padding-left: 15px; font-weight: bold; margin-bottom: 25px; text-transform: uppercase; }
            
            /* TABLES & FORMS */
            .table-dark { background-color: transparent; }
            .table-dark th { background-color: #111827; color: var(--accent-blue); border-color: var(--border-color); }
            .table-dark td { background-color: var(--bg-card); border-color: var(--border-color); vertical-align: middle; }
            .form-label { font-weight: 500; color: #cbd5e1; }
            .form-control { background-color: #0f172a; border: 1px solid var(--border-color); color: white; }
            .form-control:focus { border-color: var(--accent-blue); color: white; background-color: #0f172a; box-shadow: 0 0 0 0.25rem rgba(0, 212, 255, 0.25); }
            .form-control[readonly] { background-color: #1e293b; color: #94a3b8; border-color: #334155; }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container-fluid px-4">
                <a class="navbar-brand fw-bold" href="MainController?action=adminMovie&subAction=list">
                    <i class="fas fa-film me-2"></i>PRJ CINEMA <span class="text-white fs-6 ms-2 fw-normal">| Hệ thống Quản trị</span>
                </a>
                <div class="d-flex align-items-center">
                    <span class="text-light me-3">Xin chào, <b class="text-warning">${sessionScope.LOGIN_USER.fullName}</b></span>
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
                    <a href="MainController?action=adminShowtime&subAction=list" class="sidebar-link">
                        <i class="fas fa-calendar-alt"></i> Quản lý Lịch chiếu
                    </a>
                    <a href="MainController?action=adminVoucher&subAction=list" class="sidebar-link active">
                        <i class="fas fa-ticket-alt"></i> Quản lý Voucher
                    </a>
                    <a href="#" class="sidebar-link text-secondary">
                        <i class="fas fa-users"></i> Quản lý User (Sắp ra mắt)
                    </a>
                </div>

                <div class="col-md-9 col-lg-10 main-content">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold mb-0 text-white">QUẢN LÝ VOUCHER</h2>
                        <a href="MainController?action=adminVoucher&subAction=list" class="btn btn-info px-4 rounded-pill fw-bold">
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
                        <h4 class="card-title">
                            <i class="fas fa-gift me-2"></i>
                            <c:choose>
                                <c:when test="${not empty VOUCHER_EDIT}">
                                    <span class="text-warning">Cập Nhật Voucher: ${VOUCHER_EDIT.voucherCode}</span>
                                </c:when>
                                <c:otherwise>Thêm Voucher Mới</c:otherwise>
                            </c:choose>
                        </h4>

                        <form action="MainController" method="POST" class="row g-3">
                            <input type="hidden" name="action" value="adminVoucher">
                            <input type="hidden" name="subAction" value="${not empty VOUCHER_EDIT ? 'update' : 'add'}">

                            <div class="col-md-3">
                                <label class="form-label text-warning fw-bold">Mã Voucher (Code):</label>
                                <input type="text" name="voucherCode" class="form-control text-uppercase fw-bold" required 
                                       value="${VOUCHER_EDIT.voucherCode}" 
                                       ${not empty VOUCHER_EDIT ? 'readonly' : ''} 
                                       placeholder="VD: GIAITHUONG50">
                                <c:if test="${not empty VOUCHER_EDIT}">
                                    <small class="text-danger fst-italic mt-1 d-block"><i class="fas fa-lock me-1"></i>Không thể sửa mã Code</small>
                                </c:if>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Giảm giá (%):</label>
                                <input type="number" name="discountPercent" class="form-control" required min="1" max="100" value="${not empty VOUCHER_EDIT ? VOUCHER_EDIT.discountPercent : '10'}">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Số lượng (Lượt dùng):</label>
                                <input type="number" name="quantity" class="form-control" required min="0" value="${not empty VOUCHER_EDIT ? VOUCHER_EDIT.quantity : '100'}">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Hạn sử dụng:</label>
                                <input type="date" name="expiryDate" class="form-control" required value="${VOUCHER_EDIT.expiryDate}">
                            </div>

                            <div class="col-md-3 d-flex align-items-end mt-4">
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input" type="checkbox" name="status" id="statusSwitch" ${empty VOUCHER_EDIT or VOUCHER_EDIT.status ? 'checked' : ''} style="width: 2.5em; height: 1.25em;">
                                    <label class="form-check-label ms-2 text-success fw-bold" for="statusSwitch">Kích hoạt (Active)</label>
                                </div>
                            </div>

                            <div class="col-12 mt-4 text-end border-top border-secondary pt-3">
                                <c:if test="${not empty VOUCHER_EDIT}">
                                    <a href="MainController?action=adminVoucher&subAction=list" class="btn btn-outline-light fw-bold px-4 rounded-pill me-2">
                                        <i class="fas fa-times me-2"></i>Hủy Sửa
                                    </a>
                                </c:if>
                                <button type="submit" class="btn btn-primary fw-bold px-5 rounded-pill">
                                    <i class="fas fa-save me-2"></i>Lưu Voucher
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="admin-card">
                        <h4 class="card-title"><i class="fas fa-list me-2"></i>Danh sách Voucher hệ thống</h4>

                        <div class="table-responsive">
                            <table class="table table-dark table-hover table-bordered align-middle text-center mb-0">
                                <thead>
                                    <tr>
                                        <th class="text-start">Mã Voucher</th>
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
                                            <td class="text-start text-warning fw-bold fs-5">${v.voucherCode}</td>
                                            <td class="fw-bold text-info">${v.discountPercent}%</td>
                                            <td>
                                                <span class="badge ${v.quantity > 0 ? 'bg-primary' : 'bg-danger'}">${v.quantity}</span>
                                            </td>
                                            <td>${v.expiryDate}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.status and v.quantity > 0}">
                                                        <span class="badge bg-success px-3 py-2">Đang chạy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary px-3 py-2">Ngưng / Hết lượt</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="MainController?action=adminVoucher&subAction=edit&voucherCode=${v.voucherCode}" class="btn btn-sm btn-outline-warning" title="Sửa">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="MainController?action=adminVoucher&subAction=delete&voucherCode=${v.voucherCode}" class="btn btn-sm btn-outline-danger" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa mã giảm giá này?');">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div> </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
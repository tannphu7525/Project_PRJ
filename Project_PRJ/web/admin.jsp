<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard - PRJ Cinema</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <style>
        /* Đồng bộ màu sắc với trang web phim */
        :root {
            --bg-body: #1b212c;
            --bg-card: #28303d;
            --accent-blue: #00d4ff;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
        }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            font-family: 'Roboto', sans-serif;
        }

        /* Tùy chỉnh Card (Khung chứa) */
        .card {
            background-color: var(--bg-card);
            border: 1px solid #334155;
            border-radius: 12px;
        }
        
        /* Tùy chỉnh Bảng */
        .table-dark {
            --bs-table-bg: var(--bg-card);
            --bs-table-border-color: #334155;
        }
        
        /* Tùy chỉnh Form Input */
        .form-control, .form-select {
            background-color: #111827;
            color: var(--text-main);
            border: 1px solid #334155;
        }
        .form-control:focus, .form-select:focus {
            background-color: #111827;
            color: var(--text-main);
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 212, 255, 0.25);
        }
        
        /* Tùy chỉnh nút bấm */
        .btn-primary {
            background-color: var(--accent-blue);
            border-color: var(--accent-blue);
            color: #111827;
            font-weight: 700;
        }
        .btn-primary:hover {
            background-color: #00b8e6;
            color: #000;
        }
        .text-accent {
            color: var(--accent-blue);
        }
        /* Đổi màu chữ gợi ý (placeholder) bên trong ô nhập liệu thành màu trắng sáng */
        .form-control::placeholder {
            color: #f8fafc !important; /* Màu trắng sáng */
            opacity: 0.8; /* Độ mờ vừa phải để phân biệt với chữ gõ thật */
        }
        
        /* Đổi màu chữ khi bạn gõ thật vào ô cũng thành màu trắng luôn */
        .form-control {
            color: white !important;
        }
        
        
    </style>
</head>
<body>

    <div class="container py-5">
        
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom border-secondary pb-3">
            <h1 class="text-accent fw-bold m-0"><i class="fas fa-cogs me-3"></i>ADMIN DASHBOARD</h1>
            <a href="AdminMovieController?subAction=list" class="btn btn-outline-info rounded-pill px-4 fw-bold shadow-sm">
                <i class="fas fa-sync-alt me-2"></i>Tải danh sách phim
            </a>
        </div>
        
        <c:if test="${not empty sessionScope.msg}">
            <div class="alert alert-success alert-dismissible fade show shadow" role="alert">
                <i class="fas fa-check-circle me-2"></i><strong>Thông báo:</strong> ${sessionScope.msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%-- Lệnh xóa thông báo --%>
            <c:remove var="msg" scope="session" />
        </c:if>

        <div class="card shadow-lg mb-5">
            <div class="card-header border-secondary pt-3 pb-2">
                <h4 class="text-accent fw-bold"><i class="fas fa-list me-2"></i>1. Danh sách phim hiện tại</h4>
            </div>
            <div class="card-body p-0 table-responsive">
                <table class="table table-dark table-hover table-bordered m-0 align-middle text-center">
                    <thead class="table-active text-accent">
                        <tr>
                            <th>ID</th>
                            <th>Tên Phim</th>
                            <th>Thể loại</th>
                            <th>Giá vé</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="movie" items="${ADMIN_MOVIE_LIST}">
                            <tr>
                                <td class="fw-bold">${movie.movieID}</td>
                                <td class="text-start">${movie.title}</td>
                                <td>${movie.genre}</td>
                                <td class="text-warning fw-bold">${movie.basePrice} ₫</td>
                                <td>
                                    <span class="badge ${movie.status ? 'bg-success' : 'bg-danger'} p-2">
                                        ${movie.status ? 'Đang chiếu' : 'Ngừng chiếu'}
                                    </span>
                                </td>
                                <td>
                                    <form action="AdminMovieController" method="POST" class="m-0">
                                        <input type="hidden" name="action" value="adminMovie">
                                        <input type="hidden" name="subAction" value="delete">
                                        <input type="hidden" name="movieID" value="${movie.movieID}">
                                        <button type="submit" class="btn btn-danger btn-sm rounded-pill px-3" onclick="return confirm('Bạn có chắc chắn muốn ngừng chiếu phim này?');">
                                            <i class="fas fa-trash-alt"></i> Xóa
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card shadow-lg mb-5">
            <div class="card-header border-secondary pt-3 pb-2">
                <h4 class="text-accent fw-bold"><i class="fas fa-edit me-2"></i>2. Form Thêm / Cập nhật phim</h4>
            </div>
            <div class="card-body p-4">
                <form action="AdminMovieController" method="POST">
                    <input type="hidden" name="action" value="adminMovie">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label text-accent fw-bold ">Thao tác bạn muốn thực hiện:</label>
                                <select name="subAction" class="form-select">
                                    <option value="add">Thêm phim mới</option>
                                    <option value="update">Sửa thông tin phim</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-accent fw-bold">Tên phim:</label>
                                <input type="text" name="title" class="form-control " placeholder="Nhập tên bộ phim" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-accent fw-bold">Link Poster (Ảnh):</label>
                                <input type="text" name="posterUrl" class="form-control" placeholder="http://...">
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label text-accent fw-bold">ID Phim (Chỉ nhập số nếu bạn chọn SỬA):</label>
                                <input type="number" name="movieID" value="0" class="form-control">
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-accent fw-bold">Thể loại:</label>
                                <input type="text" name="genre" class="form-control" placeholder="Ví dụ: Hành động, Viễn tưởng">
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-accent fw-bold">Giá vé cơ bản (VNĐ):</label>
                                <input type="number" name="basePrice" class="form-control" placeholder="Ví dụ: 80000" required>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label text-accent fw-bold">Mô tả phim:</label>
                            <textarea name="description" class="form-control" rows="3" placeholder="Tóm tắt nội dung phim..."></textarea>
                        </div>

                        <div class="col-12">
                            <div class="form-check form-switch mt-2">
                                <input type="checkbox" name="status" class="form-check-input fs-5" id="statusCheck" checked>
                                <label class="form-check-label ms-2 pt-1 fw-bold text-light" for="statusCheck">
                                    Đang chiếu (Hiển thị lên trang chủ)
                                </label>
                            </div>
                        </div>

                        <div class="col-12 text-center mt-4">
                            <button type="submit" class="btn btn-primary rounded-pill px-5 py-2 fs-5 w-100 shadow">
                                <i class="fas fa-save me-2"></i>Lưu Thông Tin Phim
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
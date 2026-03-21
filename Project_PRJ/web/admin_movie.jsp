<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản lý Phim - PRJ Cinema</title>

        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #111827;
                --bg-card: #1f2937;
                --bg-darker: #0b0f19;
                --accent-blue: #0ea5e9;
                --accent-hover: #0284c7;
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
                text-transform: uppercase;
                letter-spacing: 1px;
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
                background-color: var(--accent-blue);
                color: white;
                padding: 10px 20px;
                border-radius: 20px;
                font-weight: bold;
                border: none;
                cursor: pointer;
                transition: 0.3s;
            }
            .btn-action:hover { background-color: var(--accent-hover); }

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
            .card-title {
                color: var(--accent-blue);
                border-left: 4px solid var(--accent-blue);
                padding-left: 15px;
                margin-bottom: 25px;
                font-size: 1.2rem;
                text-transform: uppercase;
                font-weight: bold;
            }

            .form-grid { display: grid; grid-template-columns: repeat(12, 1fr); gap: 20px; }
            .col-6 { grid-column: span 6; }
            .col-8 { grid-column: span 8; }
            .col-4 { grid-column: span 4; }
            .col-12 { grid-column: span 12; }

            .form-label { display: block; margin-bottom: 8px; font-weight: 500; color: #cbd5e1; }
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
            .form-control:focus { outline: none; border-color: var(--accent-blue); }

            /* DRAG & DROP ZONE TỰ LÀM */
            .drop-zone {
                border: 2px dashed var(--border-color);
                background-color: #0f172a;
                text-align: center;
                padding: 30px 20px;
                border-radius: 8px;
                cursor: pointer;
                transition: 0.3s;
            }
            .drop-zone.dragover {
                border-color: var(--accent-blue);
                background-color: #1e293b;
            }
            .drop-icon { font-size: 2.5rem; margin-bottom: 10px; display: block; }
            .preview-img { max-height: 180px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.5); }
            
            /* TRẠNG THÁI CHECKBOX */
            .status-container { display: flex; align-items: center; margin-top: 10px;}
            .status-checkbox { width: 20px; height: 20px; cursor: pointer; accent-color: var(--success); }
            .status-label { margin-left: 10px; color: var(--success); font-weight: bold; cursor: pointer; }

            /* FORM BUTTONS */
            .form-actions { display: flex; justify-content: flex-end; gap: 15px; margin-top: 20px; }
            .btn { padding: 12px 30px; border-radius: 30px; font-weight: bold; cursor: pointer; border: none; font-size: 1rem; }
            .btn-primary { background-color: var(--accent-blue); color: white; }
            .btn-primary:hover { background-color: var(--accent-hover); }

            /* --- 6. BẢNG DỮ LIỆU --- */
            .table-responsive { overflow-x: auto; }
            .custom-table { width: 100%; border-collapse: collapse; text-align: center; min-width: 800px; }
            .custom-table th, .custom-table td { border: 1px solid var(--border-color); padding: 12px 15px; }
            .custom-table th { background-color: var(--bg-darker); color: var(--accent-blue); text-transform: uppercase; font-size: 0.85rem; }
            .custom-table td { background-color: var(--bg-card); vertical-align: middle; }
            .custom-table tr:hover td { background-color: #253347; }
            
            .text-left { text-align: left; }
            .fw-bold { font-weight: bold; }
            .text-accent { color: var(--accent-blue); }
            .text-warning { color: var(--warning); }
            
            .img-thumbnail { width: 60px; height: 85px; object-fit: cover; border-radius: 4px; border: 1px solid var(--border-color); }
            
            .badge { padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: bold; display: inline-block; }
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
                    <h2 class="page-title">Quản Lý Phim</h2>
                    <a href="MainController?action=adminMovie&subAction=list" class="btn-action">Tải lại dữ liệu</a>
                </div>

                <c:if test="${not empty msg}">
                    <div class="alert" id="systemAlert">
                        <span>Hệ thống: ${msg}</span>
                        <button class="alert-close" onclick="document.getElementById('systemAlert').style.display='none'">X</button>
                    </div>
                </c:if>

                <div class="admin-card">
                    <h4 class="card-title">${not empty MOVIE_EDIT ? 'Sửa Thông Tin Phim' : 'Thêm Phim Mới'}</h4>

                    <form action="MainController" method="POST" class="form-grid" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="adminMovie">
                        <input type="hidden" name="subAction" value="${not empty MOVIE_EDIT ? 'update' : 'add'}">
                        <input type="hidden" name="movieID" value="${not empty MOVIE_EDIT ? MOVIE_EDIT.movieID : '0'}">
                        <input type="hidden" name="existingPoster" value="${MOVIE_EDIT.posterUrl}">

                        <div class="col-6">
                            <label class="form-label">Tên Phim:</label>
                            <input type="text" name="title" class="form-control" required value="${MOVIE_EDIT.title}" placeholder="Nhập tên phim...">
                        </div>

                        <div class="col-6">
                            <label class="form-label">Thể loại:</label>
                            <input type="text" name="genre" class="form-control" required value="${MOVIE_EDIT.genre}" placeholder="VD: Hành động, Hài hước...">
                        </div>

                        <div class="col-8">
                            <label class="form-label">Ảnh Poster (Kéo thả hoặc Click):</label>
                            
                            <div id="drop-zone" class="drop-zone">
                                <input type="file" name="posterFile" id="posterFile" style="display: none;" accept="image/*">

                                <div id="upload-content">
                                    <span class="drop-icon">📁</span>
                                    <p style="margin-bottom: 5px; color: var(--text-main);">Kéo thả ảnh vào đây hoặc <b style="color: var(--warning);">Nhấn để chọn file</b></p>
                                    <small style="color: var(--text-muted);">Hỗ trợ: JPG, PNG, GIF</small>
                                </div>

                                <div id="preview-container" style="display: none; margin-top: 10px;">
                                    <img id="image-preview" src="" alt="Preview" class="preview-img">
                                    <p style="color: var(--danger); margin-top: 10px; font-size: 0.85rem;">Nhấn vào ảnh để chọn lại</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-4">
                            <label class="form-label">Giá vé cơ bản (VNĐ):</label>
                            <input type="number" name="basePrice" class="form-control" required min="0" value="${not empty MOVIE_EDIT ? MOVIE_EDIT.basePrice : '80000'}">
                            
                            <div class="status-container">
                                <input type="checkbox" name="status" id="statusCheck" class="status-checkbox" ${empty MOVIE_EDIT or MOVIE_EDIT.status ? 'checked' : ''}>
                                <label for="statusCheck" class="status-label">Đang chiếu / Mở bán</label>
                            </div>
                        </div>

                        <div class="col-12 form-actions">
                            <button type="submit" class="btn btn-primary">Lưu Thông Tin Phim</button>
                        </div>
                    </form>
                </div>

                <div class="admin-card">
                    <h4 class="card-title">Danh sách Phim</h4>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Mã Phim</th>
                                    <th>Poster</th>
                                    <th class="text-left">Tên Phim</th>
                                    <th>Thể loại</th>
                                    <th>Giá vé cơ bản</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="movie" items="${LIST_MOVIE}">
                                    <tr>
                                        <td>${movie.movieID}</td>
                                        <td>
                                            <img src="${movie.posterUrl}" alt="poster" class="img-thumbnail">
                                        </td>
                                        <td class="text-left text-accent fw-bold">${movie.title}</td>
                                        <td>${movie.genre}</td>
                                        <td class="text-warning fw-bold">
                                            <fmt:formatNumber value="${movie.basePrice}" type="number" pattern="#,###"/> ₫
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${movie.status}">
                                                    <span class="badge bg-success">Đang chiếu</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Ngừng chiếu</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="MainController?action=adminMovie&subAction=edit&movieID=${movie.movieID}" class="btn-sm btn-edit">Sửa</a>
                                                <a href="MainController?action=adminMovie&subAction=delete&movieID=${movie.movieID}" class="btn-sm btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa/ngừng chiếu bộ phim này không?');">Xóa</a>
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

        <script>
            const dropZone = document.getElementById('drop-zone');
            const fileInput = document.getElementById('posterFile');
            const uploadContent = document.getElementById('upload-content');
            const previewContainer = document.getElementById('preview-container');
            const imagePreview = document.getElementById('image-preview');

            // Mở cửa sổ chọn file khi click
            dropZone.addEventListener('click', () => fileInput.click());

            // Hiệu ứng khi kéo file vào
            dropZone.addEventListener('dragover', (e) => {
                e.preventDefault();
                dropZone.classList.add('dragover');
            });

            // Hiệu ứng khi kéo file ra
            dropZone.addEventListener('dragleave', () => {
                dropZone.classList.remove('dragover');
            });

            // Xử lý khi thả file xuống
            dropZone.addEventListener('drop', (e) => {
                e.preventDefault();
                dropZone.classList.remove('dragover');

                if (e.dataTransfer.files.length) {
                    fileInput.files = e.dataTransfer.files;
                    previewImage(fileInput.files[0]);
                }
            });

            // Xử lý khi chọn file qua cửa sổ
            fileInput.addEventListener('change', function () {
                if (this.files.length) previewImage(this.files[0]);
            });

            // Hàm xem trước ảnh
            function previewImage(file) {
                if (file && file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        imagePreview.src = e.target.result;
                        uploadContent.style.display = 'none';
                        previewContainer.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                }
            }
        </script>
    </body>
</html>
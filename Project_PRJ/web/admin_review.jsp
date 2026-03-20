<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản Lý Đánh Giá - PRJ Cinema</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root { --bg-body: #111827; --bg-card: #1f2937; --accent-blue: #00d4ff; --text-main: #f8fafc; --text-muted: #94a3b8; --border-color: #334155; }
            body { background-color: var(--bg-body); color: var(--text-main); font-family: 'Roboto', sans-serif; overflow-x: hidden; }
            .navbar { background-color: #0b0f19; border-bottom: 1px solid var(--border-color); box-shadow: 0 4px 15px rgba(0,0,0,0.5); z-index: 1030; }
            .navbar-brand { color: var(--accent-blue) !important; font-size: 1.5rem; letter-spacing: 1px; }
            
            /* CSS SIDEBAR CHUẨN */
            .sidebar { background-color: #0b0f19; min-height: calc(100vh - 60px); border-right: 1px solid var(--border-color); padding-top: 20px; position: sticky; top: 60px; }
            .sidebar-link { color: var(--text-muted); padding: 15px 25px; display: block; text-decoration: none; font-weight: 500; font-size: 1.1rem; border-bottom: 1px solid #1f2937; transition: all 0.3s ease; }
            .sidebar-link:hover, .sidebar-link.active { background-color: var(--bg-card); color: var(--accent-blue); border-left: 5px solid var(--accent-blue); }
            .sidebar-link i { width: 30px; }

            .main-content { padding: 30px; }
            .admin-card { background-color: var(--bg-card); border: 1px solid var(--border-color); border-radius: 12px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); margin-bottom: 30px; }
            .card-title { color: var(--accent-blue); border-left: 4px solid var(--accent-blue); padding-left: 15px; font-weight: bold; margin-bottom: 25px; text-transform: uppercase; }
            .table-dark { background-color: transparent; }
            .table-dark th { background-color: #111827; color: var(--accent-blue); border-color: var(--border-color); }
            .table-dark td { background-color: var(--bg-card); border-color: var(--border-color); vertical-align: middle; }
            
            /* Box nội dung comment */
            .comment-box {
                max-width: 300px;
                white-space: normal;
                word-wrap: break-word;
                font-size: 0.95rem;
                text-align: left;
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
                    <h2 class="fw-bold mb-4 text-white">KIỂM DUYỆT ĐÁNH GIÁ (REVIEWS)</h2>

                    <c:if test="${not empty msg}">
                        <div class="alert alert-info alert-dismissible fade show fw-bold" role="alert">
                            <i class="fas fa-info-circle me-2"></i> ${msg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="admin-card">
                        <h4 class="card-title mb-4"><i class="fas fa-comments me-2"></i>Tất Cả Bình Luận</h4>
                        <div class="table-responsive">
                            <table class="table table-dark table-hover table-bordered align-middle text-center mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th class="text-start">Người Dùng</th>
                                        <th class="text-start">Phim Đánh Giá</th>
                                        <th>Số Sao</th>
                                        <th class="text-start">Nội Dung Bình Luận</th>
                                        <th>Thời Gian</th>
                                        <th>Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="r" items="${REVIEW_LIST}">
                                        <tr>
                                            <td><span class="badge bg-secondary">#${r.reviewID}</span></td>
                                            <td class="text-start fw-bold text-light">@${r.userName}</td>
                                            <td class="text-start text-accent fw-bold">${r.movieTitle}</td>
                                            <td>
                                                <div class="text-warning small">
                                                    <c:forEach begin="1" end="${r.rating}">
                                                        <i class="fas fa-star"></i>
                                                    </c:forEach>
                                                    <c:forEach begin="${r.rating + 1}" end="5">
                                                        <i class="far fa-star"></i>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="comment-box text-light">
                                                    "${r.comment}"
                                                </div>
                                            </td>
                                            <td class="small text-muted">${r.reviewDate}</td>
                                            <td>
                                                <a href="MainController?action=adminReview&subAction=delete&reviewID=${r.reviewID}" 
                                                   class="btn btn-sm btn-outline-danger" title="Xóa bình luận vi phạm"
                                                   onclick="return confirm('Bạn có chắc muốn xóa bình luận này khỏi hệ thống không?');">
                                                    <i class="fas fa-trash-alt"></i> Xóa
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty REVIEW_LIST}">
                                        <tr>
                                            <td colspan="7" class="text-muted py-4 fst-italic">Hệ thống chưa có đánh giá nào.</td>
                                        </tr>
                                    </c:if>
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản Lý Đánh Giá - PRJ Cinema</title>
        
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
                --info: #0ea5e9;
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
            .user-greeting b { color: var(--text-main); font-weight: bold; }
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

            /* --- 7. KHUNG BẢNG VÀ BẢNG DỮ LIỆU --- */
            .admin-card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 25px;
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

            .table-responsive { overflow-x: auto; }
            .custom-table { width: 100%; border-collapse: collapse; text-align: center; min-width: 900px; }
            .custom-table th, .custom-table td { border: 1px solid var(--border-color); padding: 12px 15px; }
            .custom-table th { background-color: var(--bg-darker); color: var(--accent-blue); text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; }
            .custom-table td { background-color: var(--bg-card); vertical-align: middle; }
            .custom-table tr:hover td { background-color: #253347; }
            
            .text-left { text-align: left; }
            .fw-bold { font-weight: bold; }
            .text-light { color: var(--text-main); }
            .text-muted { color: var(--text-muted); font-size: 0.85rem; }
            .text-accent { color: var(--accent-blue); }
            
            /* Box chứa nội dung comment dài */
            .comment-box {
                max-width: 300px;
                white-space: normal;
                word-wrap: break-word;
                font-size: 0.95rem;
                text-align: left;
                line-height: 1.5;
                color: #e2e8f0;
                background-color: #0f172a;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid var(--border-color);
            }

            /* Định dạng sao đánh giá */
            .star-rating { color: var(--warning); font-size: 1.1rem; letter-spacing: 2px;}
            
            .badge { padding: 6px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: bold; display: inline-block; }
            .bg-secondary { background-color: #475569; color: white; letter-spacing: 1px;}

            /* Nút thao tác */
            .btn-action-sm {
                border: 1px solid var(--danger);
                color: var(--danger);
                background: transparent;
                padding: 6px 12px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.85rem;
                font-weight: bold;
                transition: 0.3s;
                display: inline-block;
            }
            .btn-action-sm:hover { background-color: var(--danger); color: white; }
            
            .empty-row { text-align: center; padding: 30px !important; color: var(--text-muted); font-style: italic; }
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
                <h2 class="page-title">Kiểm Duyệt Đánh Giá (Reviews)</h2>

                <c:if test="${not empty msg}">
                    <div class="alert" id="infoAlert">
                        <span>Hệ thống: ${msg}</span>
                        <button class="alert-close" onclick="document.getElementById('infoAlert').style.display='none'">X</button>
                    </div>
                </c:if>

                <div class="admin-card">
                    <h4 class="card-title">Tất Cả Bình Luận</h4>
                    
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th class="text-left">Người Dùng</th>
                                    <th class="text-left">Phim Đánh Giá</th>
                                    <th>Số Sao</th>
                                    <th class="text-left">Nội Dung Bình Luận</th>
                                    <th>Thời Gian</th>
                                    <th>Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${REVIEW_LIST}">
                                    <tr>
                                        <td><span class="badge bg-secondary">#${r.reviewID}</span></td>
                                        <td class="text-left fw-bold text-light">@${r.userName}</td>
                                        <td class="text-left text-accent fw-bold">${r.movieTitle}</td>
                                        <td>
                                            <div class="star-rating">
                                                <c:forEach begin="1" end="${r.rating}">★</c:forEach><c:forEach begin="${r.rating + 1}" end="5">☆</c:forEach>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="comment-box">
                                                "${r.comment}"
                                            </div>
                                        </td>
                                        <td class="text-muted">${r.reviewDate}</td>
                                        <td>
                                            <a href="MainController?action=adminReview&subAction=delete&reviewID=${r.reviewID}" 
                                               class="btn-action-sm" 
                                               onclick="return confirm('Bạn có chắc muốn xóa bình luận này khỏi hệ thống không?');">
                                               Xóa Bình Luận
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty REVIEW_LIST}">
                                    <tr>
                                        <td colspan="7" class="empty-row">Hệ thống chưa có đánh giá nào.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div> 
        </div> 

    </body>
</html>
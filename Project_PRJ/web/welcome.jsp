<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Trang Chủ - PRJ Cinema</title>

        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #1b212c;
                --bg-card: #28303d;
                --accent-blue: #00d4ff;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --navbar-bg: #111827;
                --border-color: #334155;
            }
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                background-color: var(--bg-body);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                color: var(--text-main);
                line-height: 1.6;
            }
            a {
                text-decoration: none;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }

            /* --- 2. THÔNG BÁO (ALERT) --- */
            .alert-top {
                background-color: #d4edda;
                color: #155724;
                padding: 15px;
                text-align: center;
                border-bottom: 1px solid #c3e6cb;
            }
            .alert-top h4 {
                margin-bottom: 5px;
                font-size: 1.2rem;
            }
            .alert-top a {
                color: #0056b3;
                font-weight: bold;
                text-decoration: underline;
            }

            /* --- 3. THANH ĐIỀU HƯỚNG (NAVBAR) --- */
            .navbar {
                background-color: var(--navbar-bg);
                box-shadow: 0 4px 15px rgba(0,0,0,0.3);
                border-bottom: 1px solid var(--border-color);
                position: sticky;
                top: 0;
                z-index: 1000;
            }
            .navbar-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 20px;
                max-width: 1200px;
                margin: 0 auto;
                flex-wrap: wrap; /* Hỗ trợ rớt dòng trên điện thoại */
                gap: 15px;
            }
            .navbar-brand {
                color: var(--accent-blue);
                font-size: 1.5rem;
                font-weight: bold;
                letter-spacing: 1px;
            }
            .nav-links {
                display: flex;
                gap: 20px;
                align-items: center;
            }
            .nav-link {
                color: var(--text-muted);
                font-weight: bold;
                transition: 0.3s;
            }
            .nav-link:hover, .nav-link.active {
                color: var(--accent-blue);
            }

            /* --- 4. CÁC NÚT BẤM (BUTTONS) --- */
            .auth-actions {
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
            }
            .user-greeting {
                text-align: right;
                margin-right: 15px;
                line-height: 1.2;
            }
            .user-greeting small {
                color: var(--text-muted);
                font-size: 0.8rem;
            }
            .user-greeting strong {
                color: var(--accent-blue);
                font-size: 0.95rem;
                display: block;
            }

            .btn {
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: bold;
                font-size: 0.9rem;
                cursor: pointer;
                transition: 0.3s;
                text-align: center;
                border: 1px solid transparent;
            }
            .btn-outline-warning {
                border-color: #f59e0b;
                color: #f59e0b;
                background: transparent;
            }
            .btn-outline-warning:hover {
                background: #f59e0b;
                color: #000;
            }

            .btn-outline-info {
                border-color: #0ea5e9;
                color: #0ea5e9;
                background: transparent;
            }
            .btn-outline-info:hover {
                background: #0ea5e9;
                color: #000;
            }

            .btn-outline-danger {
                border-color: #ef4444;
                color: #ef4444;
                background: transparent;
            }
            .btn-outline-danger:hover {
                background: #ef4444;
                color: white;
            }

            .btn-primary {
                background-color: var(--accent-blue);
                color: #000;
            }
            .btn-primary:hover {
                background-color: #00b8e6;
            }

            /* --- 5. BANNER (HERO SECTION) --- */
            .hero-section {
                /* Dùng màu gradient thuần túy thay cho ảnh mạng để đảm bảo chạy offline 100% */
                background: linear-gradient(135deg, #111827, #1e3a8a);
                color: white;
                padding: 80px 20px;
                text-align: center;
                margin-bottom: 50px;
                border-bottom: 2px solid var(--accent-blue);
            }
            .hero-section h1 {
                font-size: 2.5rem;
                margin-bottom: 15px;
            }
            .hero-section p {
                font-size: 1.1rem;
                color: #cbd5e1;
            }

            /* --- 6. PHẦN TÌM KIẾM --- */
            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                flex-wrap: wrap;
                gap: 15px;
            }
            .section-title {
                color: var(--accent-blue);
                border-left: 5px solid var(--accent-blue);
                padding-left: 15px;
                font-size: 1.4rem;
                text-transform: uppercase;
            }
            .search-form {
                display: flex;
                width: 100%;
                max-width: 400px;
            }
            .search-input {
                flex: 1;
                background-color: #0f172a;
                border: 1px solid var(--border-color);
                color: white;
                padding: 10px 15px;
                border-radius: 25px 0 0 25px;
                outline: none;
            }
            .search-input:focus {
                border-color: var(--accent-blue);
            }
            .search-btn {
                border-radius: 0 25px 25px 0;
                padding: 10px 20px;
            }

            /* --- 7. DANH SÁCH PHIM (GRID) --- */
            .movie-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                gap: 25px;
                margin-bottom: 50px;
            }
            .movie-card {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                overflow: hidden;
                display: flex;
                flex-direction: column;
                box-shadow: 0 10px 20px rgba(0,0,0,0.2);
                transition: transform 0.3s, box-shadow 0.3s, border-color 0.3s;
            }
            .movie-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 12px 30px rgba(0, 212, 255, 0.2);
                border-color: var(--accent-blue);
            }
            .movie-poster {
                width: 100%;
                height: 350px;
                object-fit: cover;
                border-bottom: 1px solid var(--border-color);
            }
            .card-body {
                padding: 20px;
                display: flex;
                flex-direction: column;
                flex: 1;
                text-align: center;
            }
            .card-title {
                font-size: 1.1rem;
                margin-bottom: 5px;
                color: var(--text-main);
            }
            .card-genre {
                color: var(--text-muted);
                font-size: 0.85rem;
                margin-bottom: 15px;
            }
            .card-price {
                color: #fbbf24;
                font-size: 1.1rem;
                font-weight: bold;
                margin-bottom: 20px;
            }
            .btn-detail {
                width: 100%;
                margin-top: auto;
                display: block;
            }

            /* --- 8. FOOTER & EMPTY STATE --- */
            .empty-state {
                text-align: center;
                padding: 40px 20px;
                background-color: var(--bg-card);
                border: 1px dashed var(--border-color);
                border-radius: 12px;
                color: var(--text-muted);
            }
            footer {
                text-align: center;
                padding: 20px;
                background-color: var(--navbar-bg);
                border-top: 1px solid var(--border-color);
                color: var(--text-muted);
                margin-top: auto;
            }
        </style>
    </head>
    <body>

        <c:if test="${not empty sessionScope.MESSAGE}">
            <div class="alert-top">
                <h4>${sessionScope.MESSAGE}</h4>
                <p>
                    <a href="BookingController?action=history">
                        Bấm vào đây để xem chi tiết vé điện tử của bạn
                    </a>
                </p>
            </div>
            <% session.removeAttribute("MESSAGE");%> 
        </c:if>

        <nav class="navbar">
            <div class="navbar-container">
                <div style="display: flex; align-items: center; gap: 30px;">
                    <a class="navbar-brand" href="HomeController">PRJ CINEMA</a>
                    <div class="nav-links">
                        <a class="nav-link active" href="javascript:void(0);" style="pointer-events: none; cursor: default;">Lịch Chiếu</a>
                    </div>
                </div>

                <div class="auth-actions">
                    <c:if test="${not empty sessionScope.LOGIN_USER}">
                        <div class="user-greeting">
                            <small>Xin chào,</small>
                            <strong>${sessionScope.LOGIN_USER.fullName}</strong>
                        </div>

                        <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">
                            <a href="MainController?action=adminMovie&subAction=list" class="btn btn-outline-warning">
                                Edit
                            </a>
                        </c:if>

                        <a href="BookingController?action=history" class="btn btn-outline-info">
                            History                                                                 
                        </a>

                        <a href="MainController?action=logout" class="btn btn-outline-danger">
                            Log Out
                        </a> 
                    </c:if>
                </div>
            </div>
        </nav>

        <div class="hero-section">
            <h1>Mở Cửa Thế Giới Điện Ảnh</h1>
            <p>Chọn một bộ phim và tận hưởng khoảng thời gian tuyệt vời.</p>
        </div>

        <div class="container">

            <div class="section-header">
                <h3 class="section-title">PHIM ĐANG CHIẾU</h3>

                <form action="HomeController" method="GET" class="search-form">
                    <input type="text" name="search" class="search-input" placeholder="Nhập tên phim, thể loại..." value="${SEARCH_KEYWORD}">
                    <button type="submit" class="btn btn-primary search-btn">Tìm kiếm</button>
                </form>
            </div>

            <c:if test="${empty LIST_MOVIE}">
                <div class="empty-state">
                    <h4 style="margin-bottom: 15px;">Không tìm thấy bộ phim nào phù hợp với từ khóa "${SEARCH_KEYWORD}"</h4>
                    <a href="HomeController" class="btn btn-outline-info">Xem tất cả phim</a>
                </div>
            </c:if>

            <div class="movie-grid">
                <c:forEach items="${LIST_MOVIE}" var="movie">
                    <c:if test="${movie.status == true}">
                        <div class="movie-card">
                            <img src="${movie.posterUrl}" class="movie-poster" alt="${movie.title}">
                            <div class="card-body">
                                <h4 class="card-title">${movie.title}</h4>
                                <p class="card-genre">${movie.genre}</p>
                                <div class="card-price">
                                    <fmt:formatNumber value="${movie.basePrice}" type="number" pattern="#,###"/> đ
                                </div>
                                <a href="HomeController?action=movieDetail&id=${movie.movieID}" class="btn btn-primary btn-detail">
                                    Xem Chi Tiết
                                </a>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

        </div>

        <footer>
            <p>&copy; 2026 PRJ Cinema. All rights reserved.</p>
        </footer>

    </body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Trang Chủ - PRJ Cinema</title>
        
        <c:if test="${LIST_MOVIE == null}">
            <c:redirect url="HomeController"/>
        </c:if>

        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #1b212c;
                --bg-card: #28303d;
                --accent-blue: #3b82f6;
                --accent-hover: #2563eb;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --navbar-bg: #111827;
                --border-color: #334155;
            }
            * { box-sizing: border-box; margin: 0; padding: 0; }
            body {
                background-color: var(--bg-body);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                color: var(--text-main);
                line-height: 1.6;
            }
            a { text-decoration: none; }
            .container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }

            /* --- 2. THANH ĐIỀU HƯỚNG (NAVBAR) --- */
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
            }
            .navbar-brand {
                color: var(--accent-blue);
                font-size: 1.5rem;
                font-weight: bold;
                letter-spacing: 1px;
                text-transform: uppercase;
            }
            .nav-links { display: flex; gap: 20px; align-items: center; }
            .nav-link {
                color: var(--text-muted);
                font-weight: bold;
                transition: 0.3s;
                font-size: 1.05rem;
            }
            .nav-link:hover, .nav-link.active { color: var(--accent-blue); }

            /* --- 3. BANNER (HERO SECTION) --- */
            .hero-section {
                /* Dùng màu Gradient thay cho link ảnh mạng để chống lỗi khi offline */
                background: linear-gradient(135deg, #111827 0%, #1e3a8a 100%);
                color: white;
                padding: 100px 20px;
                text-align: center;
                margin-bottom: 50px;
                border-bottom: 2px solid var(--accent-blue);
            }
            .hero-title { font-size: 2.8rem; margin-bottom: 15px; font-weight: bold; }
            .hero-subtitle { font-size: 1.2rem; color: #cbd5e1; margin-bottom: 30px; }
            .hero-actions { display: flex; justify-content: center; gap: 15px; flex-wrap: wrap; }
            
            /* --- 4. NÚT BẤM (BUTTONS) --- */
            .btn {
                padding: 12px 30px;
                border-radius: 30px;
                font-weight: bold;
                cursor: pointer;
                transition: 0.3s;
                font-size: 1rem;
                display: inline-block;
                text-align: center;
                border: 2px solid transparent;
            }
            .btn-primary { background-color: var(--accent-blue); color: white; }
            .btn-primary:hover { background-color: var(--accent-hover); }
            
            .btn-outline { border-color: var(--accent-blue); color: white; background: transparent; }
            .btn-outline:hover { background-color: var(--accent-blue); color: #000; }

            .btn-block { width: 100%; display: block; margin-top: auto; }

            /* --- 5. DANH SÁCH PHIM (MOVIE GRID) --- */
            .section-title {
                color: var(--accent-blue);
                border-left: 5px solid var(--accent-blue);
                padding-left: 15px;
                font-size: 1.5rem;
                text-transform: uppercase;
                margin-bottom: 30px;
            }

            .movie-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
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
                box-shadow: 0 12px 30px rgba(59, 130, 246, 0.25);
                border-color: var(--accent-blue);
            }
            .movie-poster {
                width: 100%;
                height: 350px;
                object-fit: cover;
                border-bottom: 1px solid var(--border-color);
                background-color: #0f172a; /* Màu nền chờ load ảnh */
            }
            .card-body {
                padding: 20px;
                display: flex;
                flex-direction: column;
                flex: 1;
                text-align: center;
            }
            .card-title { font-size: 1.1rem; margin-bottom: 5px; color: var(--text-main); font-weight: bold; }
            .card-genre { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 20px; }

            /* --- 6. FOOTER --- */
            footer {
                text-align: center;
                padding: 25px;
                background-color: var(--navbar-bg);
                border-top: 1px solid var(--border-color);
                color: var(--text-muted);
                margin-top: 50px;
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="navbar-container">
                <div style="display: flex; align-items: center; gap: 40px;">
                    <a class="navbar-brand" href="HomeController">PRJ CINEMA</a>
                    <div class="nav-links">
                        <a class="nav-link active" href="HomeController">Lịch Chiếu</a>
                        <a class="nav-link" href="#">Khuyến Mãi</a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="hero-section">
            <div class="container">
                <h1 class="hero-title">Mở Cửa Thế Giới Điện Ảnh</h1>
                <p class="hero-subtitle">Đặt vé nhanh chóng, ghế ngồi thoải mái, trải nghiệm tuyệt vời.</p>
                <div class="hero-actions">
                    <a href="login.jsp" class="btn btn-primary">ĐĂNG NHẬP TÀI KHOẢN</a>
                    <a href="register.jsp" class="btn btn-outline">ĐĂNG KÝ THÀNH VIÊN</a>
                </div>
            </div>
        </div>

        <div class="container">
            <h3 class="section-title">PHIM ĐANG CHIẾU</h3>

            <div class="movie-grid">
                <c:forEach items="${LIST_MOVIE}" var="movie">
                    <div class="movie-card">
                        <img src="${movie.posterUrl}" class="movie-poster" alt="${movie.title}" onerror="this.src='data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\' width=\'100%\' height=\'100%\'><rect width=\'100%\' height=\'100%\' fill=\'#334155\'/><text x=\'50%\' y=\'50%\' fill=\'#94a3b8\' font-size=\'14\' font-family=\'sans-serif\' text-anchor=\'middle\' dominant-baseline=\'middle\'>No Image (Offline)</text></svg>'">
                        
                        <div class="card-body">
                            <h4 class="card-title">${movie.title}</h4>
                            <p class="card-genre">${movie.genre}</p>

                            <a href="HomeController?action=movieDetail&id=${movie.movieID}" class="btn btn-primary btn-block">
                                Xem Chi Tiết Phim
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <footer>
            <p>&copy;2026 PRJ Cinema. All rights reserved.</p>
        </footer>

    </body>
</html>
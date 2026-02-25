<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Trang Chủ - PRJ Cinema</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <style>
            /* Định nghĩa bảng màu mới */
            :root {
                --bg-body: #1b212c;      /* Nền tối xám xanh */
                --bg-card: #28303d;      /* Nền thẻ phim */
                --accent-blue: #00d4ff;  /* Xanh Cyan điểm nhấn */
                --text-main: #f8fafc;    /* Chữ trắng sáng */
                --text-muted: #94a3b8;   /* Chữ xám phụ */
                --navbar-bg: #111827;    /* Nền navbar */
            }

            body {
                background-color: var(--bg-body);
                font-family: 'Roboto', sans-serif;
                color: var(--text-main);
            }

            /* Navbar tông màu tối sâu */
            .navbar {
                background-color: var(--navbar-bg);
                box-shadow: 0 4px 15px rgba(0,0,0,0.3);
                border-bottom: 1px solid #334155;
            }
            .navbar-brand {
                color: var(--accent-blue) !important;
                font-size: 1.5rem;
            }
            .nav-link {
                color: var(--text-muted) !important;
                font-weight: 500;
            }
            .nav-link:hover, .nav-link.active {
                color: var(--accent-blue) !important;
            }

            /* Banner dốc màu tối sang trọng */
            /* Banner Giới thiệu với ảnh nền điện ảnh */
            .hero-section {
                /* Sử dụng ảnh rạp chiếu phim chất lượng cao làm nền */
                /* Phủ thêm lớp gradient tối để làm nổi bật chữ trắng */
                background: linear-gradient(rgba(27, 33, 44, 0.8), rgba(17, 24, 39, 0.9)),
                    url('https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=2059&auto=format&fit=crop') center/cover no-repeat;
                color: white;
                padding: 100px 0; /* Tăng khoảng cách để thấy ảnh rõ hơn */
                margin-bottom: 50px;
                border-bottom: 2px solid var(--accent-blue);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                text-shadow: 2px 2px 8px rgba(0,0,0,0.8); /* Tạo bóng cho chữ dễ đọc trên nền ảnh */
            }

            /* Nút Đăng ký màu trắng/viền xanh lơ */
            .btn-outline-register {
                border: 2px solid var(--accent-blue);
                color: white;
                font-weight: 600;
                transition: 0.3s;
                margin-left: 10px;
            }

            .btn-outline-register:hover {
                background-color: var(--accent-blue);
                color: #111827;
            }
            /* Thẻ Phim màu xám xanh đậm */
            .movie-card {
                background-color: var(--bg-card);
                border: 1px solid #334155;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 10px 20px rgba(0,0,0,0.2);
                transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s;
            }
            .movie-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 12px 30px rgba(0, 212, 255, 0.2);
                border-color: var(--accent-blue);
            }
            .movie-poster {
                height: 350px;
                object-fit: cover;
                border-bottom: 1px solid #334155;
            }

            .section-title {
                color: var(--accent-blue);
                border-left: 5px solid var(--accent-blue);
                padding-left: 15px;
                margin-bottom: 30px;
            }

            .card-title {
                color: var(--text-main);
            }
            .text-muted {
                color: var(--text-muted) !important;
            }

            /* Nút bấm màu xanh sáng */
            .btn-primary {
                background-color: var(--accent-blue);
                border-color: var(--accent-blue);
                color: #111827;
            }
            .btn-primary:hover {
                background-color: #00b8e6;
                border-color: #00b8e6;
                color: #000;
            }
            .btn-outline-primary {
                color: var(--accent-blue);
                border-color: var(--accent-blue);
            }
            .btn-outline-primary:hover {
                background-color: var(--accent-blue);
                border-color: var(--accent-blue);
                color: #111827;
            }

            footer {
                background-color: var(--navbar-bg);
                border-top: 1px solid #334155;
            }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold" href="index.jsp">
                    <i class="fas fa-film me-2"></i>PRJ CINEMA
                </a>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="index.jsp">Lịch Chiếu</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Khuyến Mãi</a>
                        </li>
                    </ul>
                    
                </div>
            </div>
        </nav>

        <div class="hero-section text-center">
            <div class="container">
                <h1 class="display-4 fw-bold mb-3">Mở Cửa Thế Giới Điện Ảnh</h1>
                <p class="lead mb-4 text-light">Đặt vé nhanh chóng, ghế ngồi thoải mái, trải nghiệm tuyệt vời.</p>

                <div class="mt-4">
                    <a href="login.jsp" class="btn btn-primary fw-bold px-4 py-2 rounded-pill me-2">
                        <i class="fas fa-sign-in-alt me-2"></i>ĐĂNG NHẬP
                    </a>

                    <a href="login.jsp?mode=register" class="btn btn-outline-register fw-bold px-4 py-2 rounded-pill">
                        <i class="fas fa-user-plus me-2"></i>ĐĂNG KÝ THÀNH VIÊN
                    </a>
                </div>
            </div>
        </div>

        <div class="container mb-5">
            <h3 class="fw-bold section-title">PHIM ĐANG HOT</h3>

            <div class="row g-4">

                <div class="col-lg-3 col-md-6">
                    <div class="card movie-card h-100">
                        <img src="https://m.media-amazon.com/images/M/MV5BOTE1NjQvNjM3NF5BMl5BanBnXkFtZTgwNTc1NDo1MzE@._V1_FMjpg_UX1000_.jpg" class="movie-poster" alt="Avengers">
                        <div class="card-body d-flex flex-column text-center">
                            <h5 class="card-title fw-bold">Avengers: Endgame</h5>
                            <p class="text-muted small mb-3">Hành động, Viễn tưởng</p>
                            <a href="login.jsp" class="btn btn-primary mt-auto w-100 fw-bold rounded-pill">Mua Vé Ngay</a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="card movie-card h-100">
                        <img src="https://m.media-amazon.com/images/M/MV5BMDExZGMyOTMtMDgyYi00NGIwLWJhMTEtOTdkZGFjNmZiMTEwXkEyXkFqcGdeQXVyMjM4NTM5NDY@._V1_FMjpg_UX1000_.jpg" class="movie-poster" alt="John Wick">
                        <div class="card-body d-flex flex-column text-center">
                            <h5 class="card-title fw-bold">John Wick: Chapter 4</h5>
                            <p class="text-muted small mb-3">Hành động, Tội phạm</p>
                            <a href="login.jsp" class="btn btn-primary mt-auto w-100 fw-bold rounded-pill">Mua Vé Ngay</a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="card movie-card h-100">
                        <img src="https://m.media-amazon.com/images/M/MV5BMTg1MTY2MjYzNV5BMl5BanBnXkFtZTgwMTc4NTMwNDI@._V1_FMjpg_UX1000_.jpg" class="movie-poster" alt="Black Panther">
                        <div class="card-body d-flex flex-column text-center">
                            <h5 class="card-title fw-bold">Black Panther</h5>
                            <p class="text-muted small mb-3">Hành động, Phiêu lưu</p>
                            <a href="login.jsp" class="btn btn-primary mt-auto w-100 fw-bold rounded-pill">Mua Vé Ngay</a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="card movie-card h-100">
                        <img src="pic/maipic.jpg" class="movie-poster" alt="Mai">
                        <div class="card-body d-flex flex-column text-center">
                            <h5 class="card-title fw-bold">Mai</h5>
                            <p class="text-muted small mb-3">Tâm lý, Tình cảm</p>
                            <a href="login.jsp" class="btn btn-primary mt-auto w-100 fw-bold rounded-pill">Mua Vé Ngay</a>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <footer class="text-center py-4 mt-5">
            <p class="mb-0 text-muted">&copy; 2024 PRJ Cinema. All rights reserved.</p>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
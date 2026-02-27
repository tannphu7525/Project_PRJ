<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Trang Chủ - PRJ Cinema</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <style>
            :root {
                --bg-body: #1b212c;
                --bg-card: #28303d;
                --accent-blue: #00d4ff;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --navbar-bg: #111827;
            }
            body {
                background-color: var(--bg-body);
                font-family: 'Roboto', sans-serif;
                color: var(--text-main);
            }
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
            .hero-section {
                background: linear-gradient(rgba(27, 33, 44, 0.8), rgba(17, 24, 39, 0.9)), url('https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=2059&auto=format&fit=crop') center/cover no-repeat;
                color: white;
                padding: 100px 0;
                margin-bottom: 50px;
                border-bottom: 2px solid var(--accent-blue);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
            }
            .btn {
                white-space: nowrap;
            } /* Chống rớt dòng chữ trên nút */
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
            .movie-card {
                background-color: var(--bg-card);
                border: 1px solid #334155;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 10px 20px rgba(0,0,0,0.2);
                transition: 0.3s;
            }
            .movie-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 12px 30px rgba(0, 212, 255, 0.2);
                border-color: var(--accent-blue);
            }
            .movie-poster {
                height: 350px;
                width: 100%;
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
            footer {
                background-color: var(--navbar-bg);
                border-top: 1px solid #334155;
            }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold" href="HomeController">
                    <i class="fas fa-film me-2"></i>PRJ CINEMA
                </a>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item"><a class="nav-link active" href="HomeController">Lịch Chiếu</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Khuyến Mãi</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="hero-section text-center">
            <div class="container">
                <h1 class="display-4 fw-bold mb-3">Mở Cửa Thế Giới Điện Ảnh</h1>
                <p class="lead mb-4 text-light">Đặt vé nhanh chóng, ghế ngồi thoải mái, trải nghiệm tuyệt vời.</p>
                <div class="mt-4">
                    <a href="login.jsp" class="btn btn-primary fw-bold px-4 py-2 rounded-pill me-2"><i class="fas fa-sign-in-alt me-2"></i>ĐĂNG NHẬP</a>
                    <a href="register.jsp" class="btn btn-outline-register fw-bold px-4 py-2 rounded-pill"><i class="fas fa-user-plus me-2"></i>ĐĂNG KÝ THÀNH VIÊN</a>
                </div>
            </div>
        </div>

        <div class="container mb-5">
            <h3 class="fw-bold section-title">PHIM ĐANG CHIẾU</h3>

            <div class="row g-4">
                <c:forEach items="${LIST_MOVIE}" var="movie">
                    <div class="col-lg-3 col-md-6">
                        <div class="card movie-card h-100">
                            <img src="${movie.posterUrl}" class="movie-poster" alt="${movie.title}">
                            <div class="card-body d-flex flex-column text-center">
                                <h5 class="card-title fw-bold">${movie.title}</h5>
                                <p class="text-muted small mb-3">${movie.genre}</p>

                                <%-- KIỂM TRA TRẠNG THÁI ĐĂNG NHẬP --%>
                                <c:choose>
                                    <%-- TRƯỜNG HỢP 1: ĐÃ ĐĂNG NHẬP (Có biến LOGIN_USER trong session) --%>
                                    <c:when test="${not empty sessionScope.LOGIN_USER}">
                                        <a href="welcome.jsp?id=${movie.movieID}" class="btn btn-primary mt-auto w-100 fw-bold rounded-pill">
                                            Mua Vé Ngay
                                        </a>
                                    </c:when>

                                    <%-- TRƯỜNG HỢP 2: CHƯA ĐĂNG NHẬP (Session rỗng) --%>
                                    <c:otherwise>
                                        <a href="login.jsp" class="btn btn-primary mt-auto w-100 fw-bold rounded-pill">
                                            Mua Vé Ngay
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                <%-- KẾT THÚC KIỂM TRA --%>

                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <footer class="text-center py-4 mt-5">
            <p class="mb-0 text-muted">&copy; 2024 PRJ Cinema. All rights reserved.</p>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
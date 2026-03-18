<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>${MOVIE_DETAIL.title} - PRJ Cinema</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                color: var(--text-main);
                font-family: 'Roboto', sans-serif;
            }
            .navbar {
                background-color: var(--navbar-bg);
                border-bottom: 1px solid #334155;
            }
            .navbar-brand {
                color: var(--accent-blue) !important;
                font-size: 1.5rem;
            }
            .movie-poster {
                width: 100%;
                border-radius: 12px;
                box-shadow: 0 10px 20px rgba(0,0,0,0.5);
                border: 1px solid #334155;
            }
            .btn-primary {
                background-color: var(--accent-blue);
                border-color: var(--accent-blue);
                color: #111827;
            }
            .btn-primary:hover {
                background-color: #00b8e6;
                color: #000;
            }
            .review-zone {
                background-color: var(--bg-card);
                border-radius: 12px;
                border: 1px solid #334155;
                padding: 30px;
                margin-top: 40px;
            }
            .rating-star {
                color: #ffc107;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold" href="HomeController"><i class="fas fa-film me-2"></i>PRJ CINEMA</a>
                <div class="d-flex align-items-center gap-2 ms-auto">
                    <c:if test="${not empty sessionScope.LOGIN_USER}">
                        <span class="text-white small me-3 fw-bold">${sessionScope.LOGIN_USER.fullName}</span>
                        <a href="MainController?action=logout" class="btn btn-outline-danger btn-sm rounded-pill"><i class="fas fa-sign-out-alt"></i></a>
                        </c:if>
                        <c:if test="${empty sessionScope.LOGIN_USER}">
                        <a href="login.jsp" class="btn btn-outline-light btn-sm rounded-pill">Đăng Nhập</a>
                    </c:if>
                </div>
            </div>
        </nav>

        <div class="container mt-5">
            <a href="HomeController" class="btn btn-outline-secondary mb-4 text-white"><i class="fas fa-arrow-left me-2"></i>Quay lại danh sách phim</a>

            <div class="row">
                <div class="col-md-4 mb-4">
                    <img src="${MOVIE_DETAIL.posterUrl}" alt="Poster" class="movie-poster">
                </div>

                <div class="col-md-8">
                    <h1 class="fw-bold" style="color: var(--accent-blue);">${MOVIE_DETAIL.title}</h1>
                    <p class="text-muted fs-5 mb-4"><i class="fas fa-tags me-2"></i>${MOVIE_DETAIL.genre}</p>

                    <h4 class="mb-4">
                        <span class="rating-star"><i class="fas fa-star"></i></span> 
                        <span class="fw-bold">${MOVIE_DETAIL.avgRating}</span> <span class="text-muted small">/ 5.0</span>
                    </h4>

                    <p style="font-size: 1.1rem; line-height: 1.7;">${MOVIE_DETAIL.description}</p>

                    <h3 class="mt-4 text-warning fw-bold">
                        <fmt:formatNumber value="${MOVIE_DETAIL.basePrice}" type="number" pattern="#,###"/> đ
                    </h3>

                    <c:choose>
                        <c:when test="${not empty sessionScope.LOGIN_USER}">
                            <a href="BookingController?movieID=${MOVIE_DETAIL.movieID}" class="btn btn-primary btn-lg mt-4 px-5 rounded-pill fw-bold shadow-lg">
                                <i class="fas fa-ticket-alt me-2"></i> MUA VÉ 
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="login.jsp" class="btn btn-primary btn-lg mt-4 px-5 rounded-pill fw-bold shadow-lg">
                                <i class="fas fa-sign-in-alt me-2"></i> MUA VÉ
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="review-zone mb-5 shadow-lg">
                <h3 class="fw-bold mb-4" style="color: var(--accent-blue); border-bottom: 2px solid #334155; padding-bottom: 10px;">
                    <i class="fas fa-comments me-2"></i>Đánh giá từ khán giả
                </h3>

                <c:if test="${CAN_REVIEW}">
                    <div class="card bg-dark border-secondary mb-4">
                        <div class="card-body">
                            <h5 class="text-warning mb-3">Bạn đã xem phim này! Hãy để lại đánh giá nhé:</h5>
                            <form action="ReviewController" method="POST">
                                <input type="hidden" name="movieID" value="${MOVIE_DETAIL.movieID}">

                                <div class="mb-3">
                                    <label class="form-label text-light">Chất lượng phim (Sao):</label>
                                    <select name="rating" class="form-select bg-secondary text-light border-0" style="width: 150px;" required>
                                        <option value="5">⭐⭐⭐⭐⭐ (Tuyệt vời)</option>
                                        <option value="4">⭐⭐⭐⭐ (Rất hay)</option>
                                        <option value="3">⭐⭐⭐ (Bình thường)</option>
                                        <option value="2">⭐⭐ (Khá tệ)</option>
                                        <option value="1">⭐ (Quá dở)</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <textarea name="comment" class="form-control bg-secondary text-light border-0" rows="3" placeholder="Viết cảm nghĩ của bạn..." required></textarea>
                                </div>

                                <button type="submit" class="btn btn-warning fw-bold text-dark px-4">Gửi Đánh Giá</button>
                            </form>
                        </div>
                    </div>
                </c:if>

                <c:if test="${!CAN_REVIEW}">
                    <div class="alert alert-secondary text-center" style="background-color: #111827; border-color: #334155; color: #94a3b8;">
                        <i class="fas fa-lock me-2"></i> Hệ thống chỉ cho phép người đã đặt vé và xem phim tham gia đánh giá.
                    </div>
                </c:if>

                <div class="mt-4">
                    <c:choose>
                        <c:when test="${empty REVIEW_LIST}">
                            <p class="text-center text-muted mt-4">Chưa có đánh giá nào cho bộ phim này.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${REVIEW_LIST}" var="review">
                                <div class="d-flex mb-4 pb-3" style="border-bottom: 1px dashed #334155;">
                                    <div class="me-3">
                                        <div style="width: 50px; height: 50px; background-color: var(--accent-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #111827; font-size: 1.2rem;">
                                            ${review.fullName.substring(0,1)}
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="mb-1 text-light fw-bold">${review.fullName}</h6>
                                        <div class="mb-2">
                                            <span class="rating-star">
                                                <c:forEach begin="1" end="${review.rating}"><i class="fas fa-star"></i></c:forEach>
                                                </span>
                                                <span class="text-muted small ms-2">${review.reviewDate}</span>
                                        </div>
                                        <p class="mb-0 text-light" style="opacity: 0.9;">${review.comment}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </body>
</html>
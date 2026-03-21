<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>${MOVIE_DETAIL.title} - PRJ Cinema</title>

        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #1b212c;
                --bg-card: #28303d;
                --bg-darker: #111827;
                --accent-blue: #0ea5e9;
                --accent-hover: #0284c7;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --border-color: #334155;
                --warning: #f59e0b;
                --danger: #ef4444;
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
                padding-bottom: 50px;
            }
            a {
                text-decoration: none;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }

            /* --- 2. THANH ĐIỀU HƯỚNG (NAVBAR) --- */
            .navbar {
                background-color: var(--bg-darker);
                border-bottom: 1px solid var(--border-color);
                box-shadow: 0 4px 15px rgba(0,0,0,0.5);
                position: sticky;
                top: 0;
                z-index: 1000;
                margin-bottom: 40px;
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
            .user-area {
                display: flex;
                align-items: center;
                gap: 15px;
            }
            .user-name {
                font-weight: bold;
                font-size: 0.9rem;
            }

            .btn {
                padding: 8px 20px;
                border-radius: 20px;
                font-weight: bold;
                font-size: 0.9rem;
                cursor: pointer;
                transition: 0.3s;
                text-align: center;
                display: inline-block;
                border: 1px solid transparent;
            }
            .btn-outline-danger {
                border-color: var(--danger);
                color: var(--danger);
                background: transparent;
            }
            .btn-outline-danger:hover {
                background: var(--danger);
                color: white;
            }
            .btn-outline-light {
                border-color: var(--text-muted);
                color: var(--text-main);
                background: transparent;
            }
            .btn-outline-light:hover {
                background: var(--text-muted);
                color: var(--bg-darker);
            }

            .btn-back {
                border-color: var(--border-color);
                color: var(--text-main);
                background: transparent;
                margin-bottom: 30px;
            }
            .btn-back:hover {
                background: var(--border-color);
            }

            /* --- 3. CHI TIẾT PHIM (GRID 2 CỘT) --- */
            .movie-layout {
                display: grid;
                grid-template-columns: 350px 1fr;
                gap: 40px;
                margin-bottom: 50px;
            }
            @media (max-width: 768px) {
                .movie-layout {
                    grid-template-columns: 1fr;
                }
            }

            .movie-poster {
                width: 100%;
                border-radius: 12px;
                box-shadow: 0 10px 20px rgba(0,0,0,0.5);
                border: 1px solid var(--border-color);
                background-color: var(--bg-darker); /* Màu chờ load ảnh */
            }

            .movie-info h1 {
                color: var(--accent-blue);
                font-size: 2.5rem;
                margin-bottom: 10px;
                line-height: 1.2;
            }
            .genre-tag {
                color: var(--text-muted);
                font-size: 1.1rem;
                margin-bottom: 20px;
                display: block;
            }
            .rating-display {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 25px;
                font-size: 1.3rem;
            }
            .star-icon {
                color: var(--warning);
            }
            .rating-score {
                font-weight: bold;
                color: var(--text-main);
            }
            .rating-max {
                color: var(--text-muted);
                font-size: 1rem;
            }

            .description {
                font-size: 1.1rem;
                line-height: 1.7;
                color: #e2e8f0;
                margin-bottom: 30px;
            }

            .price-tag {
                color: var(--warning);
                font-size: 1.8rem;
                font-weight: bold;
                margin-bottom: 30px;
            }

            .btn-buy {
                background-color: var(--accent-blue);
                color: white;
                padding: 15px 40px;
                font-size: 1.1rem;
                border-radius: 30px;
                box-shadow: 0 5px 15px rgba(14, 165, 233, 0.4);
            }
            .btn-buy:hover {
                background-color: var(--accent-hover);
                transform: translateY(-2px);
            }

            /* --- 4. KHU VỰC ĐÁNH GIÁ (REVIEWS) --- */
            .review-zone {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 40px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }
            .section-title {
                color: var(--accent-blue);
                font-size: 1.5rem;
                border-bottom: 2px solid var(--border-color);
                padding-bottom: 15px;
                margin-bottom: 30px;
                text-transform: uppercase;
            }

            /* Box viết đánh giá */
            .write-review-box {
                background-color: var(--bg-darker);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 40px;
            }
            .write-review-box h5 {
                color: var(--warning);
                margin-bottom: 15px;
                font-size: 1.1rem;
            }

            .form-group {
                margin-bottom: 15px;
            }
            .form-label {
                display: block;
                margin-bottom: 8px;
                color: var(--text-main);
                font-weight: bold;
            }
            .form-select, .form-textarea {
                width: 100%;
                background-color: #334155;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 6px;
                font-family: inherit;
                font-size: 1rem;
                outline: none;
            }
            .form-select {
                width: auto;
                min-width: 200px;
                cursor: pointer;
            }
            .form-textarea {
                resize: vertical;
                min-height: 80px;
            }

            .btn-submit-review {
                background-color: var(--warning);
                color: #000;
                border-radius: 6px;
                padding: 10px 25px;
            }
            .btn-submit-review:hover {
                background-color: #d97706;
            }

            .alert-lock {
                background-color: var(--bg-darker);
                border: 1px solid var(--border-color);
                color: var(--text-muted);
                text-align: center;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 40px;
                font-style: italic;
            }

            /* Danh sách bình luận */
            .review-item {
                display: flex;
                gap: 20px;
                padding-bottom: 25px;
                margin-bottom: 25px;
                border-bottom: 1px dashed var(--border-color);
            }
            .review-item:last-child {
                border-bottom: none;
                margin-bottom: 0;
                padding-bottom: 0;
            }

            .avatar {
                width: 50px;
                height: 50px;
                background-color: var(--accent-blue);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                color: #111827;
                font-size: 1.2rem;
                flex-shrink: 0;
            }
            .review-content {
                flex: 1;
            }
            .reviewer-name {
                color: var(--text-main);
                font-weight: bold;
                font-size: 1.05rem;
                margin-bottom: 5px;
            }

            .review-meta {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 10px;
            }
            .stars {
                color: var(--warning);
                letter-spacing: 2px;
            }
            .review-date {
                color: var(--text-muted);
                font-size: 0.85rem;
            }

            .review-text {
                color: #e2e8f0;
                line-height: 1.5;
                font-size: 0.95rem;
            }
            .empty-review {
                text-align: center;
                color: var(--text-muted);
                font-style: italic;
                padding: 20px 0;
            }

        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="navbar-container">
                <a class="navbar-brand" href="HomeController">PRJ CINEMA</a>
                <div class="user-area">
                    <c:choose>
                        <c:when test="${not empty sessionScope.LOGIN_USER}">
                            <span class="user-name text-main">${sessionScope.LOGIN_USER.fullName}</span>
                            <a href="MainController?action=logout" class="btn btn-outline-danger">Thoát</a>
                        </c:when>
                        <c:otherwise>
                            <a href="login.jsp" class="btn btn-outline-light">Đăng Nhập</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </nav>

        <div class="container">
            <a href="HomeController" class="btn btn-back">← Quay lại danh sách phim</a>

            <div class="movie-layout">
                <div class="movie-poster-col">
                    <img src="${MOVIE_DETAIL.posterUrl}" alt="Poster" class="movie-poster" onerror="this.src='data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\' width=\'100%\' height=\'150%\'><rect width=\'100%\' height=\'100%\' fill=\'#111827\'/><text x=\'50%\' y=\'50%\' fill=\'#94a3b8\' font-size=\'14\' font-family=\'sans-serif\' text-anchor=\'middle\' dominant-baseline=\'middle\'>No Image</text></svg>'">
                </div>

                <div class="movie-info">
                    <h1>${MOVIE_DETAIL.title}</h1>
                    <span class="genre-tag">Thể loại: ${MOVIE_DETAIL.genre}</span>

                    <div class="rating-display">
                        <span class="star-icon">★</span> 
                        <span class="rating-score">${MOVIE_DETAIL.avgRating}</span> 
                        <span class="rating-max">/ 5.0</span>
                    </div>

                    <p class="description">${MOVIE_DETAIL.description}</p>

                    <div class="price-tag">
                        <fmt:formatNumber value="${MOVIE_DETAIL.basePrice}" type="number" pattern="#,###"/> đ
                    </div>

                    <c:choose>
                        <c:when test="${not empty sessionScope.LOGIN_USER}">
                            <a href="BookingController?movieID=${MOVIE_DETAIL.movieID}" class="btn btn-buy">
                                ĐẶT VÉ NGAY
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="login.jsp" class="btn btn-buy">
                                ĐĂNG NHẬP ĐỂ ĐẶT VÉ
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="review-zone">
                <h3 class="section-title">Đánh giá từ khán giả</h3>

                <c:if test="${CAN_REVIEW}">
                    <div class="write-review-box">
                        <h5>Bạn đã xem phim này! Hãy để lại đánh giá nhé:</h5>

                        <form action="ReviewController" method="POST">
                            <input type="hidden" name="movieID" value="${MOVIE_DETAIL.movieID}">

                            <div class="form-group">
                                <label class="form-label">Chất lượng phim (Sao):</label>
                                <select name="rating" class="form-select" required>
                                    <option value="5">★★★★★ (Tuyệt vời)</option>
                                    <option value="4">★★★★☆ (Rất hay)</option>
                                    <option value="3">★★★☆☆ (Bình thường)</option>
                                    <option value="2">★★☆☆☆ (Khá tệ)</option>
                                    <option value="1">★☆☆☆☆ (Quá dở)</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <textarea name="comment" class="form-textarea" placeholder="Viết cảm nghĩ của bạn về nội dung, diễn viên, âm thanh..." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-submit-review">Gửi Đánh Giá</button>
                        </form>
                    </div>
                </c:if>

                <c:if test="${!CAN_REVIEW}">
                    <div class="alert-lock">
                        Hệ thống chỉ cho phép người đã đặt vé và xem phim tham gia đánh giá.
                    </div>
                </c:if>

                <div class="review-list">
                    <c:choose>
                        <c:when test="${empty REVIEW_LIST}">
                            <p class="empty-review">Chưa có đánh giá nào cho bộ phim này.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${REVIEW_LIST}" var="review">
                                <div class="review-item">
                                    <div class="avatar">
                                        ${review.fullName.substring(0,1)}
                                    </div>

                                    <div class="review-content">
                                        <div class="reviewer-name">${review.fullName}</div>

                                        <div class="review-meta">
                                            <span class="stars">
                                                <c:forEach begin="1" end="${review.rating}">★</c:forEach><c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                                                </span>
                                                    <span class="review-date">${review.reviewDate}</span>
                                        </div>

                                        <p class="review-text">${review.comment}</p>
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
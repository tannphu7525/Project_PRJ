<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Chọn Suất Chiếu - PRJ Cinema</title>
        
        <style>
            /* --- 1. BIẾN MÀU & RESET --- */
            :root {
                --bg-body: #1b212c;
                --bg-card: #28303d;
                --accent-blue: #0ea5e9;
                --accent-hover: #0284c7;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --navbar-bg: #111827;
                --border-card: #334155;
            }
            * { box-sizing: border-box; margin: 0; padding: 0; }
            body {
                background-color: var(--bg-body);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                color: var(--text-main);
                padding-bottom: 50px;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            a { text-decoration: none; }
            
            /* --- 2. THANH ĐIỀU HƯỚNG (NAVBAR) --- */
            .navbar {
                background-color: var(--navbar-bg);
                box-shadow: 0 4px 15px rgba(0,0,0,0.3);
                border-bottom: 1px solid var(--border-card);
                margin-bottom: 40px;
                padding: 15px 0;
            }
            .navbar-container {
                max-width: 1000px;
                margin: 0 auto;
                padding: 0 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .navbar-brand {
                color: var(--accent-blue);
                font-size: 1.5rem;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            /* --- 3. BỐ CỤC CHÍNH --- */
            .main-wrapper {
                max-width: 1000px;
                margin: 0 auto;
                padding: 0 20px;
                flex: 1;
                width: 100%;
            }
            
            .btn-back {
                color: var(--text-muted);
                font-weight: 500;
                transition: 0.2s;
                display: inline-block;
                margin-bottom: 20px;
                font-size: 1rem;
            }
            .btn-back:hover { color: #fff; }

            .container-box {
                background-color: #1a1e29;
                border-radius: 16px;
                padding: 40px;
                box-shadow: 0 15px 40px rgba(0,0,0,0.6);
                border: 1px solid var(--border-card);
            }
            .page-title {
                color: var(--accent-blue);
                font-weight: bold;
                font-size: 1.8rem;
                margin-bottom: 40px;
                padding-bottom: 20px;
                border-bottom: 2px solid var(--border-card);
                text-transform: uppercase;
                letter-spacing: 1px;
                text-align: center;
            }
            
            /* --- 4. TRẠNG THÁI TRỐNG (EMPTY) --- */
            .empty-state {
                text-align: center;
                padding: 50px 20px;
            }
            .empty-icon {
                font-size: 4rem;
                display: block;
                margin-bottom: 20px;
                filter: grayscale(1) opacity(0.5);
            }
            .empty-state h4 { color: var(--text-muted); margin-bottom: 10px; font-size: 1.2rem; }
            .empty-state p { color: #64748b; font-size: 0.95rem; }

            /* --- 5. NHÓM NGÀY CHIẾU & LƯỚI SUẤT CHIẾU --- */
            .date-group {
                margin-bottom: 40px;
            }
            .date-divider {
                color: #e2e8f0;
                font-size: 1.2rem;
                font-weight: bold;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                border-left: 4px solid var(--accent-blue);
                padding: 12px 15px;
                background-color: #262c38;
                border-radius: 4px;
                letter-spacing: 0.5px;
            }
            
            .showtime-grid {
                display: grid;
                /* Tự động chia cột, mỗi cột tối thiểu 180px */
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 15px;
            }

            /* --- 6. THẺ SUẤT CHIẾU (CARD) --- */
            .st-card {
                display: block;
                background-color: var(--bg-card);
                border: 1px solid var(--border-card);
                color: #fff;
                border-radius: 10px;
                padding: 20px 15px;
                text-align: center;
                transition: all 0.3s ease-in-out;
                position: relative;
                overflow: hidden;
                cursor: pointer;
            }
            .st-card:hover {
                border-color: var(--accent-blue);
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(14, 165, 233, 0.25);
            }
            
            /* Hiệu ứng nền xanh lướt lên khi hover */
            .st-card::before {
                content: '';
                position: absolute; 
                top: 0; left: 0; width: 100%; height: 100%;
                background-color: var(--accent-blue);
                opacity: 0;
                transition: 0.3s ease;
                z-index: 1;
            }
            .st-card:hover::before { opacity: 1; }
            
            .st-card-content {
                position: relative; 
                z-index: 2;
            }
            .show-time {
                font-size: 1.8rem;
                font-weight: bold;
                color: var(--accent-blue);
                transition: 0.3s;
                margin-bottom: 5px;
            }
            .st-card:hover .show-time { color: #fff; }
            
            .room-info {
                font-size: 0.85rem;
                color: var(--text-muted);
                transition: 0.3s;
                line-height: 1.4;
            }
            .st-card:hover .room-info { color: rgba(255, 255, 255, 0.9); }

            /* --- 7. FOOTER --- */
            footer {
                text-align: center;
                padding: 25px 0;
                margin-top: 50px;
                border-top: 1px solid var(--border-card);
                color: var(--text-muted);
                font-size: 0.9rem;
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="navbar-container">
                <a class="navbar-brand" href="HomeController">PRJ CINEMA</a>
            </div>
        </nav>

        <div class="main-wrapper">
            <a href="HomeController" class="btn-back">← Quay lại Trang Chủ</a>

            <div class="container-box">
                <h2 class="page-title">🎟️ CHỌN SUẤT CHIẾU</h2>

                <c:choose>
                    <c:when test="${empty SHOWTIME_LIST}">
                        <div class="empty-state">
                            <span class="empty-icon">🎬</span>
                            <h4>Rất tiếc, bộ phim này hiện chưa có lịch chiếu.</h4>
                            <p>Vui lòng quay lại sau hoặc chọn bộ phim khác.</p>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:set var="prevDate" value="" />
                        
                        <c:forEach var="st" items="${SHOWTIME_LIST}" varStatus="status">
                            
                            <c:if test="${st.showDate != prevDate}">
                                <c:if test="${not status.first}">
                                        </div> </div> </c:if>
                                
                                <div class="date-group">
                                    <div class="date-divider">
                                        📅 ${st.showDate}
                                    </div>
                                    <div class="showtime-grid">
                                        
                                <c:set var="prevDate" value="${st.showDate}" />
                            </c:if>
                            
                            <a href="BookingController?action=loadSeats&showtimeID=${st.showtimeID}&roomID=${st.roomID}" class="st-card">
                                <div class="st-card-content">
                                    <div class="show-time">${fn:substring(st.startTime, 0, 5)}</div>
                                    <div class="room-info">
                                        📍 ${st.cinemaName} <br>
                                        (${st.roomName})
                                    </div>
                                </div>
                            </a>
                            
                            <c:if test="${status.last}">
                                    </div> </div> </c:if>
                            
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <footer>
            <p>&copy; 2026 PRJ Cinema. All rights reserved.</p>
        </footer>

    </body>
</html>
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
                --border-card: #334155;
            }
            body {
                background-color: var(--bg-body);
                font-family: 'Roboto', sans-serif;
                color: var(--text-main);
                padding-bottom: 80px;
            }
            
            /* --- NAVBAR STYLE --- */
            .navbar {
                background-color: var(--navbar-bg);
                box-shadow: 0 4px 15px rgba(0,0,0,0.3);
                border-bottom: 1px solid var(--border-card);
                margin-bottom: 40px;
            }
            .navbar-brand {
                color: var(--accent-blue) !important;
                font-size: 1.5rem;
            }

            /* --- CONTAINER BOX --- */
            .container-box {
                background-color: #1a1e29;
                border-radius: 16px;
                padding: 40px 50px;
                box-shadow: 0 15px 40px rgba(0,0,0,0.6);
                border: 1px solid var(--border-card);
            }
            .page-title {
                color: var(--accent-blue);
                font-weight: 700;
                margin-bottom: 40px;
                padding-bottom: 20px;
                border-bottom: 2px solid var(--border-card);
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            
            /* --- Phong cách nhóm theo Ngày --- */
            .date-group {
                margin-bottom: 35px;
            }
            .date-divider {
                color: #e2e8f0;
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                border-left: 4px solid var(--accent-blue);
                padding-left: 15px;
                background-color: #262c38;
                padding-top: 10px; 
                padding-bottom: 10px;
                border-radius: 4px;
            }
            .showtime-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 15px;
            }

            /* --- Phong cách Thẻ Suất Chiếu mới --- */
            .st-card {
                display: block;
                background-color: var(--bg-card);
                border: 1px solid var(--border-card);
                color: #fff;
                border-radius: 10px;
                padding: 15px;
                text-align: center;
                text-decoration: none;
                transition: all 0.3s ease-in-out;
                position: relative;
                overflow: hidden;
                cursor: pointer;
            }
            .st-card:hover {
                border-color: var(--accent-blue);
                color: #000;
                transform: translateY(-5px);
                box-shadow: 0 0 15px rgba(0, 212, 255, 0.4);
            }
            .st-card::before {
                content: '';
                position: absolute; top: 0; left: 0; width: 100%; height: 100%;
                background-color: var(--accent-blue);
                opacity: 0;
                transition: 0.3s ease;
                z-index: 1;
            }
            .st-card:hover::before { opacity: 1; }
            
            .st-card-content {
                position: relative; z-index: 2;
            }
            .show-time {
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--accent-blue);
                transition: 0.3s;
            }
            .st-card:hover .show-time { color: #000; }
            
            .room-info {
                font-size: 0.8rem;
                margin-top: 8px;
                color: var(--text-muted);
                transition: 0.3s;
            }
            .st-card:hover .room-info { color: #333; }

            .btn-back {
                color: var(--text-muted);
                text-decoration: none;
                font-weight: 500;
                transition: 0.2s;
                display: inline-block;
                margin-bottom: 20px;
            }
            .btn-back:hover { color: #fff; }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold" href="HomeController">
                    <i class="fas fa-film me-2"></i>PRJ CINEMA
                </a>
            </div>
        </nav>

        <div class="container">
            <a href="HomeController" class="btn-back"><i class="fas fa-arrow-left me-2"></i>Quay lại Trang Chủ</a>

            <div class="container-box">
                <h2 class="page-title text-center"><i class="fas fa-ticket-alt me-3"></i>CHỌN SUẤT CHIẾU</h2>

                <c:choose>
                    <c:when test="${empty SHOWTIME_LIST}">
                        <div class="text-center py-5">
                            <i class="fas fa-film fa-4x mb-4" style="color: #475569;"></i>
                            <h4 style="color: #94a3b8;">Rất tiếc, bộ phim này hiện chưa có lịch chiếu.</h4>
                            <p style="color: #64748b;">Vui lòng quay lại sau hoặc chọn bộ phim khác.</p>
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
                                        <i class="far fa-calendar-alt me-2"></i> ${st.showDate}
                                    </div>
                                    <div class="showtime-grid">
                                        
                                <c:set var="prevDate" value="${st.showDate}" />
                            </c:if>
                            
                            <a href="BookingController?action=loadSeats&showtimeID=${st.showtimeID}&roomID=${st.roomID}" class="st-card">
                                <div class="st-card-content">
                                    <div class="show-time">${fn:substring(st.startTime, 0, 5)}</div>
                                    <div class="room-info">
                                        <i class="fas fa-map-marker-alt me-1"></i> ${st.cinemaName} <br>
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

        <footer class="text-center py-4 mt-5" style="border-top: 1px solid #334155;">
            <p class="mb-0 text-muted">&copy; 2024 PRJ Cinema. All rights reserved.</p>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
<%-- 
    Document   : admin_showtime
    Created on : Mar 1, 2026, 12:29:50 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Lịch chiếu</title>
</head>
<body>

    <h1>QUẢN LÝ LỊCH CHIẾU (SHOWTIMES)</h1>
    
    <a href="MainController?action=adminShowtime&subAction=list">
        <button>Tải dữ liệu</button>
    </a>
    <a href="MainController?action=adminMovie"><button>Quay lại Quản lý Phim</button></a>
    
    <br><br>
    <c:if test="${not empty msg}">
        <h3 style="color: blue;">Thông báo: ${msg}</h3>
    </c:if>

    <hr>

    <h2>1. Danh sách Lịch chiếu</h2>
    <table border="1">
        <tr>
            <th>Mã Lịch</th>
            <th>Tên Phim</th>
            <th>Rạp</th>
            <th>Phòng</th>
            <th>Ngày chiếu</th>
            <th>Giờ chiếu</th>
            <th>Giá vé</th>
            <th>Trạng thái</th>
        </tr>
        <c:forEach var="st" items="${SHOWTIME_LIST}">
            <tr>
                <td>${st.showtimeID}</td>
                <td><b>${st.movieTitle}</b></td>
                <td>${st.cinemaName}</td>
                <td>${st.roomName}</td>
                <td>${st.showDate}</td>
                <td>${st.startTime}</td>
                <td>${st.price} đ</td>
                <td>${st.status ? 'Mở bán' : 'Đã khóa'}</td>
            </tr>
        </c:forEach>
    </table>

    <hr>

    <h2>2. Thêm Lịch chiếu mới</h2>
    <form action="MainController" method="POST">
        <input type="hidden" name="action" value="adminShowtime">
        <input type="hidden" name="subAction" value="add">

        <label>Chọn Phim:</label>
        <select name="movieID">
            <c:forEach var="movie" items="${MOVIE_LIST}">
                <option value="${movie.movieID}">${movie.title}</option>
            </c:forEach>
        </select><br><br>

        <label>Chọn Phòng chiếu:</label>
        <select name="roomID">
            <c:forEach var="room" items="${ROOM_LIST}">
                <option value="${room.roomID}">${room.roomName} (Sức chứa: ${room.capacity})</option>
            </c:forEach>
        </select><br><br>

        <label>Ngày chiếu (YYYY-MM-DD):</label>
        <input type="date" name="showDate" required><br><br>

        <label>Giờ chiếu (HH:MM):</label>
        <input type="time" name="startTime" required><br><br>

        <label>Giá vé suất này:</label>
        <input type="number" name="price" value="80000" required><br><br>

        <label>Trạng thái Mở bán:</label>
        <input type="checkbox" name="status" checked><br><br>

        <button type="submit">Lưu Lịch Chiếu</button>
    </form>

</body>
</html>

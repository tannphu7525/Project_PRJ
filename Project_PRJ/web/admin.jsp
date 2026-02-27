<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Backend - Admin</title>
</head>
<body>

    <h1>ADMIN PAGE</h1>
    
    <a href="AdminMovieController?subAction=list">
        <button>Tải danh sách phim từ DB</button>
    </a>
    
    <br><br>
    
    <c:if test="${not empty sessionScope.msg}">
        <h3 style="color: green;">Thông báo: ${sessionScope.msg}</h3>
        <%-- Lệnh dưới đây giúp xóa thông báo đi, tránh việc F5 nó vẫn hiện --%>
        <c:remove var="msg" scope="session" />
    </c:if>

    <hr>

    <h2>1. Danh sách phim (Dữ liệu từ DB)</h2>
    <table border="1">
        <tr>
            <th>ID Phim</th>
            <th>Tên Phim</th>
            <th>Thể loại</th>
            <th>Giá vé</th>
            <th>Trạng thái</th>
            <th>Xóa</th>
        </tr>
        <c:forEach var="movie" items="${ADMIN_MOVIE_LIST}">
            <tr>
                <td>${movie.movieID}</td>
                <td>${movie.title}</td>
                <td>${movie.genre}</td>
                <td>${movie.basePrice}</td>
                <td>${movie.status ? 'Đang chiếu' : 'Ngừng chiếu'}</td>
                <td>
                    <form action="AdminMovieController" method="POST">
                        <input type="hidden" name="action" value="adminMovie">
                        <input type="hidden" name="subAction" value="delete">
                        <input type="hidden" name="movieID" value="${movie.movieID}">
                        <button type="submit">Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>

    <hr>

    <h2>2. Form Thêm / Cập nhật phim</h2>
    <form action="AdminMovieController" method="POST">
        <input type="hidden" name="action" value="adminMovie">

        <label>Bạn muốn làm gì?:</label>
        <select name="subAction">
            <option value="add">Thêm phim mới</option>
            <option value="update">Sửa thông tin phim</option>
        </select>
        <br><br>

        <label>ID Phim (Chỉ nhập ID nếu bạn chọn Sửa):</label>
        <input type="number" name="movieID" value="0"><br><br>

        <label>Tên phim:</label>
        <input type="text" name="title"><br><br>

        <label>Mô tả:</label>
        <input type="text" name="description"><br><br>

        <label>Link Poster:</label>
        <input type="text" name="posterUrl"><br><br>

        <label>Thể loại:</label>
        <input type="text" name="genre"><br><br>

        <label>Giá vé:</label>
        <input type="number" name="basePrice"><br><br>

        <label>Đang chiếu:</label>
        <input type="checkbox" name="status" checked><br><br>

        <button type="submit">Add / Update</button>
    </form>

</body>
</html>
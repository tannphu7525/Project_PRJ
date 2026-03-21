<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar">

    <a href="HomeController" class="sidebar-link">
        Trang chủ
    </a>

    <a href="MainController?action=adminMovie&subAction=list" class="sidebar-link ${param.action == 'adminMovie' ? 'active' : ''}">
        Quản lý Phim
    </a>

    <a href="MainController?action=adminShowtime&subAction=list" class="sidebar-link ${param.action == 'adminShowtime' ? 'active' : ''}">
        Quản lý Lịch chiếu
    </a>

    <a href="MainController?action=adminCinema&subAction=list" class="sidebar-link ${param.action == 'adminCinema' ? 'active' : ''}">
        Quản lý Rạp phim
    </a>

    <a href="MainController?action=adminRoom" class="sidebar-link ${param.action == 'adminRoom' ? 'active' : ''}">
        Quản lý Phòng chiếu
    </a>

    <a href="MainController?action=adminVoucher" class="sidebar-link ${param.action == 'adminVoucher' ? 'active' : ''}">
        Quản lý Voucher
    </a>

    <a href="MainController?action=adminUser" class="sidebar-link ${param.action == 'adminUser' ? 'active' : ''}">
        Quản lý User
    </a>

    <a href="MainController?action=adminBooking" class="sidebar-link ${param.action == 'adminBooking' ? 'active' : ''}">
        Doanh thu & Đơn hàng
    </a>

    <a href="MainController?action=adminReview" class="sidebar-link ${param.action == 'adminReview' ? 'active' : ''}">
        Quản lý Đánh giá
    </a>

</div>
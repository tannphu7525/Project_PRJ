<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="col-md-3 col-lg-2 p-0 sidebar d-none d-md-block position-sticky overflow-auto" style="top: 70px; height: calc(100vh - 70px);">

    <a href="HomeController" class="sidebar-link">
        <i class="fas fa-home"></i> Trang chủ
    </a>

    <a href="MainController?action=adminMovie&subAction=list" class="sidebar-link ${param.action == 'adminMovie' ? 'active' : ''}">
        <i class="fas fa-video"></i> Quản lý Phim
    </a>

    <a href="MainController?action=adminShowtime&subAction=list" class="sidebar-link ${param.action == 'adminShowtime' ? 'active' : ''}">
        <i class="fas fa-calendar-alt"></i> Quản lý Lịch chiếu
    </a>

    <a href="MainController?action=adminCinema&subAction=list" class="sidebar-link ${param.action == 'adminCinema' ? 'active' : ''}">
        <i class="fas fa-building"></i> Quản lý Rạp phim
    </a>

    <a href="MainController?action=adminRoom" class="sidebar-link ${param.action == 'adminRoom' ? 'active' : ''}">
        <i class="fas fa-door-closed"></i> Quản lý Phòng chiếu
    </a>

    <a href="MainController?action=adminVoucher" class="sidebar-link ${param.action == 'adminVoucher' ? 'active' : ''}">
        <i class="fas fa-ticket-alt"></i> Quản lý Voucher
    </a>

    <a href="MainController?action=adminUser" class="sidebar-link ${param.action == 'adminUser' ? 'active' : ''}">
        <i class="fas fa-users-cog"></i> Quản lý User
    </a>

    <a href="MainController?action=adminBooking" class="sidebar-link ${param.action == 'adminBooking' ? 'active' : ''}">
        <i class="fas fa-chart-line"></i> Doanh thu & Đơn hàng
    </a>
        
    <a href="MainController?action=adminReview" class="sidebar-link ${param.action == 'adminReview' ? 'active' : ''}">
        <i class="fas fa-comments"></i> Quản lý Đánh giá
    </a>
</div>
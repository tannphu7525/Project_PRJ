package model;

import java.sql.Timestamp;
import java.sql.Date;
import java.sql.Time;

public class OrderHistoryDTO {
    private int orderID;
    private Timestamp orderDate;
    private double totalAmount;
    private String movieTitle;
    private String cinemaName;
    private String roomName;
    private Date showDate;
    private Time startTime;
    private String seats; // Chứa chuỗi ghế gộp lại (VD: "A1, A2, B3")

    public OrderHistoryDTO() {
    }

    public OrderHistoryDTO(int orderID, Timestamp orderDate, double totalAmount, String movieTitle, String cinemaName, String roomName, Date showDate, Time startTime, String seats) {
        this.orderID = orderID;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.movieTitle = movieTitle;
        this.cinemaName = cinemaName;
        this.roomName = roomName;
        this.showDate = showDate;
        this.startTime = startTime;
        this.seats = seats;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public String getCinemaName() {
        return cinemaName;
    }

    public void setCinemaName(String cinemaName) {
        this.cinemaName = cinemaName;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public Date getShowDate() {
        return showDate;
    }

    public void setShowDate(Date showDate) {
        this.showDate = showDate;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public String getSeats() {
        return seats;
    }

    public void setSeats(String seats) {
        this.seats = seats;
    }


}
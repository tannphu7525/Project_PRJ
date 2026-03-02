/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class SeatDTO {
    private int seatID;
    private int roomID;
    private String seatName;
    private String seatType;
    private boolean status;

    // Thuộc tính mở rộng để check xem ghế đã bị ai mua trong suất chiếu này chưa
    private boolean isBooked;

    public SeatDTO(int seatID, int roomID, String seatName, String seatType, boolean status, boolean isBooked) {
        this.seatID = seatID;
        this.roomID = roomID;
        this.seatName = seatName;
        this.seatType = seatType;
        this.status = status;
        this.isBooked = isBooked;
    }

    public int getSeatID() {
        return seatID;
    }

    public void setSeatID(int seatID) {
        this.seatID = seatID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getSeatName() {
        return seatName;
    }

    public void setSeatName(String seatName) {
        this.seatName = seatName;
    }

    public String getSeatType() {
        return seatType;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public boolean isBooked() {
        return isBooked;
    }

    public void setIsBooked(boolean isBooked) {
        this.isBooked = isBooked;
    }
  
}
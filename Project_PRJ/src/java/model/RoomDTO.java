/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class RoomDTO {
    private int roomID;
    private int cinemaID;
    private String roomName;
    private int capacity;
    private boolean status;
    
    private String cinemaName;
    
    public RoomDTO() {
    }

    public RoomDTO(int roomID, int cinemaID, String roomName, int capacity, boolean status, String cinemaName) {
        this.roomID = roomID;
        this.cinemaID = cinemaID;
        this.roomName = roomName;
        this.capacity = capacity;
        this.status = status;
        this.cinemaName = cinemaName;
    }

    public String getCinemaName() {
        return cinemaName;
    }

    public void setCinemaName(String cinemaName) {
        this.cinemaName = cinemaName;
    }



    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public int getCinemaID() {
        return cinemaID;
    }

    public void setCinemaID(int cinemaID) {
        this.cinemaID = cinemaID;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    
}

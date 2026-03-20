package model;

public class ReviewDTO {
    private int reviewID;
    private int userID;
    private int movieID;
    private int rating;
    private String comment;
    private String reviewDate; 
    private String fullName;

    //Admin
    private String userName;
    private String movieTitle;

    public ReviewDTO() {
    }

    public ReviewDTO(int reviewID, int userID, int movieID, int rating, String comment, String reviewDate, String fullName) {
        this.reviewID = reviewID;
        this.userID = userID;
        this.movieID = movieID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
        this.fullName = fullName;
    }

    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getMovieID() {
        return movieID;
    }

    public void setMovieID(int movieID) {
        this.movieID = movieID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(String reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    
}
package com.cinebook.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Booking {

    private int bookingId;
    private int customerId;
    private int showtimeId;
    private BigDecimal totalAmount;
    private String bookingStatus;
    private Timestamp bookedAt;

    // ✅ Extra fields from JOIN queries
    private String customerName;
    private String movieTitle;
    private Date showDate;
    private Time showTime;
    private String hall;
    private String seatNumbers;
    
    private String paymentMethod;
    private String paymentStatus;
    private String transactionId;
    private java.math.BigDecimal paymentAmount;
    
    private java.math.BigDecimal refundAmount;
    private String refundStatus;
    private java.sql.Timestamp cancelledAt;
    private java.math.BigDecimal cancellationFee;

    public Booking() {}

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getShowtimeId() { return showtimeId; }
    public void setShowtimeId(int showtimeId) { this.showtimeId = showtimeId; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }

    public Timestamp getBookedAt() { return bookedAt; }
    public void setBookedAt(Timestamp bookedAt) { this.bookedAt = bookedAt; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }

    public Date getShowDate() { return showDate; }
    public void setShowDate(Date showDate) { this.showDate = showDate; }

    public Time getShowTime() { return showTime; }
    public void setShowTime(Time showTime) { this.showTime = showTime; }

    public String getHall() { return hall; }
    public void setHall(String hall) { this.hall = hall; }

    public String getSeatNumbers() { return seatNumbers; }
    public void setSeatNumbers(String seatNumbers) { this.seatNumbers = seatNumbers; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public BigDecimal getPaymentAmount() { return paymentAmount; }
    public void setPaymentAmount(BigDecimal paymentAmount) { this.paymentAmount = paymentAmount; }
    
    public java.math.BigDecimal getRefundAmount() { return refundAmount; }
    public void setRefundAmount(java.math.BigDecimal refundAmount) { this.refundAmount = refundAmount; }

    public String getRefundStatus() { return refundStatus; }
    public void setRefundStatus(String refundStatus) { this.refundStatus = refundStatus; }

    public java.sql.Timestamp getCancelledAt() { return cancelledAt; }
    public void setCancelledAt(java.sql.Timestamp cancelledAt) { this.cancelledAt = cancelledAt; }
    
    public java.math.BigDecimal getCancellationFee() { return cancellationFee; }
    public void setCancellationFee(java.math.BigDecimal cancellationFee) { 
        this.cancellationFee = cancellationFee; 
    }
}
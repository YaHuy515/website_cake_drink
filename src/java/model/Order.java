package model;

import java.sql.Timestamp;

public class Order {
    private int id;
    private Timestamp orderDate;
    private String username;
    private double totalAmount;
    private String fullname;
    private String phone;
    private String address;
    private String status; // 'Pending', 'Approved', 'Completed', 'Cancelled'
    private String voucherCode;
    private double discountAmount;

    public Order() {
    }

    public Order(int id, Timestamp orderDate, String username, double totalAmount, String fullname, String phone, String address, String status) {
        this.id = id;
        this.orderDate = orderDate;
        this.username = username;
        this.totalAmount = totalAmount;
        this.fullname = fullname;
        this.phone = phone;
        this.address = address;
        this.status = status;
    }

    public Order(int id, Timestamp orderDate, String username, double totalAmount, String fullname, String phone, String address, String status, String voucherCode, double discountAmount) {
        this.id = id;
        this.orderDate = orderDate;
        this.username = username;
        this.totalAmount = totalAmount;
        this.fullname = fullname;
        this.phone = phone;
        this.address = address;
        this.status = status;
        this.voucherCode = voucherCode;
        this.discountAmount = discountAmount;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }
}

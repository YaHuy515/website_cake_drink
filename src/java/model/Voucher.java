package model;

import java.sql.Timestamp;

public class Voucher {
    private int id;
    private String code;
    private String discountType; 
    private double discountValue;
    private double minOrderValue;
    private double maxDiscountAmount;
    private int quantity;
    private Timestamp startDate;
    private Timestamp endDate;
    private boolean status;

    public Voucher() {
    }

    public Voucher(int id, String code, String discountType, double discountValue, double minOrderValue, double maxDiscountAmount, int quantity, Timestamp startDate, Timestamp endDate, boolean status) {
        this.id = id;
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderValue = minOrderValue;
        this.maxDiscountAmount = maxDiscountAmount;
        this.quantity = quantity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public double getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public double getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(double maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}

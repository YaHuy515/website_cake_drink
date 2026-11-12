package model;

public class Product {
    private int id;
    private String name;
    private int categoryId;
    private double price;
    private int quantity;
    private String image;
    private String description;
    private boolean status;
    private String categoryName; // helper field to show Category Name without extra queries
    private String detailDescription;
    private String ingredients;
    private String instruction;
    private String servingSize;

    public Product() {
    }

    public Product(int id, String name, int categoryId, double price, int quantity, String image, String description, boolean status) {
        this.id = id;
        this.name = name;
        this.categoryId = categoryId;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
        this.description = description;
        this.status = status;
    }

    public Product(int id, String name, int categoryId, double price, int quantity, String image, String description, boolean status, String detailDescription, String ingredients, String instruction, String servingSize) {
        this.id = id;
        this.name = name;
        this.categoryId = categoryId;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
        this.description = description;
        this.status = status;
        this.detailDescription = detailDescription;
        this.ingredients = ingredients;
        this.instruction = instruction;
        this.servingSize = servingSize;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDetailDescription() {
        if (detailDescription == null || detailDescription.trim().isEmpty()) {
            return description;
        }
        return detailDescription;
    }

    public void setDetailDescription(String detailDescription) {
        this.detailDescription = detailDescription;
    }

    public String getIngredients() {
        return ingredients;
    }

    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }

    public String getInstruction() {
        return instruction;
    }

    public void setInstruction(String instruction) {
        this.instruction = instruction;
    }

    public String getServingSize() {
        return servingSize;
    }

    public void setServingSize(String servingSize) {
        this.servingSize = servingSize;
    }
}

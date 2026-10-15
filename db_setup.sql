-- SQL Script to set up database and insert sample data
USE master;
GO

-- Create database if not exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'webbanhang')
BEGIN
    CREATE DATABASE webbanhang;
END
GO

USE webbanhang;
GO

-- Drop tables if they exist (child tables first)
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL DROP TABLE OrderDetails;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Accounts', 'U') IS NOT NULL DROP TABLE Accounts;
GO

-- Create Categories Table
CREATE TABLE Categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255)
);

-- Create Products Table
CREATE TABLE Products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(150) NOT NULL,
    category_id INT FOREIGN KEY REFERENCES Categories(id),
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    image NVARCHAR(500),
    description NVARCHAR(MAX),
    status BIT NOT NULL DEFAULT 1 -- 1: Active, 0: Inactive
);

-- Create Accounts Table
CREATE TABLE Accounts (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    fullname NVARCHAR(100) NOT NULL,
    email VARCHAR(100),
    role VARCHAR(20) NOT NULL, -- 'admin' or 'customer'
    status BIT NOT NULL DEFAULT 1 -- 1: Active, 0: Blocked
);

-- Create Orders Table
CREATE TABLE Orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_date DATETIME NOT NULL DEFAULT GETDATE(),
    username VARCHAR(50) FOREIGN KEY REFERENCES Accounts(username),
    total_amount DECIMAL(10, 2) NOT NULL,
    fullname NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    status NVARCHAR(50) NOT NULL DEFAULT 'Pending' -- 'Pending', 'Approved', 'Completed', 'Cancelled'
);

-- Create OrderDetails Table
CREATE TABLE OrderDetails (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(id) ON DELETE CASCADE,
    product_id INT FOREIGN KEY REFERENCES Products(id),
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);
GO

-- Insert Categories
INSERT INTO Categories (name, description) VALUES 
(N'Đồ Uống', N'Các loại trà, cà phê, sinh tố và nước ép tươi mát'),
(N'Bánh Ngọt & Kẹo', N'Bánh mousse, tiramisu, bánh ngọt Pháp và kẹo ngọt hấp dẫn');
GO

-- Insert Products
-- Drink items (category_id = 1)
INSERT INTO Products (name, category_id, price, quantity, image, description, status) VALUES
(N'Cà Phê Sữa Đá', 1, 29000.00, 100, 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=500&auto=format&fit=crop&q=60', N'Cà phê espresso pha phin truyền thống hòa quyện với sữa đặc và đá lạnh mang đậm hương vị Việt Nam.', 1),
(N'Trà Đào Cam Sả', 1, 39000.00, 80, 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=500&auto=format&fit=crop&q=60', N'Trà đào thanh mát kết hợp với hương cam thơm ngọt và sả nồng nàn thơm phức.', 1),
(N'Matcha Đá Xay', 1, 45000.00, 50, 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=500&auto=format&fit=crop&q=60', N'Bột trà xanh Nhật Bản thượng hạng xay cùng sữa tươi và đá tuyết, phủ kem tươi mịn màng.', 1),
(N'Trà Sữa Trân Châu Hoàng Kim', 1, 45000.00, 120, 'https://images.unsplash.com/photo-1541658016709-82535e94bc69?w=500&auto=format&fit=crop&q=60', N'Trà sữa béo ngậy truyền thống kèm theo trân châu hoàng kim dai giòn sần sật.', 1),
(N'Nước Ép Trái Cây Nhiệt Đới', 1, 35000.00, 60, 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=500&auto=format&fit=crop&q=60', N'Nước ép nguyên chất từ dứa, chanh dây, cam tươi giàu vitamin và giải nhiệt cực tốt.', 1),
(N'Bạc Xỉu Sữa Nóng', 1, 32000.00, 75, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&auto=format&fit=crop&q=60', N'Sự kết hợp hoàn hảo giữa sữa đặc béo ngậy và hương thơm cà phê nguyên chất dịu nhẹ.', 1),
(N'Cà Phê Muối Kem Béo', 1, 39000.00, 90, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=500&auto=format&fit=crop&q=60', N'Cà phê đen phin đậm đà phủ lớp kem muối mặn mặn béo ngậy độc đáo.', 1),
(N'Trà Oolong Sen Vàng', 1, 45000.00, 85, 'https://oola.vn/wp-content/uploads/2023/03/o-long-sen-vang-1.jpg', N'Trà Oolong thanh khiết kết hợp cùng hạt sen bùi béo và củ năng giòn sần sật.', 1),
(N'Sinh Tố Bơ Dừa Tuyết', 1, 48000.00, 40, 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=500&auto=format&fit=crop&q=60', N'Bơ sáp chín mềm mịn xay cùng nước cốt dừa lạnh tuyết ngọt ngào, thơm béo khó cưỡng.', 1),
(N'Trà Nhài Đút Đuôi Phụng', 1, 39000.00, 95, 'https://images.unsplash.com/photo-1597481499750-3e6b22637e12?w=500&auto=format&fit=crop&q=60', N'Trà hoa nhài truyền thống thơm dịu, thanh lọc cơ thể cực tốt cho ngày hè.', 1),
(N'Cà Phê Cold Brew Cam Sả', 1, 49000.00, 45, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500&auto=format&fit=crop&q=60', N'Cà phê ủ lạnh hơn 16 tiếng thơm nhẹ vị hoa quả, kết hợp lát cam vàng và hương sả sảng khoái.', 1),
(N'Hồng Trà Sữa Macchiato', 1, 42000.00, 110, 'https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=500&auto=format&fit=crop&q=60', N'Hồng trà đậm vị phủ lớp kem béo mặn Macchiato mịn màng bên trên.', 1),
(N'Nước Ép Lựu Đỏ Dưa Hấu', 1, 38000.00, 70, 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=500&auto=format&fit=crop&q=60', N'Nước ép mix từ lựu đỏ ngọt lịm và dưa hấu tươi mát giàu vitamin C.', 1),
(N'Cacao Cốt Dừa Đá Xay', 1, 45000.00, 55, 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=500&auto=format&fit=crop&q=60', N'Cacao đậm đà hòa quyện với cốt dừa béo ngậy được xay tuyết mát lạnh.', 1),
(N'Trà Hoa Cúc Mật Ong', 1, 35000.00, 65, 'https://images.unsplash.com/photo-1563822249548-9a72b6353cd1?w=500&auto=format&fit=crop&q=60', N'Trà hoa cúc sấy khô ủ ấm, thêm mật ong rừng ngọt thanh giúp thư giãn tinh thần.', 1);

-- Sweet/Cake items (category_id = 2)
INSERT INTO Products (name, category_id, price, quantity, image, description, status) VALUES
(N'Bánh Tiramisu', 2, 49000.00, 30, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=500&auto=format&fit=crop&q=60', N'Bánh ngọt Ý trứ danh với vị cà phê nồng nàn, lớp kem trứng mascarpone béo ngậy và bột cacao.', 1),
(N'Bánh Mousse Dâu Tây', 2, 45000.00, 25, 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=500&auto=format&fit=crop&q=60', N'Lớp mousse dâu tây chua chua ngọt ngọt mềm mịn tan ngay trong miệng.', 1),
(N'Croissant Bơ Tỏi', 2, 35000.00, 40, 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500&auto=format&fit=crop&q=60', N'Bánh sừng bò ngàn lớp giòn rụm bên ngoài, mềm xốp bên trong đượm hương bơ tỏi thơm nức.', 1),
(N'Bánh Bông Lan Trứng Muối', 2, 55000.00, 20, 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&auto=format&fit=crop&q=60', N'Cốt bánh bông lan mềm mại phủ sốt bơ trứng, chà bông mặn mà và lòng đỏ trứng muối bùi béo.', 1),
(N'Bánh Cookie Sô-cô-la', 2, 25000.00, 150, 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=500&auto=format&fit=crop&q=60', N'Bánh quy nướng giòn rụm với hạt sô cô la chip đắng ngọt xen kẽ.', 1),
(N'Macaron Ngũ Sắc Pháp', 2, 45000.00, 60, 'https://images.unsplash.com/photo-1569864358642-9d1684040f43?w=500&auto=format&fit=crop&q=60', N'Bộ 5 chiếc bánh Macaron Pháp giòn rụm lớp vỏ bên ngoài, ẩm mịn ngọt ngào bên trong.', 1),
(N'Bánh Red Velvet Nhung Đỏ', 2, 52000.00, 18, 'https://images.unsplash.com/photo-1616541823729-00fe0aacd32c?w=500&auto=format&fit=crop&q=60', N'Lớp cốt bánh đỏ nhung xen kẽ lớp kem cheese chua nhẹ béo mịn đặc sắc.', 1),
(N'Bánh Cheesecake Chanh Leo', 2, 48000.00, 22, 'https://images.unsplash.com/photo-1607330289024-1535c6b4e1c1?w=500&auto=format&fit=crop&q=60', N'Bánh phô mai nướng đế quy bùi ngậy phủ mứt chanh leo chua thanh giải ngấy cực tốt.', 1),
(N'Bánh Tart Trứng Bơ Pháp', 2, 30000.00, 50, 'https://images.unsplash.com/photo-1568254183919-78a4f43a2877?w=500&auto=format&fit=crop&q=60', N'Lớp vỏ nghìn lớp giòn tan đượm bơ Pháp ôm trọn nhân kem trứng sữa nướng caramel thơm lừng.', 1),
(N'Bánh Muffin Việt Quất', 2, 28000.00, 35, 'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=500&auto=format&fit=crop&q=60', N'Bánh Muffin nướng xốp mềm đượm hương thơm từ quả việt quất tươi mọng nước.', 1),
(N'Bánh Crepe Sầu Riêng Kem Tươi', 2, 45000.00, 15, 'https://emdoi.vn/wp-content/uploads/2024/08/banh-crepe-sau-rieng-ngon-tphcm-4.webp', N'Lớp vỏ crepe dai mềm cuộn tròn cơm sầu riên tươi béo ngậy cùng kem whipping mát lạnh.', 1),
(N'Bánh Mousse Matcha Nhật Bản', 2, 45000.00, 20, 'https://cdn.tgdd.vn/2021/02/CookProduct/1200-1200x676-30.jpg', N'Mousse trà xanh đậm vị chát nhẹ đan xen lớp kem mousse ngọt dịu tinh tế.', 1),
(N'Bánh Su Kem Vani Gấp Đôi', 2, 20000.00, 80, 'https://images.unsplash.com/photo-1579372786545-d24232daf58c?w=500&auto=format&fit=crop&q=60', N'Vỏ bánh su giòn nhẹ bên ngoài, ngập tràn nhân kem vani sữa tươi mát lạnh bên trong.', 1),
(N'Bánh Brownie Hạnh Nhân', 2, 38000.00, 30, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&auto=format&fit=crop&q=60', N'Bánh sô cô la nướng ẩm đặc đắng nhẹ, phủ đầy hạt hạnh nhân giòn giã bùi bùi.', 1),
(N'Bánh Donut Phủ Đường Quế', 2, 25000.00, 45, 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500&auto=format&fit=crop&q=60', N'Bánh donut vòng chiên phồng xốp mềm, lăn qua lớp đường quế thơm nồng ấm áp.', 1);
GO

-- Insert Accounts
INSERT INTO Accounts (username, password, fullname, email, role, status) VALUES
('admin', '123', N'Quản trị viên hệ thống', 'admin@store.com', 'admin', 1),
('customer', '123', N'Nguyễn Văn An', 'an.nv@gmail.com', 'customer', 1);
GO

-- Create Vouchers Table
IF OBJECT_ID('Vouchers', 'U') IS NOT NULL DROP TABLE Vouchers;
CREATE TABLE Vouchers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_type NVARCHAR(20) NOT NULL, -- 'Percentage' or 'Amount'
    discount_value DECIMAL(10, 2) NOT NULL,
    min_order_value DECIMAL(10, 2) DEFAULT 0,
    max_discount_amount DECIMAL(10, 2) DEFAULT 0,
    quantity INT NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status BIT NOT NULL DEFAULT 1
);
GO

-- Add voucher_code and discount_amount columns to Orders table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'voucher_code')
BEGIN
    ALTER TABLE Orders ADD voucher_code VARCHAR(50);
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'discount_amount')
BEGIN
    ALTER TABLE Orders ADD discount_amount DECIMAL(10, 2) DEFAULT 0;
END
GO

-- Insert sample vouchers
INSERT INTO Vouchers (code, discount_type, discount_value, min_order_value, max_discount_amount, quantity, start_date, end_date, status) VALUES
('SUMMER50', N'Amount', 50000.00, 150000.00, 0.00, 100, '2026-08-01 00:00:00', '2026-09-30 23:59:59', 1),
('KM10', N'Percentage', 10.00, 50000.00, 30000.00, 200, '2026-08-01 00:00:00', '2026-12-31 23:59:59', 1);
GO

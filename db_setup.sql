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

-- Drop tables if they exist (child tables first to satisfy Foreign Keys)
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL DROP TABLE OrderDetails;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Accounts', 'U') IS NOT NULL DROP TABLE Accounts;
IF OBJECT_ID('Vouchers', 'U') IS NOT NULL DROP TABLE Vouchers;
GO

-- 1. Create Categories Table
CREATE TABLE Categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255)
);

-- 2. Create Products Table (including rich details for Product Detail page)
CREATE TABLE Products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(150) NOT NULL,
    category_id INT FOREIGN KEY REFERENCES Categories(id),
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    image NVARCHAR(500),
    description NVARCHAR(MAX),
    detail_description NVARCHAR(MAX),
    ingredients NVARCHAR(500),
    instruction NVARCHAR(500),
    serving_size NVARCHAR(100),
    status BIT NOT NULL DEFAULT 1 -- 1: Active, 0: Inactive
);

-- 3. Create Accounts Table
CREATE TABLE Accounts (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    fullname NVARCHAR(100) NOT NULL,
    email VARCHAR(100),
    role VARCHAR(20) NOT NULL, -- 'admin' or 'customer'
    status BIT NOT NULL DEFAULT 1 -- 1: Active, 0: Blocked
);

-- 4. Create Orders Table
CREATE TABLE Orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_date DATETIME NOT NULL DEFAULT GETDATE(),
    username VARCHAR(50) FOREIGN KEY REFERENCES Accounts(username),
    total_amount DECIMAL(10, 2) NOT NULL,
    fullname NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    status NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Approved', 'Completed', 'Cancelled'
    voucher_code VARCHAR(50),
    discount_amount DECIMAL(10, 2) DEFAULT 0
);

-- 5. Create OrderDetails Table
CREATE TABLE OrderDetails (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(id) ON DELETE CASCADE,
    product_id INT FOREIGN KEY REFERENCES Products(id),
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- 6. Create Vouchers Table
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

-- ============================================================================
-- INSERT SAMPLE DATA
-- ============================================================================

-- Insert Categories
INSERT INTO Categories (name, description) VALUES 
(N'Đồ Uống', N'Các loại trà, cà phê, sinh tố và nước ép tươi mát'),
(N'Bánh Ngọt & Kẹo', N'Bánh mousse, tiramisu, bánh ngọt Pháp và kẹo ngọt hấp dẫn');
GO

-- Insert Products with Full Details (Drinks: category_id = 1)
INSERT INTO Products (name, category_id, price, quantity, image, description, detail_description, ingredients, instruction, serving_size, status) VALUES
(
    N'Cà Phê Sữa Đá', 1, 29000.00, 100, 
    'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=500&auto=format&fit=crop&q=60', 
    N'Cà phê espresso pha phin truyền thống hòa quyện với sữa đặc và đá lạnh mang đậm hương vị Việt Nam.',
    N'Cà phê sữa đá là biểu tượng của văn hóa ẩm thực đường phố Việt Nam. Từng giọt cà phê phin đậm đà chiết xuất từ hạt Robusta cao nguyên đất đỏ bazan, hòa quyện tuyệt vời với lớp sữa đặc sánh mịn béo ngọt. Thức uống mang lại nguồn năng lượng sảng khoái và đánh thức mọi giác quan cho ngày làm việc hứng khởi.',
    N'Hạt cà phê Robusta Đắk Lắk nguyên chất rang mộc, sữa đặc có đường Ngôi Sao Phương Nam, đá viên tinh khiết',
    N'Khuấy đều trước khi dùng để sữa và cà phê hòa quyện tròn vị. Dùng kèm đá lạnh trong vòng 1-2 giờ.',
    N'Ly 350ml (Size M)', 1
),
(
    N'Trà Đào Cam Sả', 1, 39000.00, 80, 
    'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=500&auto=format&fit=crop&q=60', 
    N'Trà đào thanh mát kết hợp với hương cam thơm ngọt và sả nồng nàn thơm phức.',
    N'Thức uống giải nhiệt thanh mát với sự kết hợp kinh điển giữa vị thanh chát nhẹ của trà ô long hảo hạng, vị chua ngọt dịu êm của cam vàng tươi mọng nước và hương sả thoang thoảng nồng nàn. Điểm nhấn là những lát đào miếng giòn ngọt, mọng nước tạo nên trải nghiệm thưởng thức bùng nổ vị giác.',
    N'Trà ô long thượng hạng ủ lạnh, nước cốt cam vàng Nam Phi tươi, sả tươi đập dập thơm nồng, đào ngâm giòn ngọt, siro đào tự nhiên',
    N'Uống lạnh trực tiếp kèm đá, khuấy nhẹ và thưởng thức từng miếng đào giòn ngọt.',
    N'Ly 500ml (Size L)', 1
),
(
    N'Matcha Đá Xay', 1, 45000.00, 50, 
    'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=500&auto=format&fit=crop&q=60', 
    N'Bột trà xanh Nhật Bản thượng hạng xay cùng sữa tươi và đá tuyết, phủ kem tươi mịn màng.',
    N'Được làm từ bột matcha thượng hạng vùng Uji - Kyoto (Nhật Bản), thức uống mang sắc xanh ngọc bích cuốn hút với vị chát dịu đặc trưng nơi đầu lưỡi và hậu vị ngọt thanh tinh tế. Cốt đá xay mịn mướt mát lạnh hòa cùng sữa tươi, phủ ngập tràn lớp bông kem tươi béo ngậy, ngọt dịu khó cưỡng.',
    N'Bột trà xanh Matcha Uji nhập khẩu Nhật Bản nguyên chất, sữa tươi thanh trùng không đường, sốt vani, kem whipping béo ngậy',
    N'Dùng muỗng thưởng thức lớp kem tươi béo ngậy bên trên hoặc khuấy đều kem với cốt matcha đá tuyết bên dưới.',
    N'Ly 450ml (Size L)', 1
),
(
    N'Trà Sữa Trân Châu Hoàng Kim', 1, 45000.00, 120, 
    'https://images.unsplash.com/photo-1541658016709-82535e94bc69?w=500&auto=format&fit=crop&q=60', 
    N'Trà sữa béo ngậy truyền thống kèm theo trân châu hoàng kim dai giòn sần sật.',
    N'Hương vị trà sữa truyền thống thơm nức mũi nhờ cốt hồng trà Ceylon đậm vị kết hợp vị béo ngậy êm dịu của sữa. Điểm nhấn là trân châu hoàng kim màu vàng hổ phách trong suốt, dẻo dai sần sật được ngâm đường nâu thơm lừng, khiến mỗi ngụm uống đều ngập tràn niềm vui.',
    N'Trà đen Ceylon hảo hạng, sữa bột béo thực vật cao cấp, sữa đặc, trân châu hoàng kim nấu đường nâu',
    N'Lắc hoặc khuấy đều trước khi cắm ống hút trân châu to để hút trọn từng hạt trân châu dẻo bùi.',
    N'Ly 500ml (Size L)', 1
),
(
    N'Nước Ép Trái Cây Nhiệt Đới', 1, 35000.00, 60, 
    'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=500&auto=format&fit=crop&q=60', 
    N'Nước ép nguyên chất từ dứa, chanh dây, cam tươi giàu vitamin và giải nhiệt cực tốt.',
    N'Ly nước ép nguyên chất 100% từ trái cây tươi thu hoạch trong ngày, không phẩm màu, không chất bảo quản. Sự hòa trộn giữa vị ngọt thanh của dứa chín, chua dịu của chanh dây và vị tươi mới của cam sành cung cấp dồi dào Vitamin C và khoáng chất tự nhiên giúp thanh lọc cơ thể và làm sáng da.',
    N'Dứa mật chín cây, chanh dây vàng Đà Lạt, cam sành mọng nước, đường mía tự nhiên',
    N'Ngon nhất khi dùng lạnh ngay sau khi ép. Lắc đều trước khi uống.',
    N'Ly 450ml', 1
),
(
    N'Bạc Xỉu Sữa Nóng', 1, 32000.00, 75, 
    'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&auto=format&fit=crop&q=60', 
    N'Sự kết hợp hoàn hảo giữa sữa đặc béo ngậy và hương thơm cà phê nguyên chất dịu nhẹ.',
    N'Bạc xỉu ấm áp là sự lựa chọn hoàn hảo cho những ai yêu thích vị ngọt ngào béo thơm của sữa nhưng vẫn vương vấn chút đắng nhẹ của cà phê phin. Lớp bọt sữa bông mịn được đánh thủ công tỉ mỉ giữ cho thức uống luôn ấm nóng và dậy hương thơm nồng nàn.',
    N'Sữa đặc ngọt béo, sữa tươi thanh trùng đánh nóng, cà phê phin Robusta nguyên chất tạo điểm nhấn',
    N'Dùng nóng trực tiếp hoặc khuấy nhẹ để cảm nhận hơi ấm và hương thơm ngào ngạt.',
    N'Ly 250ml (Size M)', 1
),
(
    N'Cà Phê Muối Kem Béo', 1, 39000.00, 90, 
    'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=500&auto=format&fit=crop&q=60', 
    N'Cà phê đen phin đậm đà phủ lớp kem muối mặn mặn béo ngậy độc đáo.',
    N'Cà phê muối xứ Huế nay được biến tấu chuẩn phong vị hiện đại. Lớp kem muối béo ngậy, mịn màng có vị mặn mòi nhẹ nhàng giúp cân bằng hoàn hảo và tôn vinh trọn vẹn vị đắng đậm đà, thơm lừng của cà phê phin truyền thống.',
    N'Cà phê phin Robusta nguyên chất, kem whipping, sữa béo thực vật, một chút muối biển hầm tinh khiết',
    N'Uống trực tiếp qua lớp kem muối mặn béo bên trên trước khi khuấy đều với lớp cà phê đậm đặc bên dưới.',
    N'Ly 350ml (Size M)', 1
),
(
    N'Trà Oolong Sen Vàng', 1, 45000.00, 85, 
    'https://oola.vn/wp-content/uploads/2023/03/o-long-sen-vang-1.jpg', 
    N'Trà Oolong thanh khiết kết hợp cùng hạt sen bùi béo và củ năng giòn sần sật.',
    N'Trà Oolong Sen Vàng thanh tao mang đậm phong vị Á Đông. Cốt trà Oolong vàng óng thơm dịu kết hợp cùng hạt sen tươi nấu mềm bùi và củ năng xắt hạt lựu giòn tan tạo nên một bản hòa tấu hoàn mỹ giữa hương thơm thanh nhã và vị ngọt bùi tự nhiên.',
    N'Trà Oolong thượng hạng ủ lạnh, hạt sen tươi Đồng Tháp hầm mềm bùi ngậy, củ năng giòn sần sật, lớp kem sữa mặn nhẹ',
    N'Dùng muỗng ăn hạt sen và củ năng bùi ngọt kết hợp nhấp từng ngụm trà oolong thanh tao.',
    N'Ly 500ml (Size L)', 1
),
(
    N'Sinh Tố Bơ Dừa Tuyết', 1, 48000.00, 40, 
    'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=500&auto=format&fit=crop&q=60', 
    N'Bơ sáp chín mềm mịn xay cùng nước cốt dừa lạnh tuyết ngọt ngào, thơm béo khó cưỡng.',
    N'Bơ sáp béo ngậy được chọn lọc kỹ càng, xay cùng cốt dừa tươi thơm nức mũi và đá tuyết mát lạnh. Thức sinh tố sánh đặc mịn màng như nhung, vị ngọt thanh tự nhiên béo bùi tan chảy trong khoang miệng.',
    N'Bơ sáp 034 Đắk Lắk chín dẻo, nước cốt dừa Bến Tre tươi, sữa đặc, đá tuyết xay nhuyễn',
    N'Dùng ngay khi còn lạnh tuyết bằng thìa hoặc ống hút to để cảm nhận độ sánh mịn kem bơ.',
    N'Ly 500ml', 1
),
(
    N'Trà Nhài Đút Đuôi Phụng', 1, 39000.00, 95, 
    'https://images.unsplash.com/photo-1597481499750-3e6b22637e12?w=500&auto=format&fit=crop&q=60', 
    N'Trà hoa nhài truyền thống thơm dịu, thanh lọc cơ thể cực tốt cho ngày hè.',
    N'Trà hoa nhài thanh khiết với từng búp trà xanh mộc ướp hoa nhài tươi tự nhiên. Hương thơm dịu nhẹ quyến rũ lan tỏa khắp không gian, mang lại cảm giác an yên, tĩnh tại và giải tỏa stress tức thì.',
    N'Trà búp xanh ướp hoa nhài tự nhiên cổ truyền, mật ong hoa nhãn, thạch trà thanh mát',
    N'Thưởng thức lạnh hoặc nóng, nhấp từng ngụm để cảm nhận trọn vẹn hương thơm hoa nhài tự nhiên.',
    N'Ly 450ml', 1
),
(
    N'Cà Phê Cold Brew Cam Sả', 1, 49000.00, 45, 
    'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500&auto=format&fit=crop&q=60', 
    N'Cà phê ủ lạnh hơn 16 tiếng thơm nhẹ vị hoa quả, kết hợp lát cam vàng và hương sả sảng khoái.',
    N'Cà phê Cold Brew được chiết xuất chậm rãi trong 16 giờ bằng nước đá lạnh, loại bỏ hoàn toàn vị chát gắt và giữ lại hương thơm trái cây thanh khiết. Kết hợp cùng nước cam mọng và sả thơm tạo nên thức uống sành điệu, giải khát đỉnh cao.',
    N'Cà phê Arabica Cầu Đất ủ lạnh 16 tiếng, nước cam tươi nguyên chất, tinh dầu sả tươi, lát cam sấy dẻo',
    N'Lắc đều cùng đá viên, thưởng thức chậm rãi để cảm nhận từng nốt hương trái cây và thảo mộc.',
    N'Ly 400ml', 1
),
(
    N'Hồng Trà Sữa Macchiato', 1, 42000.00, 110, 
    'https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=500&auto=format&fit=crop&q=60', 
    N'Hồng trà đậm vị phủ lớp kem béo mặn Macchiato mịn màng bên trên.',
    N'Lớp kem Macchiato bồng bềnh phủ trên bề mặt hồng trà thơm ngát. Vị mằn mặn béo ngậy của phô mai quyện cùng vị ngọt chát nhẹ của trà đen mang lại trải nghiệm tương phản đầy thú vị và lôi cuốn.',
    N'Hồng trà đặc sản ủ đậm vị, kem cheese macchiato béo mặn sánh mịn',
    N'Nghiêng ly 45 độ uống trực tiếp để cảm nhận lớp kem béo mặn hòa vào dòng trà thơm mát.',
    N'Ly 500ml', 1
),
(
    N'Nước Ép Lựu Đỏ Dưa Hấu', 1, 38000.00, 70, 
    'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=500&auto=format&fit=crop&q=60', 
    N'Nước ép mix từ lựu đỏ ngọt lịm và dưa hấu tươi mát giàu vitamin C.',
    N'Sắc đỏ rực rỡ bắt mắt cùng vị ngọt lịm mát rượi. Nước ép lựu đỏ giàu chất chống oxy hóa tự nhiên kết hợp dưa hấu giải nhiệt nhanh chóng, xua tan cái nóng oi bức và tiếp thêm năng lượng.',
    N'Lựu đỏ Ai Cập mọng hạt, dưa hấu ruột đỏ ngọt lịm không hạt, nước cốt chanh tươi',
    N'Dùng lạnh ngay sau khi ép, lắc nhẹ trước khi uống.',
    N'Ly 450ml', 1
),
(
    N'Cacao Cốt Dừa Đá Xay', 1, 45000.00, 55, 
    'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=500&auto=format&fit=crop&q=60', 
    N'Cacao đậm đà hòa quyện với cốt dừa béo ngậy được xay tuyết mát lạnh.',
    N'Vị đắng nhẹ thơm lừng của bột cacao cao cấp hòa quyện với vị béo ngọt thanh tao của cốt dừa tươi miền Tây. Thức uống đá xay sánh mịn, thơm nức mũi và cực kỳ cuốn miệng.',
    N'Bột cacao nguyên chất Bến Tre, nước cốt dừa tươi béo ngậy, sữa đặc, đá bào nhuyễn',
    N'Khuấy đều từ dưới lên hoặc dùng muỗng xúc cốt dừa và cacao thưởng thức cùng nhau.',
    N'Ly 450ml', 1
),
(
    N'Trà Hoa Cúc Mật Ong', 1, 35000.00, 65, 
    'https://images.unsplash.com/photo-1563822249548-9a72b6353cd1?w=500&auto=format&fit=crop&q=60', 
    N'Trà hoa cúc sấy khô ủ ấm, thêm mật ong rừng ngọt thanh giúp thư giãn tinh thần.',
    N'Thức trà thảo mộc thanh tao giúp thư giãn tinh thần sau những giờ học tập và làm việc căng thẳng. Vị ngọt dịu của mật ong rừng đượm cùng hương cúc ấm áp mang lại cảm giác bình yên, ngủ sâu giấc.',
    N'Bông hoa cúc vàng sấy khô tự nhiên, mật ong rừng nguyên chất, kỷ tử đỏ, táo đỏ',
    N'Uống ấm hoặc thêm đá tùy thích, rất tốt cho giấc ngủ và thanh lọc gan.',
    N'Ly 400ml', 1
);
GO

-- Insert Products with Full Details (Sweets/Cakes: category_id = 2)
INSERT INTO Products (name, category_id, price, quantity, image, description, detail_description, ingredients, instruction, serving_size, status) VALUES
(
    N'Bánh Tiramisu', 2, 49000.00, 30, 
    'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=500&auto=format&fit=crop&q=60', 
    N'Bánh ngọt Ý trứ danh với vị cà phê nồng nàn, lớp kem trứng mascarpone béo ngậy và bột cacao.',
    N'Chiếc bánh tình yêu trứ danh đến từ nước Ý. Từng lớp bánh quy sampa thấm đẫm cà phê Espresso thơm lừng đan xen lớp kem Mascarpone béo ngậy, phủ lên trên bề mặt lớp bột cacao đắng tinh tế. Bánh tan ngay trong miệng với dư vị ngất ngây khó quên.',
    N'Phô mai Mascarpone nhập khẩu Ý, bánh sampa Savoiardi, cà phê Espresso, rượu nhẹ Kahlua, bột cacao nguyên chất',
    N'Bảo quản ngăn mát 2-6°C. Thưởng thức lạnh để cảm nhận độ tan mềm mượt của lớp kem phô mai.',
    N'1 Phần (130g)', 1
),
(
    N'Bánh Mousse Dâu Tây', 2, 45000.00, 25, 
    'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=500&auto=format&fit=crop&q=60', 
    N'Lớp mousse dâu tây chua chua ngọt ngọt mềm mịn tan ngay trong miệng.',
    N'Mousse dâu tây mang sắc hồng pastel ngọt ngào dịu dàng. Lớp mousse chua ngọt thanh nhẹ từ dâu tây tươi hòa quyện cùng vị béo ngậy của whipping cream cao cấp, đế bánh gato mềm ẩm mang lại trải nghiệm tươi mát.',
    N'Dâu tây Đà Lạt tươi hái trong ngày, kem whipping Anchor, gelatin tự nhiên, cốt bánh gato vani mềm xốp',
    N'Bảo quản ngăn mát tủ lạnh, dùng ngon nhất trong vòng 24 giờ sau khi nhận bánh.',
    N'1 Phần (120g)', 1
),
(
    N'Croissant Bơ Tỏi', 2, 35000.00, 40, 
    'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500&auto=format&fit=crop&q=60', 
    N'Bánh sừng bò ngàn lớp giòn rụm bên ngoài, mềm xốp bên trong đượm hương bơ tỏi thơm nức.',
    N'Bánh sừng bò ngàn lớp chuẩn kỹ thuật Pháp với lớp vỏ ngoài vàng ruộm giòn tan rôm rốp, bên trong nở xốp nhiều tầng đẫm sốt bơ tỏi thơm lừng nức mũi và phô mai kéo sợi dẻo dai béo ngậy.',
    N'Bột mì Pháp T55, bơ lạt nguyên chất Paysan Breton, tỏi cô đơn băm nhuyễn, lá ngò tây sấy, phô mai Mozzarella',
    N'Ngon nhất khi làm nóng trong lò nướng hoặc nồi chiên không dầu ở 160°C trong 3-5 phút trước khi thưởng thức.',
    N'1 Chiếc (110g)', 1
),
(
    N'Bánh Bông Lan Trứng Muối', 2, 55000.00, 20, 
    'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&auto=format&fit=crop&q=60', 
    N'Cốt bánh bông lan mềm mại phủ sốt bơ trứng, chà bông mặn mà và lòng đỏ trứng muối bùi béo.',
    N'Món bánh gây thương nhớ của mọi tín đồ bánh ngọt. Cốt bánh mềm mịn như bông, ngập tràn sốt bơ trứng sóng sánh béo ngậy, kết hợp hoàn hảo cùng chà bông cay mặn đậm đà và những viên trứng muối nướng bùi béo tan mềm.',
    N'Cốt bông lan phô mai sữa xốp nhẹ, sốt bơ trứng hoàng kim sóng sánh, lòng đỏ trứng muối nướng thơm bùi, chà bông heo hảo hạng',
    N'Bảo quản nơi khô ráo thoáng mát hoặc ngăn mát tủ lạnh nếu chưa dùng hết.',
    N'1 Hộp (180g)', 1
),
(
    N'Bánh Cookie Sô-cô-la', 2, 25000.00, 150, 
    'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=500&auto=format&fit=crop&q=60', 
    N'Bánh quy nướng giòn rụm với hạt sô cô la chip đắng ngọt xen kẽ.',
    N'Bánh quy bơ nướng thủ công với viền ngoài giòn rụm và phần lõi dẻo mềm đặc trưng (soft-baked). Những hạt chocolate chip đắng ngọt tan chảy rải đều khắp mặt bánh mang lại cảm giác say mê trong từng miếng cắn.',
    N'Bơ Pháp cao cấp, bột mì nguyên cám, đường nâu mật mía, chocolate chip Callebaut 70% cacao',
    N'Dùng trực tiếp kèm một ly sữa tươi ấm hoặc cà phê, đậy kín nắp sau khi mở để giữ độ giòn.',
    N'Hộp 6 chiếc (150g)', 1
),
(
    N'Macaron Ngũ Sắc Pháp', 2, 45000.00, 60, 
    'https://images.unsplash.com/photo-1569864358642-9d1684040f43?w=500&auto=format&fit=crop&q=60', 
    N'Bộ 5 chiếc bánh Macaron Pháp giòn rụm lớp vỏ bên ngoài, ẩm mịn ngọt ngào bên trong.',
    N'Nữ hoàng bánh ngọt Pháp với vẻ ngoài kiêu sa rực rỡ sắc màu. Lớp vỏ bánh giòn tan nhẹ tênh làm từ 100% bột hạnh nhân, bên trong là nhân kem ganache dẻo mềm đậm đà mang 5 sắc thái hương vị tinh túy.',
    N'Bột hạnh nhân nguyên chất tinh mịn, lòng trắng trứng đánh bông, đường bột, nhân ganache sô cô la, dâu tây, matcha, việt quất và vani',
    N'Bảo quản ngăn mát 2-6°C. Thưởng thức cùng trà nóng để cảm nhận lớp vỏ giòn tan và nhân ngọt ngào.',
    N'Hộp 5 chiếc (5 vị)', 1
),
(
    N'Bánh Red Velvet Nhung Đỏ', 2, 52000.00, 18, 
    'https://images.unsplash.com/photo-1616541823729-00fe0aacd32c?w=500&auto=format&fit=crop&q=60', 
    N'Lớp cốt bánh đỏ nhung xen kẽ lớp kem cheese chua nhẹ béo mịn đặc sắc.',
    N'Sắc đỏ nhung quyến rũ tượng trưng cho tình yêu nồng nàn. Cốt bánh mềm mịn như nhung ẩm mượt thoảng hương cacao, kết hợp tuyệt diệu với các tầng kem phô mai béo ngậy chua thanh nhẹ tênh, ăn hoài không ngấy.',
    N'Cốt bánh nhung đỏ cacao mượt mà, kem phô mai cream cheese Philadelphia béo chua dịu nhẹ, chiết xuất vani',
    N'Bảo quản ngăn mát tủ lạnh, thưởng thức lạnh để kem phô mai đạt độ béo ngậy tối ưu.',
    N'1 Phần (140g)', 1
),
(
    N'Bánh Cheesecake Chanh Leo', 2, 48000.00, 22, 
    'https://images.unsplash.com/photo-1607330289024-1535c6b4e1c1?w=500&auto=format&fit=crop&q=60', 
    N'Bánh phô mai nướng đế quy bùi ngậy phủ mứt chanh leo chua thanh giải ngấy cực tốt.',
    N'Sự kết hợp ăn ý giữa vị béo ngậy đậm đặc của kem phô mai nướng và vị chua thanh sảng khoái của sốt chanh leo tươi nguyên hạt. Lớp đế bánh quy bùi giòn tạo nên kết cấu phong phú và cân bằng vị giác hoàn hảo.',
    N'Kem phô mai cream cheese New Zealand, đế bánh quy bơ nướng giòn rụm, mứt chanh leo tươi nấu hạt giòn',
    N'Bảo quản lạnh, dùng ngon nhất trong 48 giờ.',
    N'1 Phần (130g)', 1
),
(
    N'Bánh Tart Trứng Bơ Pháp', 2, 30000.00, 50, 
    'https://images.unsplash.com/photo-1568254183919-78a4f43a2877?w=500&auto=format&fit=crop&q=60', 
    N'Lớp vỏ nghìn lớp giòn tan đượm bơ Pháp ôm trọn nhân kem trứng sữa nướng caramel thơm lừng.',
    N'Vỏ bánh nghìn lớp nở bung giòn tan rụm đượm mùi bơ thơm phức, ôm ấp phần nhân kem trứng sữa nướng caramel vàng óng mềm mượt, béo ngậy như tan chảy ngay khi vừa chạm đầu lưỡi.',
    N'Vỏ bột ngàn lớp bơ Pháp thơm lừng, nhân kem sữa trứng gà tươi, sữa tươi thanh trùng, đường caramel nướng cháy xém',
    N'Ngon nhất khi ăn lúc còn ấm nóng. Có thể quay lò vi sóng 20 giây trước khi ăn.',
    N'Hộp 2 chiếc (120g)', 1
),
(
    N'Bánh Muffin Việt Quất', 2, 28000.00, 35, 
    'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=500&auto=format&fit=crop&q=60', 
    N'Bánh Muffin nướng xốp mềm đượm hương thơm từ quả việt quất tươi mọng nước.',
    N'Chiếc bánh muffin nướng nở xốp mềm ẩm, đượm hương thơm tự nhiên từ sữa và bơ. Từng quả việt quất tươi mọng vỡ òa vị chua ngọt khi thưởng thức, cung cấp nhiều vitamin và năng lượng lành mạnh.',
    N'Bột mì nở mềm, bơ lạt, sữa chua không đường, quả việt quất tươi nhập khẩu mọng nước',
    N'Bảo quản nhiệt độ phòng 2 ngày hoặc ngăn mát 5 ngày. Dùng tuyệt vời cho bữa sáng hoặc trà chiều.',
    N'1 Chiếc (100g)', 1
),
(
    N'Bánh Crepe Sầu Riêng Kem Tươi', 2, 45000.00, 15, 
    'https://emdoi.vn/wp-content/uploads/2024/08/banh-crepe-sau-rieng-ngon-tphcm-4.webp', 
    N'Lớp vỏ crepe dai mềm cuộn tròn cơm sầu riên tươi béo ngậy cùng kem whipping mát lạnh.',
    N'Cực phẩm dành riêng cho tín đồ mê sầu riêng! Lớp vỏ bánh crepe mỏng dai màu xanh mát mắt cuộn tròn cơm sầu riêng tươi vàng óng, béo ngậy đậm đà hòa quyện cùng lớp kem tươi mát lạnh.',
    N'Vỏ bánh crepe lá dứa dai mềm mịn, cơm sầu riêng Ri6 tươi nguyên chất 100%, kem whipping béo ngậy mát lạnh',
    N'Bảo quản ngăn mát hoặc ngăn đá nhẹ trước khi dùng 15 phút để kem tươi đạt độ lạnh buốt thơm ngon.',
    N'1 Hộp (150g - 2 chiếc)', 1
),
(
    N'Bánh Mousse Matcha Nhật Bản', 2, 45000.00, 20, 
    'https://cdn.tgdd.vn/2021/02/CookProduct/1200-1200x676-30.jpg', 
    N'Mousse trà xanh đậm vị chát nhẹ đan xen lớp kem mousse ngọt dịu tinh tế.',
    N'Món bánh mang đậm phong cách trà đạo Nhật Bản. Vị đắng chát thanh tao đặc trưng của bột matcha thượng hạng được làm dịu bằng lớp kem mousse ngọt thanh êm dịu, mang lại cảm giác thư thái và tinh tế.',
    N'Bột trà xanh Matcha Shizuoka nhập khẩu, kem whipping Anchor, sữa tươi, cốt bông lan trà xanh thanh nhẹ',
    N'Bảo quản ngăn mát 2-6°C. Thưởng thức cùng trà nóng hoặc nước thanh mát.',
    N'1 Phần (120g)', 1
),
(
    N'Bánh Su Kem Vani Gấp Đôi', 2, 20000.00, 80, 
    'https://images.unsplash.com/photo-1579372786545-d24232daf58c?w=500&auto=format&fit=crop&q=60', 
    N'Vỏ bánh su giòn nhẹ bên ngoài, ngập tràn nhân kem vani sữa tươi mát lạnh bên trong.',
    N'Vỏ bánh su nướng phồng giòn nhẹ bên ngoài, bên trong rỗng xốp ngập tràn gấp đôi nhân kem custard vani sữa tươi mịn màng mát lạnh. Cắn một miếng kem tràn khoang miệng mang lại niềm vui sướng khó tả.',
    N'Vỏ su choux pastry nướng giòn rụm bên ngoài xốp nhẹ, nhân kem custard vani sữa tươi béo ngậy',
    N'Bảo quản ngăn mát, cắn ngập miệng để cảm nhận dòng kem tuôn trào mát lạnh.',
    N'Hộp 4 chiếc (160g)', 1
),
(
    N'Bánh Brownie Hạnh Nhân', 2, 38000.00, 30, 
    'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&auto=format&fit=crop&q=60', 
    N'Bánh sô cô la nướng ẩm đặc đắng nhẹ, phủ đầy hạt hạnh nhân giòn giã bùi bùi.',
    N'Bánh sô cô la nướng kiểu Mỹ với kết cấu fudgy ẩm đặc, đắng ngọt đậm đà từ sô cô la đen thượng hạng. Mặt bánh phủ đầy hạt hạnh nhân giòn giã bùi bùi tạo nên sự hòa quyện đỉnh cao.',
    N'Sô cô la đen nguyên chất 72% cacao, bơ nguyên chất, bột cacao, hạt hạnh nhân lát rang giòn',
    N'Bảo quản nơi thoáng mát hoặc làm nóng 15 giây ăn kèm một viên kem vani.',
    N'1 Phần (110g)', 1
),
(
    N'Bánh Donut Phủ Đường Quế', 2, 25000.00, 45, 
    'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500&auto=format&fit=crop&q=60', 
    N'Bánh donut vòng chiên phồng xốp mềm, lăn qua lớp đường quế thơm nồng ấm áp.',
    N'Chiếc donut vòng truyền thống được chiên vàng ươm, ruột bánh xốp mềm ẩm mịn, lăn đều qua lớp đường quế thơm nồng ấm áp mang lại cảm giác dễ chịu và thư giãn tuyệt đối.',
    N'Bột mì lên men tự nhiên, bơ sữa tươi, bột quế hữu cơ thơm nồng, đường nâu mịn màng',
    N'Dùng trực tiếp, ngon tuyệt khi thưởng thức cùng cà phê nóng hoặc trà sữa.',
    N'1 Chiếc (90g)', 1
);
GO

-- Insert Accounts
INSERT INTO Accounts (username, password, fullname, email, role, status) VALUES
('admin', '123', N'Quản trị viên hệ thống', 'admin@store.com', 'admin', 1),
('customer', '123', N'Nguyễn Văn An', 'an.nv@gmail.com', 'customer', 1);
GO

-- Insert sample vouchers
INSERT INTO Vouchers (code, discount_type, discount_value, min_order_value, max_discount_amount, quantity, start_date, end_date, status) VALUES
('SUMMER50', N'Amount', 50000.00, 150000.00, 0.00, 100, '2026-08-01 00:00:00', '2026-09-30 23:59:59', 1),
('KM10', N'Percentage', 10.00, 50000.00, 30000.00, 200, '2026-08-01 00:00:00', '2026-12-31 23:59:59', 1);
GO

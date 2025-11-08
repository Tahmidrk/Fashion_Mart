-- Fashion Mart Database Schema
-- Drop database if exists and create new
DROP DATABASE IF EXISTS fashion_mart;
CREATE DATABASE fashion_mart;
USE fashion_mart;

-- Table: Admin
CREATE TABLE Admin (
    AdminID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Role VARCHAR(50) DEFAULT 'Admin',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Customer
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Number VARCHAR(15),
    RewardPoint INT DEFAULT 0,
    Road VARCHAR(100),
    Area VARCHAR(100),
    City VARCHAR(50),
    District VARCHAR(50),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Dealer
CREATE TABLE Dealer (
    DealerID INT PRIMARY KEY AUTO_INCREMENT,
    DealerName VARCHAR(100) NOT NULL,
    Contact VARCHAR(15),
    Email VARCHAR(100),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Product
CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(150) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10, 2) NOT NULL,
    Quantity INT DEFAULT 0,
    Demand INT DEFAULT 0,
    Rating DECIMAL(3, 2) DEFAULT 0.00,
    Embroidery VARCHAR(50),
    Description TEXT,
    ImageURL VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: DeliveryMan
CREATE TABLE DeliveryMan (
    DeliveryManID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Address TEXT,
    VehicleType VARCHAR(50),
    Status VARCHAR(20) DEFAULT 'Active',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Order (Note: 'Order' is a reserved keyword, using backticks)
CREATE TABLE `Order` (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    CustomerID INT NOT NULL,
    DeliveryManID INT,
    OrderStatus VARCHAR(20) DEFAULT 'Pending',
    PaymentMethod VARCHAR(50) DEFAULT 'Cash on Delivery',
    PaymentStatus VARCHAR(20) DEFAULT 'Pending',
    DeliveryAddress TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (DeliveryManID) REFERENCES DeliveryMan(DeliveryManID) ON DELETE SET NULL
);

-- Table: OrderItem (Junction table for Order and Product)
CREATE TABLE OrderItem (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE
);

-- Table: Payment
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    PaymentMethod VARCHAR(50) NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PaymentStatus VARCHAR(20) DEFAULT 'Pending',
    DealerID INT,
    OrderID INT UNIQUE NOT NULL,
    FOREIGN KEY (DealerID) REFERENCES Dealer(DealerID) ON DELETE SET NULL,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID) ON DELETE CASCADE
);

-- Table: Delivery
CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY AUTO_INCREMENT,
    DeliveryDate DATE,
    DeliveryStatus VARCHAR(20) DEFAULT 'Pending',
    OrderID INT UNIQUE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID) ON DELETE CASCADE
);

-- Table: Review
CREATE TABLE Review (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Comment TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE
);

-- Table: Ranking
CREATE TABLE Ranking (
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT DEFAULT 0,
    PRIMARY KEY (CustomerID, ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE
);

-- Insert sample data for testing

-- Sample Admin
INSERT INTO Admin (Username, Password, Name, Email, Role) VALUES
('admin', 'admin123', 'System Administrator', 'admin@fashionmart.com', 'Super Admin');

-- Sample Dealers
INSERT INTO Dealer (DealerName, Contact, Email) VALUES
('Fashion Hub Ltd.', '01712345678', 'fashionhub@example.com'),
('Style Point', '01823456789', 'stylepoint@example.com');

-- Sample Delivery Men
INSERT INTO DeliveryMan (Username, Password, Name, Email, Phone, Address, VehicleType, Status) VALUES
('delivery1', 'delivery123', 'Karim Rahman', 'karim@delivery.com', '01712345670', 'Mirpur, Dhaka', 'Motorcycle', 'Active'),
('delivery2', 'delivery123', 'Rahim Ahmed', 'rahim@delivery.com', '01812345671', 'Uttara, Dhaka', 'Motorcycle', 'Active'),
('delivery3', 'delivery123', 'Salam Mia', 'salam@delivery.com', '01912345672', 'Mohammadpur, Dhaka', 'Bicycle', 'Active');

-- Sample Customers
INSERT INTO Customer (Username, Password, Name, Email, Number, RewardPoint, Road, Area, City, District) VALUES
('john_doe', 'password123', 'John Doe', 'john@example.com', '01612345678', 100, 'Road 5', 'Dhanmondi', 'Dhaka', 'Dhaka'),
('jane_smith', 'password123', 'Jane Smith', 'jane@example.com', '01712345679', 50, 'Road 10', 'Gulshan', 'Dhaka', 'Dhaka'),
('guest_user', 'password123', 'Guest User', 'guest@example.com', '01812345680', 0, 'Road 1', 'Banani', 'Dhaka', 'Dhaka');

-- Sample Products (50 items)
INSERT INTO Product (ProductName, Category, Price, StockQuantity, EmbroideryType, Description, ImageURL) VALUES
-- Sarees (10 items)
('Elegant Silk Saree', 'Saree', 4500.00, 25, 'Hand Embroidered', 'Beautiful silk saree with traditional hand embroidery work. Perfect for weddings and special occasions.', 'https://via.placeholder.com/300x400?text=Silk+Saree'),
('Cotton Handloom Saree', 'Saree', 2800.00, 30, 'None', 'Pure cotton handloom saree with traditional border design.', 'https://via.placeholder.com/300x400?text=Cotton+Saree'),
('Designer Georgette Saree', 'Saree', 3500.00, 20, 'Machine Embroidered', 'Lightweight georgette saree with modern embroidery patterns.', 'https://via.placeholder.com/300x400?text=Georgette+Saree'),
('Banarasi Silk Saree', 'Saree', 6500.00, 15, 'Hand Embroidered', 'Premium Banarasi silk saree with intricate zari work.', 'https://via.placeholder.com/300x400?text=Banarasi+Saree'),
('Printed Chiffon Saree', 'Saree', 1800.00, 40, 'None', 'Trendy printed chiffon saree for casual and party wear.', 'https://via.placeholder.com/300x400?text=Chiffon+Saree'),
('Kanjivaram Silk Saree', 'Saree', 7500.00, 12, 'Hand Embroidered', 'Authentic Kanjivaram silk saree with temple border.', 'https://via.placeholder.com/300x400?text=Kanjivaram+Saree'),
('Tussar Silk Saree', 'Saree', 4200.00, 18, 'None', 'Natural tussar silk saree with ethnic charm.', 'https://via.placeholder.com/300x400?text=Tussar+Saree'),
('Party Wear Saree', 'Saree', 3800.00, 22, 'Machine Embroidered', 'Glamorous party wear saree with sequin work.', 'https://via.placeholder.com/300x400?text=Party+Saree'),
('Jamdani Saree', 'Saree', 5200.00, 14, 'Hand Embroidered', 'Traditional Jamdani saree with fine muslin fabric.', 'https://via.placeholder.com/300x400?text=Jamdani+Saree'),
('Embroidered Net Saree', 'Saree', 3200.00, 25, 'Machine Embroidered', 'Elegant net saree with beautiful embroidery work.', 'https://via.placeholder.com/300x400?text=Net+Saree'),

-- Punjabi/Men's Traditional (10 items)
('Cotton Punjabi', 'Punjabi', 1800.00, 40, 'Machine Embroidered', 'Comfortable cotton punjabi for everyday wear with elegant machine embroidery.', 'https://via.placeholder.com/300x400?text=Cotton+Punjabi'),
('Silk Punjabi', 'Punjabi', 2500.00, 30, 'Hand Embroidered', 'Premium silk punjabi with hand embroidery for special occasions.', 'https://via.placeholder.com/300x400?text=Silk+Punjabi'),
('Linen Punjabi', 'Punjabi', 2200.00, 35, 'None', 'Breathable linen punjabi perfect for summer wear.', 'https://via.placeholder.com/300x400?text=Linen+Punjabi'),
('Designer Punjabi', 'Punjabi', 2800.00, 25, 'Machine Embroidered', 'Modern designer punjabi with contemporary patterns.', 'https://via.placeholder.com/300x400?text=Designer+Punjabi'),
('Festive Punjabi', 'Punjabi', 3200.00, 20, 'Hand Embroidered', 'Festive punjabi with rich embroidery and premium fabric.', 'https://via.placeholder.com/300x400?text=Festive+Punjabi'),
('Casual Punjabi', 'Punjabi', 1500.00, 50, 'None', 'Simple casual punjabi for everyday comfort.', 'https://via.placeholder.com/300x400?text=Casual+Punjabi'),
('Eid Special Punjabi', 'Punjabi', 3500.00, 28, 'Hand Embroidered', 'Special Eid collection punjabi with elegant design.', 'https://via.placeholder.com/300x400?text=Eid+Punjabi'),
('Printed Punjabi', 'Punjabi', 1600.00, 45, 'None', 'Trendy printed punjabi with modern motifs.', 'https://via.placeholder.com/300x400?text=Printed+Punjabi'),
('Khadi Punjabi', 'Punjabi', 2000.00, 32, 'None', 'Eco-friendly khadi punjabi with natural feel.', 'https://via.placeholder.com/300x400?text=Khadi+Punjabi'),
('Premium Cotton Punjabi', 'Punjabi', 2100.00, 38, 'Machine Embroidered', 'High-quality cotton punjabi with fine embroidery.', 'https://via.placeholder.com/300x400?text=Premium+Punjabi'),

-- Women's Wear (10 items)
('Designer Kurti', 'Kurti', 1200.00, 35, 'None', 'Modern designer kurti with vibrant colors and patterns.', 'https://via.placeholder.com/300x400?text=Designer+Kurti'),
('Embroidered Salwar Kameez', 'Salwar Kameez', 3200.00, 20, 'Hand Embroidered', 'Luxurious salwar kameez with intricate hand embroidery and fine fabric.', 'https://via.placeholder.com/300x400?text=Salwar+Kameez'),
('Party Dress', 'Dress', 2800.00, 15, 'Machine Embroidered', 'Stunning party dress with modern design and embroidery details.', 'https://via.placeholder.com/300x400?text=Party+Dress'),
('Traditional Lehenga', 'Lehenga', 6500.00, 10, 'Hand Embroidered', 'Exquisite traditional lehenga with heavy embroidery work for weddings.', 'https://via.placeholder.com/300x400?text=Lehenga'),
('Anarkali Suit', 'Salwar Kameez', 3800.00, 18, 'Machine Embroidered', 'Elegant Anarkali suit with flowing silhouette.', 'https://via.placeholder.com/300x400?text=Anarkali'),
('Palazzo Set', 'Kurti', 1800.00, 30, 'None', 'Trendy kurti with palazzo pants combination.', 'https://via.placeholder.com/300x400?text=Palazzo+Set'),
('Long Gown', 'Dress', 3500.00, 12, 'Machine Embroidered', 'Graceful long gown for evening parties.', 'https://via.placeholder.com/300x400?text=Long+Gown'),
('Cotton Kurti', 'Kurti', 900.00, 50, 'None', 'Comfortable cotton kurti for daily wear.', 'https://via.placeholder.com/300x400?text=Cotton+Kurti'),
('Sharara Set', 'Salwar Kameez', 4200.00, 14, 'Hand Embroidered', 'Traditional sharara set with rich embroidery.', 'https://via.placeholder.com/300x400?text=Sharara'),
('Maxi Dress', 'Dress', 2200.00, 25, 'None', 'Flowing maxi dress for casual and party wear.', 'https://via.placeholder.com/300x400?text=Maxi+Dress'),

-- Men's Casual Wear (10 items)
('Formal Shirt', 'Shirt', 1500.00, 50, 'None', 'Premium quality formal shirt for office and business meetings.', 'https://via.placeholder.com/300x400?text=Formal+Shirt'),
('Casual T-Shirt', 'T-Shirt', 600.00, 100, 'None', 'Comfortable casual t-shirt available in multiple colors.', 'https://via.placeholder.com/300x400?text=T-Shirt'),
('Denim Jeans', 'Jeans', 2200.00, 45, 'None', 'Classic denim jeans with perfect fit and durability.', 'https://via.placeholder.com/300x400?text=Denim+Jeans'),
('Polo Shirt', 'Shirt', 1100.00, 60, 'None', 'Classic polo shirt for casual and semi-formal occasions.', 'https://via.placeholder.com/300x400?text=Polo+Shirt'),
('Chino Pants', 'Pants', 1800.00, 40, 'None', 'Stylish chino pants for smart casual look.', 'https://via.placeholder.com/300x400?text=Chino+Pants'),
('Hoodie', 'Jacket', 2000.00, 35, 'None', 'Cozy hoodie for winter and casual outings.', 'https://via.placeholder.com/300x400?text=Hoodie'),
('Cargo Pants', 'Pants', 1900.00, 30, 'None', 'Functional cargo pants with multiple pockets.', 'https://via.placeholder.com/300x400?text=Cargo+Pants'),
('Henley Shirt', 'Shirt', 1200.00, 45, 'None', 'Trendy henley shirt for casual style.', 'https://via.placeholder.com/300x400?text=Henley+Shirt'),
('Track Pants', 'Pants', 1300.00, 55, 'None', 'Comfortable track pants for sports and leisure.', 'https://via.placeholder.com/300x400?text=Track+Pants'),
('Denim Jacket', 'Jacket', 2800.00, 25, 'None', 'Classic denim jacket for all seasons.', 'https://via.placeholder.com/300x400?text=Denim+Jacket'),

-- Accessories & Others (10 items)
('Pashmina Shawl', 'Accessories', 2500.00, 20, 'Hand Embroidered', 'Luxurious pashmina shawl with delicate embroidery.', 'https://via.placeholder.com/300x400?text=Shawl'),
('Silk Dupatta', 'Accessories', 800.00, 40, 'None', 'Elegant silk dupatta to complement any outfit.', 'https://via.placeholder.com/300x400?text=Dupatta'),
('Embroidered Stole', 'Accessories', 1200.00, 30, 'Machine Embroidered', 'Stylish embroidered stole for ethnic wear.', 'https://via.placeholder.com/300x400?text=Stole'),
('Designer Belt', 'Accessories', 600.00, 50, 'None', 'Premium leather belt with designer buckle.', 'https://via.placeholder.com/300x400?text=Belt'),
('Ethnic Jewelry Set', 'Accessories', 1500.00, 25, 'None', 'Beautiful ethnic jewelry set for traditional wear.', 'https://via.placeholder.com/300x400?text=Jewelry'),
('Embroidered Handbag', 'Accessories', 1800.00, 18, 'Hand Embroidered', 'Handcrafted embroidered handbag.', 'https://via.placeholder.com/300x400?text=Handbag'),
('Traditional Footwear', 'Footwear', 1200.00, 35, 'None', 'Comfortable traditional footwear for ethnic attire.', 'https://via.placeholder.com/300x400?text=Footwear'),
('Silk Scarf', 'Accessories', 700.00, 45, 'None', 'Smooth silk scarf in vibrant colors.', 'https://via.placeholder.com/300x400?text=Scarf'),
('Clutch Bag', 'Accessories', 1000.00, 28, 'Machine Embroidered', 'Elegant clutch bag for parties and events.', 'https://via.placeholder.com/300x400?text=Clutch'),
('Embroidered Cap', 'Accessories', 500.00, 60, 'Machine Embroidered', 'Traditional embroidered cap for men.', 'https://via.placeholder.com/300x400?text=Cap');

-- Sample Reviews
INSERT INTO Review (CustomerID, ProductID, Rating, Comment) VALUES
(1, 1, 5, 'Excellent quality saree! The embroidery work is amazing.'),
(2, 2, 4, 'Good product. Comfortable to wear.'),
(1, 5, 5, 'Absolutely beautiful! Worth every penny.');

-- Sample Ranking
INSERT INTO Ranking (CustomerID, ProductID, Quantity) VALUES
(1, 1, 5),
(1, 5, 5),
(2, 2, 4);

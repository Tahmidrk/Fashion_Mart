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

-- Sample Products
INSERT INTO Product (ProductName, Category, Price, Quantity, Demand, Rating, Embroidery, Description, ImageURL) VALUES
('Elegant Silk Saree', 'Saree', 4500.00, 25, 150, 4.5, 'Hand Embroidered', 'Beautiful silk saree with traditional hand embroidery work. Perfect for weddings and special occasions.', 'https://via.placeholder.com/300x400?text=Silk+Saree'),
('Cotton Punjabi', 'Men', 1800.00, 40, 200, 4.2, 'Machine Embroidered', 'Comfortable cotton punjabi for everyday wear with elegant machine embroidery.', 'https://via.placeholder.com/300x400?text=Cotton+Punjabi'),
('Designer Kurti', 'Women', 1200.00, 35, 180, 4.3, 'None', 'Modern designer kurti with vibrant colors and patterns.', 'https://via.placeholder.com/300x400?text=Designer+Kurti'),
('Formal Shirt', 'Men', 1500.00, 50, 220, 4.0, 'None', 'Premium quality formal shirt for office and business meetings.', 'https://via.placeholder.com/300x400?text=Formal+Shirt'),
('Embroidered Salwar Kameez', 'Women', 3200.00, 20, 120, 4.7, 'Hand Embroidered', 'Luxurious salwar kameez with intricate hand embroidery and fine fabric.', 'https://via.placeholder.com/300x400?text=Salwar+Kameez'),
('Casual T-Shirt', 'Men', 600.00, 100, 300, 3.9, 'None', 'Comfortable casual t-shirt available in multiple colors.', 'https://via.placeholder.com/300x400?text=T-Shirt'),
('Party Dress', 'Women', 2800.00, 15, 90, 4.6, 'Machine Embroidered', 'Stunning party dress with modern design and embroidery details.', 'https://via.placeholder.com/300x400?text=Party+Dress'),
('Denim Jeans', 'Men', 2200.00, 45, 250, 4.1, 'None', 'Classic denim jeans with perfect fit and durability.', 'https://via.placeholder.com/300x400?text=Denim+Jeans'),
('Traditional Lehenga', 'Women', 6500.00, 10, 60, 4.8, 'Hand Embroidered', 'Exquisite traditional lehenga with heavy embroidery work for weddings.', 'https://via.placeholder.com/300x400?text=Lehenga'),
('Polo Shirt', 'Men', 1100.00, 60, 180, 4.0, 'None', 'Classic polo shirt for casual and semi-formal occasions.', 'https://via.placeholder.com/300x400?text=Polo+Shirt');

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

-- Fashion Mart Database Migration
-- Adds Payment and Delivery Features without dropping existing data
-- Safe to run multiple times (uses IF NOT EXISTS)

USE fashion_mart;

-- Create DeliveryMan table if it doesn't exist
CREATE TABLE IF NOT EXISTS DeliveryMan (
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

-- Add new columns to Order table if they don't exist
ALTER TABLE `Order` 
ADD COLUMN IF NOT EXISTS DeliveryManID INT,
ADD COLUMN IF NOT EXISTS PaymentMethod VARCHAR(50) DEFAULT 'Cash on Delivery',
ADD COLUMN IF NOT EXISTS PaymentStatus VARCHAR(20) DEFAULT 'Pending',
ADD COLUMN IF NOT EXISTS DeliveryAddress TEXT;

-- Add foreign key constraint if it doesn't exist
-- Check if the constraint already exists before adding
SET @constraint_exists = (
    SELECT COUNT(*)
    FROM information_schema.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = 'fashion_mart'
    AND TABLE_NAME = 'Order'
    AND CONSTRAINT_NAME = 'fk_order_deliveryman'
);

SET @sql = IF(@constraint_exists = 0,
    'ALTER TABLE `Order` ADD CONSTRAINT fk_order_deliveryman FOREIGN KEY (DeliveryManID) REFERENCES DeliveryMan(DeliveryManID) ON DELETE SET NULL',
    'SELECT "Foreign key constraint already exists" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Insert sample delivery men only if they don't exist
INSERT IGNORE INTO DeliveryMan (Username, Password, Name, Email, Phone, Address, VehicleType, Status) 
VALUES
('delivery1', 'delivery123', 'Karim Rahman', 'karim@delivery.com', '01712345670', 'Mirpur, Dhaka', 'Motorcycle', 'Active'),
('delivery2', 'delivery123', 'Rahim Ahmed', 'rahim@delivery.com', '01812345671', 'Uttara, Dhaka', 'Motorcycle', 'Active'),
('delivery3', 'delivery123', 'Salam Mia', 'salam@delivery.com', '01912345672', 'Mohammadpur, Dhaka', 'Bicycle', 'Active');

-- Update existing orders to have default payment information (only if columns are NULL)
UPDATE `Order` 
SET PaymentMethod = 'Cash on Delivery' 
WHERE PaymentMethod IS NULL;

UPDATE `Order` 
SET PaymentStatus = 'Pending' 
WHERE PaymentStatus IS NULL;

SELECT 'Migration completed successfully! All existing data preserved.' AS Status;

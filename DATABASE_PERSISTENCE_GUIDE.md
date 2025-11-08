# 🔒 Database Persistence & Account Safety Guide

## ✅ Your Accounts Are SAFE and PERMANENT

**All accounts you create will remain in the database FOREVER** - they won't be deleted when you update the project!

---

## 🛡️ How Your Data is Protected

### 1. **Separate Schema vs Migration Files**

We have two different database files:

#### `database/schema.sql` - **INITIAL SETUP ONLY**
- Used **ONLY ONCE** when first creating database
- Contains table structures + sample data
- **NEVER run this again** or it will reset everything!

#### `database/migration_add_payment_delivery.sql` - **SAFE UPDATES**
- Used for **ADDING new features** to existing database
- Uses `ALTER TABLE` commands (safe)
- **Preserves all existing data**
- Can be run multiple times safely

---

## 📊 Current Database Contents

Your database has these accounts **right now**:

### Customers (in `Customer` table):
```sql
1. john_doe      / password123
2. jane_smith    / password123
3. guest_user    / password123
+ Any accounts YOU created yourself
```

### Delivery Personnel (in `DeliveryMan` table):
```sql
1. delivery1     / delivery123
2. delivery2     / delivery123
3. delivery3     / delivery123
```

### Admin (in `Admin` table):
```sql
1. admin         / admin123
```

**ALL of these will persist permanently!**

---

## ⚠️ CRITICAL RULES - Never Lose Data

### ✅ DO THIS (Safe):
1. **Use migration files** for updates:
   ```bash
   mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/migration_add_payment_delivery.sql
   ```

2. **Backup before changes**:
   ```bash
   cd database
   ./backup.sh
   ```

3. **Add new features** using `ALTER TABLE`:
   ```sql
   ALTER TABLE Customer ADD COLUMN Phone VARCHAR(20);
   ```

4. **Update app.py** - code changes are always safe!

5. **Update templates** - template changes are always safe!

### ❌ NEVER DO THIS (Data Loss):
1. **DON'T run schema.sql again**:
   ```bash
   # ❌ This will DELETE all your accounts!
   mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/schema.sql
   ```

2. **DON'T use DROP TABLE**:
   ```sql
   -- ❌ This deletes everything!
   DROP TABLE Customer;
   ```

3. **DON'T delete the database**:
   ```sql
   -- ❌ This removes the entire database!
   DROP DATABASE fashion_mart;
   ```

---

## 🔄 How to Update Your Project Safely

### Scenario 1: Adding New Features
```bash
# Step 1: Create migration file
nano database/migration_new_feature.sql

# Step 2: Add safe ALTER commands
ALTER TABLE Product ADD COLUMN Rating DECIMAL(2,1);
ALTER TABLE Order ADD COLUMN Notes TEXT;

# Step 3: Backup first
cd database && ./backup.sh

# Step 4: Apply migration
mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/migration_new_feature.sql

# Step 5: Update app.py code to use new columns
```

**Result**: New features added, ALL existing accounts preserved! ✅

### Scenario 2: Updating Code (app.py or templates)
```bash
# Just edit and restart - data is NEVER affected!
pkill -f "python app.py"
cd "/home/tahmid/Documents/Fashion mart"
source venv/bin/activate
python app.py
```

**Result**: Code updated, ALL data completely safe! ✅

---

## 🔍 How to Check Your Accounts

### View all customers:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT CustomerID, Username, Name, Email FROM Customer;"
```

### View all orders:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT OrderID, CustomerID, TotalAmount, OrderStatus FROM \`Order\`;"
```

### View all products:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT ProductID, ProductName, Price, StockQuantity FROM Product;"
```

---

## 💾 Backup System

### Automatic Backups:
```bash
cd "/home/tahmid/Documents/Fashion mart/database"
./backup.sh
```

**Creates**:
- `backups/fashion_mart_YYYY-MM-DD_HH-MM-SS.sql`

### Restore from Backup:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/backups/fashion_mart_2025-11-09_14-30-00.sql
```

---

## 🎯 Your Account Creation Workflow

### When Customer Registers:

1. User fills registration form at `/register`
2. Flask app runs this code:
   ```python
   cursor.execute("""
       INSERT INTO Customer (Username, Password, Name, Email, Address)
       VALUES (%s, %s, %s, %s, %s)
   """, (username, hashed_password, name, email, address))
   db.commit()
   ```
3. **Data is written to MySQL database file on disk**
4. **Data persists FOREVER** - survives:
   - Server restarts ✅
   - Code updates ✅
   - Template changes ✅
   - System reboots ✅

### Where Data Lives:
```
MySQL Database File (on disk):
/var/lib/mysql/fashion_mart/

Tables:
├── Customer.ibd        (Customer accounts - PERMANENT)
├── Order.ibd          (All orders - PERMANENT)
├── Product.ibd        (Products - PERMANENT)
├── DeliveryMan.ibd    (Delivery accounts - PERMANENT)
└── Admin.ibd          (Admin accounts - PERMANENT)
```

**These files are PERMANENT storage** - your data is saved!

---

## 🔧 Fix: Login Username Auto-fill Issue

The "admin" showing up is likely browser autofill from when you tested admin login.

### Solution 1: Clear Browser Autofill
```
Chrome/Edge:
1. Click username field
2. See suggestions dropdown
3. Hover over "admin"
4. Press Shift + Delete

Firefox:
1. Click username field
2. See suggestions dropdown
3. Select "admin"
4. Press Delete
```

### Solution 2: Disable Autofill in Login Form
I can update the login form to prevent autofill:

```html
<input type="text" 
       id="username" 
       name="username" 
       autocomplete="off"
       placeholder="Enter your username"
       required>
```

Would you like me to apply this fix?

---

## 📋 Account Persistence Checklist

✅ **Database is on disk** (not in memory)  
✅ **Backups are available** (use `backup.sh`)  
✅ **Migration system exists** (safe updates)  
✅ **Schema file is separate** (won't run again)  
✅ **Data survives restarts**  
✅ **Data survives code updates**  

---

## 🎓 Golden Rules

1. **NEVER run `schema.sql` again** after initial setup
2. **ALWAYS use migrations** for database changes
3. **ALWAYS backup** before making changes
4. **Test on backup** before applying to production
5. **Code/template changes** never affect data

---

## 🚀 Example: Adding a New Feature

Let's say you want to add a "Wishlist" feature:

### Step 1: Create Migration
```sql
-- database/migration_wishlist.sql
CREATE TABLE IF NOT EXISTS Wishlist (
    WishlistID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    AddedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
```

### Step 2: Backup
```bash
cd database && ./backup.sh
```

### Step 3: Apply Migration
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/migration_wishlist.sql
```

### Step 4: Update app.py
```python
@app.route('/wishlist/add/<int:product_id>')
def add_to_wishlist(product_id):
    # New code here
    pass
```

### Result:
- ✅ New Wishlist feature added
- ✅ ALL existing customers preserved
- ✅ ALL existing orders preserved
- ✅ ALL existing products preserved
- ✅ Nothing lost!

---

## 🔐 Your Data is SAFE!

**Summary**: Once you create an account (customer, delivery, or admin), it lives in the MySQL database files on disk and will **NEVER be deleted** unless you:
- Manually delete it
- Run `DROP TABLE` commands
- Re-run `schema.sql` (which you should NEVER do)

**Your accounts and data are PERMANENT!** 🎉

---

## Need Help?

If you ever accidentally lose data:
1. Check `database/backups/` folder
2. Find most recent backup
3. Restore using:
   ```bash
   mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/backups/your_backup.sql
   ```

**Your data is protected!** 💪

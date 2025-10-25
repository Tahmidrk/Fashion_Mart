# 🚀 Quick Start Guide - Fashion Mart

## ⚡ Fast Setup (5 minutes)

### Step 1: Setup MySQL Database
```bash
# Login to MySQL
mysql -u root -p

# The password prompt will appear, enter your MySQL root password
# Then run:
source database/schema.sql

# Or if that doesn't work:
exit
mysql -u root -p < database/schema.sql
```

### Step 2: Configure Application
Edit `app.py` line 17-23 and update your MySQL password:
```python
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'passwd': 'YOUR_MYSQL_PASSWORD_HERE',  # ← Change this!
    'db': 'fashion_mart',
    'charset': 'utf8mb4'
}
```

### Step 3: Install Dependencies

**Option A: Using Setup Script (Recommended)**
```bash
# Linux/Mac
./setup.sh

# Windows
setup.bat
```

**Option B: Manual Installation**
```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate  # Linux/Mac
# OR
venv\Scripts\activate  # Windows

# Install packages
pip install -r requirements.txt
```

### Step 4: Run Application
```bash
# Make sure virtual environment is activated
python app.py
```

### Step 5: Open Browser
Visit: **http://localhost:5000**

---

## 🎉 You're Ready!

### Test Login Credentials
- **Username**: `john_doe`
- **Password**: `password123`

Or create a new account using the Register page.

### What to Try First:
1. ✅ Browse products at `/products`
2. ✅ Click on a product to see details
3. ✅ Add products to cart
4. ✅ Checkout and place an order
5. ✅ View your orders at `/orders`

---

## 🔧 Troubleshooting

### "Import Error: No module named 'MySQLdb'"
```bash
# Ubuntu/Debian
sudo apt-get install python3-dev default-libmysqlclient-dev build-essential
pip install mysqlclient

# macOS
brew install mysql
pip install mysqlclient

# Windows
pip install mysqlclient
# If that fails, download wheel from: https://www.lfd.uci.edu/~gohlke/pythonlibs/#mysqlclient
```

### "Can't connect to MySQL server"
- ✅ Ensure MySQL is running: `sudo systemctl start mysql` (Linux)
- ✅ Check credentials in `app.py`
- ✅ Verify database exists: `SHOW DATABASES;` in MySQL

### "Port 5000 already in use"
Edit `app.py` last line:
```python
app.run(debug=True, host='0.0.0.0', port=5001)  # Changed to 5001
```

---

## 📱 Features Implemented

### ✅ Product View
- Browse all products
- Search by name
- Filter by category
- View product details
- See customer reviews
- Check stock availability

### ✅ Order Management
- Add to cart
- Update quantities
- Remove items
- Checkout
- Order confirmation
- View order history
- Track order status

---

## 🎯 What's Next?

The following features are ready in the database but not yet implemented in the UI:
- Payment processing
- Admin dashboard
- Review submission
- Reward points redemption
- Product ranking

You can implement these based on your requirements!

---

**Need Help?** Check the full README.md for detailed documentation.

**Happy Shopping! 🛍️**

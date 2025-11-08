# 🔐 Fashion Mart - Complete Login System Guide

## Three Separate Login Interfaces

Your Fashion Mart now has **3 independent login systems**, each with its own dashboard and permissions:

---

## 1. 👤 **CUSTOMER LOGIN**

**URL:** http://localhost:5000/login

**Purpose:** Shopping, ordering, reviewing products

**Test Account:**
- Username: `john_doe`
- Password: `password123`

**Features:**
- Browse products
- Add to cart
- Checkout with payment method selection
- View order history
- Write product reviews
- View profile

**After Login:** Redirected to home page with full shopping access

---

## 2. 🚚 **DELIVERY MAN LOGIN**

**URL:** http://localhost:5000/delivery/login

**Purpose:** Manage deliveries and confirm payments

**Test Accounts:**
- Username: `delivery1`, Password: `delivery123`
- Username: `delivery2`, Password: `delivery123`
- Username: `delivery3`, Password: `delivery123`

**Features:**
- View assigned orders ONLY
- See customer delivery addresses
- Mark orders as delivered
- Confirm cash payment received (for COD)
- Track delivery history

**Restrictions:**
- ❌ Cannot see other delivery men's orders
- ❌ Cannot add/edit products
- ❌ Cannot manage customers
- ❌ Cannot assign orders to themselves

**After Login:** Redirected to delivery dashboard

---

## 3. 🎯 **ADMIN LOGIN**

**URL:** http://localhost:5000/admin/login

**Purpose:** Complete system management and control

**Test Account:**
- Username: `admin`
- Password: `admin123`

### Admin Dashboard Features:

#### 📊 **Dashboard Overview** (`/admin/dashboard`)
- Total customers count
- Total products count  
- Total orders count
- Active delivery personnel
- Total revenue from completed orders
- Recent orders summary
- Quick action buttons

#### 👥 **Customer Management** (`/admin/customers`)
- View all registered customers
- See customer order history
- Total spent by each customer
- Customer contact information
- Registration dates

#### 📦 **Product Management** (`/admin/products`)
- **Add New Products:**
  - Product name, category, price
  - Stock quantity
  - Description and image URL
  - Embroidery type
  
- **Edit Existing Products:**
  - Update any product details
  - Adjust pricing and inventory
  - Change product images
  
- **Delete Products:**
  - Remove products from catalog
  - (Cascade deletion handled safely)

#### 📋 **Order Management** (`/admin/orders`)
- View ALL orders from all customers
- Assign orders to delivery personnel
- See payment status and method
- Track order status (Pending/Delivered/Complete)
- View customer delivery addresses
- Monitor order timeline

#### 🚚 **Delivery Personnel Management** (`/admin/delivery`)
- View all delivery staff
- See delivery statistics:
  - Total deliveries assigned
  - Completed deliveries
  - Active status
- Track performance metrics

**After Login:** Redirected to admin dashboard with full control

---

## 🔒 Security & Session Management

### Separate Sessions:
Each login type uses different session keys:
- **Customer:** `customer_id`, `customer_name`
- **Delivery:** `delivery_man_id`, `delivery_man_name`, `user_type='delivery'`
- **Admin:** `admin_id`, `admin_name`, `admin_role`, `user_type='admin'`

### Access Control:
- Routes check for appropriate session before access
- Unauthorized access redirects to respective login page
- Each role can only access their permitted features

---

## 📱 Quick Access Links

### Customer Portal:
```
Login:    http://localhost:5000/login
Home:     http://localhost:5000/
Products: http://localhost:5000/products
Cart:     http://localhost:5000/cart
Orders:   http://localhost:5000/orders
```

### Delivery Portal:
```
Login:     http://localhost:5000/delivery/login
Dashboard: http://localhost:5000/delivery/dashboard
Logout:    http://localhost:5000/delivery/logout
```

### Admin Portal:
```
Login:      http://localhost:5000/admin/login
Dashboard:  http://localhost:5000/admin/dashboard
Customers:  http://localhost:5000/admin/customers
Products:   http://localhost:5000/admin/products
Orders:     http://localhost:5000/admin/orders
Delivery:   http://localhost:5000/admin/delivery
Logout:     http://localhost:5000/admin/logout
```

---

## 🎯 Permission Matrix

| Feature | Customer | Delivery Man | Admin |
|---------|----------|--------------|-------|
| Browse Products | ✅ | ❌ | ✅ |
| Place Orders | ✅ | ❌ | ✅ |
| Write Reviews | ✅ | ❌ | ❌ |
| View Own Orders | ✅ | ❌ | ❌ |
| View Assigned Orders | ❌ | ✅ | ✅ |
| Mark as Delivered | ❌ | ✅ | ❌ |
| Confirm Payment | ❌ | ✅ (own orders) | ❌ |
| View All Orders | ❌ | ❌ | ✅ |
| Assign Orders | ❌ | ❌ | ✅ |
| Add/Edit Products | ❌ | ❌ | ✅ |
| Delete Products | ❌ | ❌ | ✅ |
| View All Customers | ❌ | ❌ | ✅ |
| Manage Delivery Staff | ❌ | ❌ | ✅ |
| View Revenue Stats | ❌ | ❌ | ✅ |

---

## 🚀 Complete Workflow Example

### Scenario: Complete Order Process

1. **Customer** (`john_doe`) logs in at `/login`
   - Browses products
   - Adds items to cart
   - Proceeds to checkout
   - Selects "Cash on Delivery"
   - Places order

2. **Admin** (`admin`) logs in at `/admin/login`
   - Views new order in `/admin/orders`
   - Assigns order to delivery man "Karim Rahman"

3. **Delivery Man** (`delivery1`) logs in at `/delivery/login`
   - Sees assigned order in dashboard
   - Views customer address
   - Delivers product
   - Clicks "Mark as Delivered"
   - Customer pays cash
   - Clicks "Confirm Cash Received"
   - Order status automatically becomes "Complete"

---

## 📊 Database Tables

- **Admin:** Stores admin accounts
- **Customer:** Stores customer accounts
- **DeliveryMan:** Stores delivery personnel
- **Product:** Product catalog
- **Order:** All orders with payment & delivery info
- **Review:** Customer product reviews

---

## 🔑 All Login Credentials

### Customers:
```
john_doe / password123
jane_smith / password123
guest_user / password123
```

### Delivery Men:
```
delivery1 / delivery123
delivery2 / delivery123
delivery3 / delivery123
```

### Admin:
```
admin / admin123
```

---

## 💡 Key Features

✅ **Complete Separation:** Each role has its own login page and dashboard  
✅ **Role-Based Access:** Strict permissions based on user type  
✅ **Secure Sessions:** Separate session management for each role  
✅ **Admin Full Control:** Complete system management capabilities  
✅ **Delivery Restricted Access:** Only assigned orders visible  
✅ **Customer Shopping Experience:** Full e-commerce functionality  

---

**Your multi-role authentication system is now live and working!** 🎉

Each interface is completely independent and secure!

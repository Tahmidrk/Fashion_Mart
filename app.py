from flask import Flask, render_template, request, jsonify, session, redirect, url_for
from flask_cors import CORS
import MySQLdb
from datetime import datetime
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
CORS(app)

# Database configuration
DB_CONFIG = {
    'host': os.getenv('MYSQL_HOST', 'localhost'),
    'user': os.getenv('MYSQL_USER', 'fashion_user'),
    'passwd': os.getenv('MYSQL_PASSWORD', 'fashion_pass_2024'),
    'db': os.getenv('MYSQL_DB', 'fashion_mart'),
    'charset': 'utf8mb4'
}

def get_db():
    """Get database connection"""
    return MySQLdb.connect(**DB_CONFIG)

# =====================================================
# HOME ROUTES
# =====================================================

@app.route('/')
def index():
    """Homepage"""
    return render_template('index.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    """Customer registration"""
    if request.method == 'POST':
        data = request.form
        try:
            db = get_db()
            cursor = db.cursor()
            
            cursor.execute("""
                INSERT INTO Customer (Username, Password, Name, Email, Number, Road, Area, City, District)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                data['username'], data['password'], data['name'], data['email'],
                data.get('number', ''), data.get('road', ''), data.get('area', ''),
                data.get('city', ''), data.get('district', '')
            ))
            
            db.commit()
            cursor.close()
            db.close()
            
            return redirect(url_for('login'))
        except Exception as e:
            return jsonify({'error': str(e)}), 400
    
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Customer login"""
    if request.method == 'POST':
        data = request.form
        try:
            db = get_db()
            cursor = db.cursor(MySQLdb.cursors.DictCursor)
            
            cursor.execute("""
                SELECT * FROM Customer WHERE Username = %s AND Password = %s
            """, (data['username'], data['password']))
            
            user = cursor.fetchone()
            cursor.close()
            db.close()
            
            if user:
                session['customer_id'] = user['CustomerID']
                session['username'] = user['Username']
                session['name'] = user['Name']
                return redirect(url_for('products'))
            else:
                return render_template('login.html', error='Invalid credentials')
                
        except Exception as e:
            return jsonify({'error': str(e)}), 400
    
    return render_template('login.html')

@app.route('/logout')
def logout():
    """Logout"""
    session.clear()
    return redirect(url_for('index'))

# =====================================================
# PRODUCT ROUTES
# =====================================================

@app.route('/products')
def products():
    """Display all products"""
    category = request.args.get('category', '')
    search = request.args.get('search', '')
    
    try:
        db = get_db()
        cursor = db.cursor(MySQLdb.cursors.DictCursor)
        
        # Build query based on filters
        query = "SELECT * FROM Product WHERE 1=1"
        params = []
        
        if category:
            query += " AND Category = %s"
            params.append(category)
        
        if search:
            query += " AND ProductName LIKE %s"
            params.append(f'%{search}%')
        
        query += " ORDER BY ProductName"
        
        cursor.execute(query, params)
        products = cursor.fetchall()
        
        # Get all categories for filter
        cursor.execute("SELECT DISTINCT Category FROM Product ORDER BY Category")
        categories = [row['Category'] for row in cursor.fetchall()]
        
        cursor.close()
        db.close()
        
        return render_template('products.html', 
                             products=products, 
                             categories=categories,
                             selected_category=category,
                             search_term=search)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/product/<int:product_id>')
def product_detail(product_id):
    """Display product details"""
    try:
        db = get_db()
        cursor = db.cursor(MySQLdb.cursors.DictCursor)
        
        # Get product details
        cursor.execute("SELECT * FROM Product WHERE ProductID = %s", (product_id,))
        product = cursor.fetchone()
        
        if not product:
            cursor.close()
            db.close()
            return "Product not found", 404
        
        # Get product reviews
        cursor.execute("""
            SELECT r.*, c.Name as CustomerName, c.Username
            FROM Review r
            JOIN Customer c ON r.CustomerID = c.CustomerID
            WHERE r.ProductID = %s
            ORDER BY r.ReviewDate DESC
        """, (product_id,))
        reviews = cursor.fetchall()
        
        cursor.close()
        db.close()
        
        return render_template('product_detail.html', product=product, reviews=reviews)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/products')
def api_products():
    """API endpoint for products"""
    try:
        db = get_db()
        cursor = db.cursor(MySQLdb.cursors.DictCursor)
        
        cursor.execute("SELECT * FROM Product ORDER BY ProductName")
        products = cursor.fetchall()
        
        cursor.close()
        db.close()
        
        # Convert Decimal to float for JSON serialization
        for product in products:
            product['Price'] = float(product['Price'])
            product['Rating'] = float(product['Rating'])
        
        return jsonify(products)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# =====================================================
# ORDER ROUTES
# =====================================================

@app.route('/cart')
def cart():
    """Display shopping cart"""
    if 'customer_id' not in session:
        return redirect(url_for('login'))
    
    return render_template('cart.html')

@app.route('/api/cart/add', methods=['POST'])
def add_to_cart():
    """Add item to cart (stored in session)"""
    if 'customer_id' not in session:
        return jsonify({'error': 'Please login first'}), 401
    
    data = request.json
    product_id = data.get('product_id')
    quantity = data.get('quantity', 1)
    
    try:
        db = get_db()
        cursor = db.cursor(MySQLdb.cursors.DictCursor)
        
        # Get product details
        cursor.execute("SELECT * FROM Product WHERE ProductID = %s", (product_id,))
        product = cursor.fetchone()
        
        cursor.close()
        db.close()
        
        if not product:
            return jsonify({'error': 'Product not found'}), 404
        
        if product['Quantity'] < quantity:
            return jsonify({'error': 'Insufficient stock'}), 400
        
        # Initialize cart in session if not exists
        if 'cart' not in session:
            session['cart'] = {}
        
        # Add or update cart item
        cart = session['cart']
        product_id_str = str(product_id)
        
        if product_id_str in cart:
            cart[product_id_str]['quantity'] += quantity
        else:
            cart[product_id_str] = {
                'product_id': product_id,
                'name': product['ProductName'],
                'price': float(product['Price']),
                'quantity': quantity,
                'image': product['ImageURL']
            }
        
        session['cart'] = cart
        session.modified = True
        
        return jsonify({'success': True, 'cart_count': len(cart)})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/cart/get')
def get_cart():
    """Get cart items"""
    if 'customer_id' not in session:
        return jsonify({'error': 'Please login first'}), 401
    
    cart = session.get('cart', {})
    return jsonify(cart)

@app.route('/api/cart/update', methods=['POST'])
def update_cart():
    """Update cart item quantity"""
    if 'customer_id' not in session:
        return jsonify({'error': 'Please login first'}), 401
    
    data = request.json
    product_id = str(data.get('product_id'))
    quantity = data.get('quantity', 1)
    
    cart = session.get('cart', {})
    
    if product_id in cart:
        if quantity <= 0:
            del cart[product_id]
        else:
            cart[product_id]['quantity'] = quantity
        
        session['cart'] = cart
        session.modified = True
        
        return jsonify({'success': True})
    
    return jsonify({'error': 'Item not in cart'}), 404

@app.route('/api/cart/remove', methods=['POST'])
def remove_from_cart():
    """Remove item from cart"""
    if 'customer_id' not in session:
        return jsonify({'error': 'Please login first'}), 401
    
    data = request.json
    product_id = str(data.get('product_id'))
    
    cart = session.get('cart', {})
    
    if product_id in cart:
        del cart[product_id]
        session['cart'] = cart
        session.modified = True
        return jsonify({'success': True})
    
    return jsonify({'error': 'Item not in cart'}), 404

@app.route('/checkout')
def checkout():
    """Checkout page"""
    if 'customer_id' not in session:
        return redirect(url_for('login'))
    
    cart = session.get('cart', {})
    if not cart:
        return redirect(url_for('products'))
    
    return render_template('checkout.html')

@app.route('/api/order/create', methods=['POST'])
def create_order():
    """Create a new order"""
    if 'customer_id' not in session:
        return jsonify({'error': 'Please login first'}), 401
    
    cart = session.get('cart', {})
    if not cart:
        return jsonify({'error': 'Cart is empty'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Calculate total amount
        cart_items = list(cart.values())
        total_amount = sum(float(item['price']) * int(item['quantity']) for item in cart_items)
        
        # Create order
        cursor.execute("""
            INSERT INTO `Order` (CustomerID, TotalAmount, OrderStatus)
            VALUES (%s, %s, 'Pending')
        """, (session['customer_id'], total_amount))
        
        order_id = cursor.lastrowid
        
        # Create order items
        for item in cart_items:
            cursor.execute("""
                INSERT INTO OrderItem (OrderID, ProductID, Quantity, Price)
                VALUES (%s, %s, %s, %s)
            """, (order_id, item['product_id'], item['quantity'], item['price']))
            
            # Update product quantity
            cursor.execute("""
                UPDATE Product 
                SET Quantity = Quantity - %s, Demand = Demand + %s
                WHERE ProductID = %s
            """, (item['quantity'], item['quantity'], item['product_id']))
        
        # Create delivery record
        cursor.execute("""
            INSERT INTO Delivery (OrderID, DeliveryStatus)
            VALUES (%s, 'Pending')
        """, (order_id,))
        
        db.commit()
        cursor.close()
        db.close()
        
        # Clear cart
        session['cart'] = {}
        session.modified = True
        
        return jsonify({
            'success': True, 
            'order_id': order_id,
            'total_amount': float(total_amount)
        })
    except Exception as e:
        if db:
            db.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/orders')
def my_orders():
    """Display customer orders"""
    if 'customer_id' not in session:
        return redirect(url_for('login'))
    
    try:
        db = get_db()
        cursor = db.cursor(MySQLdb.cursors.DictCursor)
        
        # Get customer orders
        cursor.execute("""
            SELECT o.*, d.DeliveryStatus, d.DeliveryDate
            FROM `Order` o
            LEFT JOIN Delivery d ON o.OrderID = d.OrderID
            WHERE o.CustomerID = %s
            ORDER BY o.OrderDate DESC
        """, (session['customer_id'],))
        
        orders = list(cursor.fetchall())
        
        # Get order items for each order
        for order in orders:
            cursor.execute("""
                SELECT oi.*, p.ProductName, p.ImageURL
                FROM OrderItem oi
                JOIN Product p ON oi.ProductID = p.ProductID
                WHERE oi.OrderID = %s
            """, (order['OrderID'],))
            order['order_items'] = list(cursor.fetchall())
        
        cursor.close()
        db.close()
        
        return render_template('orders.html', orders=orders)
    except Exception as e:
        print(f"Error in my_orders: {e}")
        import traceback
        traceback.print_exc()
        return f"<h1>Error</h1><p>{str(e)}</p>", 500

@app.route('/order/confirmation/<int:order_id>')
def order_confirmation(order_id):
    """Display order confirmation receipt"""
    if 'customer_id' not in session:
        return redirect(url_for('login'))
    
    try:
        db = get_db()
        cursor = db.cursor(MySQLdb.cursors.DictCursor)
        
        # Get order details
        cursor.execute("""
            SELECT o.*, d.DeliveryStatus, d.DeliveryDate
            FROM `Order` o
            LEFT JOIN Delivery d ON o.OrderID = d.OrderID
            WHERE o.OrderID = %s AND o.CustomerID = %s
        """, (order_id, session['customer_id']))
        
        order = cursor.fetchone()
        
        if not order:
            return redirect(url_for('my_orders'))
        
        # Get order items
        cursor.execute("""
            SELECT oi.*, p.ProductName, p.ImageURL
            FROM OrderItem oi
            JOIN Product p ON oi.ProductID = p.ProductID
            WHERE oi.OrderID = %s
        """, (order_id,))
        
        order['order_items'] = list(cursor.fetchall())
        
        # Get customer details
        cursor.execute("""
            SELECT * FROM Customer WHERE CustomerID = %s
        """, (session['customer_id'],))
        
        customer = cursor.fetchone()
        
        cursor.close()
        db.close()
        
        return render_template('order_confirmation.html', order=order, customer=customer)
    except Exception as e:
        print(f"Error in order_confirmation: {e}")
        return redirect(url_for('my_orders'))

@app.route('/order/<int:order_id>')
def order_detail(order_id):
    """Display order details"""
    if 'customer_id' not in session:
        return redirect(url_for('login'))
    
    try:
        db = get_db()
        cursor = db.cursor(MySQLdb.cursors.DictCursor)
        
        # Get order details
        cursor.execute("""
            SELECT o.*, d.DeliveryStatus, d.DeliveryDate, c.Name, c.Email, c.Number,
                   c.Road, c.Area, c.City, c.District
            FROM `Order` o
            LEFT JOIN Delivery d ON o.OrderID = d.OrderID
            JOIN Customer c ON o.CustomerID = c.CustomerID
            WHERE o.OrderID = %s AND o.CustomerID = %s
        """, (order_id, session['customer_id']))
        
        order = cursor.fetchone()
        
        if not order:
            cursor.close()
            db.close()
            return "Order not found", 404
        
        # Get order items
        cursor.execute("""
            SELECT oi.*, p.ProductName, p.ImageURL, p.Category
            FROM OrderItem oi
            JOIN Product p ON oi.ProductID = p.ProductID
            WHERE oi.OrderID = %s
        """, (order_id,))
        
        order['order_items'] = list(cursor.fetchall())
        
        cursor.close()
        db.close()
        
        return render_template('order_detail.html', order=order)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# =====================================================
# RUN APPLICATION
# =====================================================

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

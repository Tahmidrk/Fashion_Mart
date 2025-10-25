#!/bin/bash

# Fashion Mart - Quick Run Script

echo "======================================"
echo "  Fashion Mart - Quick Run Script"
echo "======================================"
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create virtual environment"
        exit 1
    fi
    echo "✅ Virtual environment created"
    echo ""
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Check if packages are installed
if ! python -c "import flask" 2>/dev/null; then
    echo "📚 Installing dependencies..."
    pip install -q --upgrade pip
    pip install -q -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install dependencies"
        exit 1
    fi
    echo "✅ Dependencies installed"
    echo ""
fi

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    echo "⚠️  WARNING: MySQL is not installed!"
    echo ""
    echo "To install MySQL on Ubuntu/Debian:"
    echo "  sudo apt update"
    echo "  sudo apt install mysql-server"
    echo "  sudo systemctl start mysql"
    echo ""
    echo "After installing MySQL:"
    echo "  1. Setup database: mysql -u root -p < database/schema.sql"
    echo "  2. Update password in app.py (line 19)"
    echo "  3. Run this script again"
    echo ""
    exit 1
fi

# Check if database exists
echo "🔍 Checking database..."
DB_EXISTS=$(mysql -u root -e "SHOW DATABASES LIKE 'fashion_mart';" 2>/dev/null | grep fashion_mart)

if [ -z "$DB_EXISTS" ]; then
    echo "⚠️  Database 'fashion_mart' not found!"
    echo ""
    echo "Please setup the database first:"
    echo "  mysql -u root -p < database/schema.sql"
    echo ""
    read -p "Do you want to setup the database now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Setting up database..."
        mysql -u root -p < database/schema.sql
        if [ $? -eq 0 ]; then
            echo "✅ Database setup complete!"
        else
            echo "❌ Database setup failed!"
            exit 1
        fi
    else
        echo "Please setup the database manually and run this script again."
        exit 1
    fi
fi

echo "✅ Database ready"
echo ""

# Check if password is configured
if grep -q "your_password" app.py; then
    echo "⚠️  WARNING: Please update MySQL password in app.py!"
    echo ""
    echo "Edit app.py (line 19) and change 'your_password' to your MySQL password"
    echo ""
    read -p "Press Enter after updating the password..."
fi

echo ""
echo "======================================"
echo "🚀 Starting Fashion Mart Application"
echo "======================================"
echo ""
echo "📱 Application will run at: http://localhost:5000"
echo ""
echo "🎮 Test Login:"
echo "   Username: john_doe"
echo "   Password: password123"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Run the application
python app.py

#!/usr/bin/env python3
"""
Quick database connection test and setup for Fashion Mart
"""
import subprocess
import sys

def test_connection():
    """Test database connection"""
    print("Testing database connection...")
    try:
        import MySQLdb
        
        # Try connecting without password (default Ubuntu MySQL setup)
        try:
            conn = MySQLdb.connect(
                host='localhost',
                user='root',
                passwd='',
                db='fashion_mart',
                charset='utf8mb4'
            )
            conn.close()
            print("✅ Database connection successful (no password)")
            return True, ''
        except MySQLdb.Error as e:
            print(f"❌ Connection without password failed: {e}")
            
            # Try with sudo (Unix socket authentication)
            try:
                result = subprocess.run(
                    ['sudo', 'mysql', '-e', 'SELECT 1 FROM fashion_mart.Product LIMIT 1;'],
                    capture_output=True,
                    text=True
                )
                if result.returncode == 0:
                    print("✅ Database accessible via sudo (socket authentication)")
                    print("\nℹ️  MySQL is using socket authentication.")
                    print("   The application will need to run with appropriate permissions.")
                    return True, 'socket'
            except Exception as e2:
                print(f"❌ Socket authentication also failed: {e2}")
                
            return False, str(e)
    except ImportError as e:
        print(f"❌ MySQLdb module not found: {e}")
        return False, "MySQLdb not installed"

def create_mysql_user():
    """Create a MySQL user with password for the application"""
    print("\n" + "="*60)
    print("Setting up MySQL user for Fashion Mart...")
    print("="*60)
    
    sql_commands = """
    -- Create user if not exists
    CREATE USER IF NOT EXISTS 'fashion_user'@'localhost' IDENTIFIED BY 'fashion_pass_2024';
    
    -- Grant all privileges on fashion_mart database
    GRANT ALL PRIVILEGES ON fashion_mart.* TO 'fashion_user'@'localhost';
    
    -- Flush privileges
    FLUSH PRIVILEGES;
    
    -- Test the user
    SELECT 'User created successfully' AS status;
    """
    
    try:
        # Write SQL to temporary file
        with open('/tmp/setup_user.sql', 'w') as f:
            f.write(sql_commands)
        
        # Execute SQL
        result = subprocess.run(
            ['sudo', 'mysql', '<', '/tmp/setup_user.sql'],
            shell=True,
            capture_output=True,
            text=True
        )
        
        if result.returncode == 0:
            print("✅ MySQL user created successfully!")
            print("\nUser credentials:")
            print("   Username: fashion_user")
            print("   Password: fashion_pass_2024")
            print("   Database: fashion_mart")
            return True
        else:
            print(f"❌ Failed to create user: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def update_app_config():
    """Update app.py with the new credentials"""
    print("\nUpdating app.py configuration...")
    
    try:
        with open('app.py', 'r') as f:
            content = f.read()
        
        # Update the DB_CONFIG
        old_config = """DB_CONFIG = {
    'host': os.getenv('MYSQL_HOST', 'localhost'),
    'user': os.getenv('MYSQL_USER', 'root'),
    'passwd': os.getenv('MYSQL_PASSWORD', ''),  # Empty password for default MySQL setup
    'db': os.getenv('MYSQL_DB', 'fashion_mart'),
    'charset': 'utf8mb4'
}"""
        
        new_config = """DB_CONFIG = {
    'host': os.getenv('MYSQL_HOST', 'localhost'),
    'user': os.getenv('MYSQL_USER', 'fashion_user'),
    'passwd': os.getenv('MYSQL_PASSWORD', 'fashion_pass_2024'),
    'db': os.getenv('MYSQL_DB', 'fashion_mart'),
    'charset': 'utf8mb4'
}"""
        
        content = content.replace(old_config, new_config)
        
        with open('app.py', 'w') as f:
            f.write(content)
        
        print("✅ app.py updated with new credentials")
        return True
    except Exception as e:
        print(f"❌ Failed to update app.py: {e}")
        return False

if __name__ == '__main__':
    print("="*60)
    print("Fashion Mart - Database Setup")
    print("="*60)
    
    success, error = test_connection()
    
    if not success or error == 'socket':
        print("\n" + "="*60)
        print("Creating dedicated MySQL user for the application...")
        print("="*60)
        
        if create_mysql_user():
            if update_app_config():
                print("\n" + "="*60)
                print("✅ Setup completed successfully!")
                print("="*60)
                print("\nYou can now run the application with:")
                print("   python app.py")
                sys.exit(0)
        
        print("\n❌ Setup failed. Please configure manually.")
        sys.exit(1)
    else:
        print("\n✅ Database connection is working!")
        print("You can now run the application.")
        sys.exit(0)

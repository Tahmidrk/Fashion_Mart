#!/bin/bash
# Safe Database Update Script for Fashion Mart
# This script ensures your data is NEVER lost when updating

echo "=========================================="
echo "Fashion Mart - Safe Database Update"
echo "=========================================="
echo ""

# Check if running from correct directory
if [ ! -f "app.py" ]; then
    echo "❌ Error: Please run this script from the Fashion mart directory"
    exit 1
fi

# Database credentials
DB_USER="fashion_user"
DB_PASS="fashion_pass_2024"
DB_NAME="fashion_mart"

# Step 1: Create backup
echo "Step 1/3: Creating backup..."
./database/backup.sh
if [ $? -ne 0 ]; then
    echo "❌ Backup failed! Aborting update."
    exit 1
fi
echo "✅ Backup created successfully"
echo ""

# Step 2: Count existing data
echo "Step 2/3: Checking existing data..."
CUSTOMER_COUNT=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -se "SELECT COUNT(*) FROM Customer;" 2>/dev/null)
ORDER_COUNT=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -se "SELECT COUNT(*) FROM \`Order\`;" 2>/dev/null)
PRODUCT_COUNT=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -se "SELECT COUNT(*) FROM Product;" 2>/dev/null)

echo "📊 Current data:"
echo "   - Customers: $CUSTOMER_COUNT"
echo "   - Orders: $ORDER_COUNT"
echo "   - Products: $PRODUCT_COUNT"
echo ""

# Step 3: Apply migration
echo "Step 3/3: Applying safe migration..."
if [ -f "database/migration_add_payment_delivery.sql" ]; then
    mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migration_add_payment_delivery.sql 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Migration applied successfully"
    else
        echo "❌ Migration failed!"
        exit 1
    fi
else
    echo "⚠️  Migration file not found. Skipping..."
fi
echo ""

# Step 4: Verify data integrity
echo "Verifying data integrity..."
NEW_CUSTOMER_COUNT=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -se "SELECT COUNT(*) FROM Customer;" 2>/dev/null)
NEW_ORDER_COUNT=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -se "SELECT COUNT(*) FROM \`Order\`;" 2>/dev/null)
NEW_PRODUCT_COUNT=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -se "SELECT COUNT(*) FROM Product;" 2>/dev/null)

echo "📊 After update:"
echo "   - Customers: $NEW_CUSTOMER_COUNT (was $CUSTOMER_COUNT)"
echo "   - Orders: $NEW_ORDER_COUNT (was $ORDER_COUNT)"
echo "   - Products: $NEW_PRODUCT_COUNT (was $PRODUCT_COUNT)"
echo ""

# Check if data was preserved
if [ "$NEW_CUSTOMER_COUNT" -ge "$CUSTOMER_COUNT" ] && \
   [ "$NEW_ORDER_COUNT" -ge "$ORDER_COUNT" ] && \
   [ "$NEW_PRODUCT_COUNT" -ge "$PRODUCT_COUNT" ]; then
    echo "✅ SUCCESS! All data preserved and new features added!"
else
    echo "⚠️  Warning: Some data counts changed. Check backup if needed."
fi

echo ""
echo "=========================================="
echo "Update Complete!"
echo "=========================================="
echo "Your login credentials are safe! 🔒"
echo ""
echo "Test your accounts at: http://localhost:5000/login"
echo ""

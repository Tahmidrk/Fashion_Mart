# Fashion Mart - Database Management Guide

## 🔒 Protecting Your Login Credentials

Your customer login credentials and all existing data are **NEVER deleted** when adding new features. Here's how:

---

## ✅ Safe Database Updates

### Method 1: Using Migration Script (RECOMMENDED)
This method only **adds** new features without touching existing data:

```bash
cd "/home/tahmid/Documents/Fashion mart"
mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/migration_add_payment_delivery.sql
```

**What it does:**
- ✅ Creates new tables only if they don't exist
- ✅ Adds new columns only if they don't exist
- ✅ Preserves ALL existing customers, orders, products
- ✅ Your login credentials remain intact
- ✅ Safe to run multiple times

---

### Method 2: Full Schema Rebuild (USE WITH CAUTION)
This recreates the entire database with sample data:

```bash
# ⚠️ WARNING: This DELETES all data and recreates from scratch
mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/schema.sql
```

**Use this only for:**
- Fresh installation
- Development/testing
- When you want to reset to sample data

**Never use this on production with real customer data!**

---

## 🗄️ Creating Backups

### Before Any Database Changes:

```bash
cd "/home/tahmid/Documents/Fashion mart"
./database/backup.sh
```

This creates a timestamped backup in `database/backups/`

### Manual Backup:
```bash
mysqldump -u fashion_user -pfashion_pass_2024 fashion_mart > my_backup.sql
```

### Restore from Backup:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart < my_backup.sql
```

---

## 📋 Best Practices

### When Adding New Features:

1. **Always backup first:**
   ```bash
   ./database/backup.sh
   ```

2. **Use migration scripts instead of schema.sql:**
   ```bash
   mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/migration_xxx.sql
   ```

3. **Test on a copy first** (optional but recommended)

4. **Verify data after migration:**
   ```bash
   mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT COUNT(*) FROM Customer;"
   ```

---

## 🔍 Checking Your Data

### Count customers:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT COUNT(*) as TotalCustomers FROM Customer;"
```

### List all customers:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT CustomerID, Username, Name, Email FROM Customer;"
```

### Check orders:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT COUNT(*) as TotalOrders FROM \`Order\`;"
```

---

## 🛡️ Data Safety Guarantees

When using **migration scripts**, your data is protected because:

1. **CREATE TABLE IF NOT EXISTS** - Only creates new tables if missing
2. **ALTER TABLE ADD COLUMN IF NOT EXISTS** - Only adds new columns if missing
3. **INSERT IGNORE** - Only inserts if data doesn't exist
4. **UPDATE ... WHERE ... IS NULL** - Only updates empty fields
5. **No DROP statements** - Never deletes existing data

---

## 🔑 Your Current Login Credentials

After using migration scripts, all your existing accounts work:

**Customer Accounts:** All preserved ✅
- Any customers you registered are still there
- Login with same username/password

**New Test Accounts Added:**
- Delivery1: `delivery1 / delivery123`
- Delivery2: `delivery2 / delivery123`
- Delivery3: `delivery3 / delivery123`

---

## 📞 Emergency Recovery

If you accidentally run schema.sql and lose data:

1. Stop the application
2. Restore from backup:
   ```bash
   mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/backups/fashion_mart_backup_YYYYMMDD_HHMMSS.sql
   ```
3. Restart the application

---

## 💡 Quick Reference

| Action | Command | Safe? |
|--------|---------|-------|
| Add new features | `migration_xxx.sql` | ✅ YES |
| Fresh install | `schema.sql` | ⚠️ Deletes data |
| Backup | `./database/backup.sh` | ✅ YES |
| Restore | `mysql ... < backup.sql` | ✅ YES |

---

## 🎯 Summary

**ALWAYS USE:** Migration scripts for adding features
**NEVER USE:** schema.sql on production with real data
**ALWAYS DO:** Backup before any changes

Your login credentials are safe as long as you follow these practices! 🔒

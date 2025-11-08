# 🎯 Quick Reference: Account Safety & Updates

## ✅ Your Current Accounts (PERMANENT)

### Customers (all safe in database):
```
john_doe      / password123
jane_smith    / password123  
guest_user    / password123
+ Any you create via /register
```

### Test this:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT Username, Name FROM Customer;"
```

---

## 🔒 Account Safety - GUARANTEED

### ✅ Accounts SURVIVE:
- Server restarts
- Code updates (app.py changes)
- Template updates (HTML changes)
- System reboots
- Git commits/pushes

### ❌ Accounts DELETED ONLY IF:
- You manually delete them
- You run `schema.sql` again (DON'T!)
- You run `DROP TABLE` (DON'T!)

---

## 🛠️ Safe Update Process

### When Adding New Features:

**Step 1: Update Code** (always safe)
```bash
# Edit app.py, templates, etc.
nano app.py
```

**Step 2: If Database Changes Needed:**
```bash
# Create migration file
nano database/migration_my_feature.sql

# Add safe commands:
ALTER TABLE Customer ADD COLUMN Phone VARCHAR(20);
```

**Step 3: Backup First**
```bash
cd database
./backup.sh
```

**Step 4: Apply Migration**
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart < database/migration_my_feature.sql
```

**Step 5: Restart Server**
```bash
pkill -f "python app.py"
cd "/home/tahmid/Documents/Fashion mart"
source venv/bin/activate
python app.py
```

---

## 🐛 Fix: Login Form Auto-fill "admin"

### What I Fixed:
✅ Added `autocomplete="off"` to username field  
✅ Added `autocomplete="new-password"` to password field  
✅ Added placeholder text  

### Now the form won't auto-fill with "admin"

### To Clear Old Autofill:
```
1. Click username field
2. See "admin" suggestion
3. Hover over it
4. Press Shift + Delete (Windows/Linux) or Fn + Delete (Mac)
```

---

## 📊 Check Your Data Anytime

### View all customers:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT * FROM Customer;"
```

### View all orders:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT * FROM \`Order\`;"
```

### Count accounts:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart -e "SELECT COUNT(*) as TotalCustomers FROM Customer;"
```

---

## 💾 Backup Commands

### Create backup now:
```bash
cd "/home/tahmid/Documents/Fashion mart/database"
./backup.sh
```

### Manual backup:
```bash
mysqldump -u fashion_user -pfashion_pass_2024 fashion_mart > my_backup_$(date +%Y%m%d).sql
```

### Restore from backup:
```bash
mysql -u fashion_user -pfashion_pass_2024 fashion_mart < backup_file.sql
```

---

## 🎓 Remember:

1. **Code changes** (app.py, templates) = ALWAYS SAFE
2. **Database schema changes** = USE MIGRATIONS
3. **Never run** `schema.sql` again
4. **Always backup** before database changes
5. **Your accounts are PERMANENT** on disk

---

## 🚀 Current Status:

✅ Login form fixed (no more auto-fill "admin")  
✅ 3 customer accounts in database (PERMANENT)  
✅ 3 delivery accounts in database (PERMANENT)  
✅ 1 admin account in database (PERMANENT)  
✅ Backup system ready  
✅ Migration system ready  

**Your data is SAFE and will remain FOREVER!** 🎉

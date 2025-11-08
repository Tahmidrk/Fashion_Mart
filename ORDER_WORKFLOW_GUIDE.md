# 📋 Order Status Workflow - Fashion Mart

## Complete Order Lifecycle

### Order Status Flow Chart

```
┌─────────────────────────────────────────────────────────────────┐
│                     ORDER LIFECYCLE                             │
└─────────────────────────────────────────────────────────────────┘

1. PENDING (Initial State)
   ↓
   Customer places order at checkout
   - Payment Method selected (COD/Online/Bank Transfer)
   - Payment Status: Pending
   - Delivery Status: Pending
   
2. ASSIGNED (Admin Action)
   ↓
   Admin assigns order to delivery man
   - Order still: Pending
   - Delivery man can now see the order
   
3. DELIVERED (Delivery Man Action)
   ↓
   Delivery man marks order as delivered
   - Order Status: Delivered
   - Delivery Date: Set to current date
   
   ┌─────────────────────────────────────────────────────────┐
   │                PAYMENT METHOD BRANCH                    │
   └─────────────────────────────────────────────────────────┘
   
   A. Cash on Delivery (COD):
      - Status: Delivered
      - Payment Status: Still Pending
      ↓
      Delivery man clicks "Confirm Cash Received"
      - Payment Status: Paid
      - Order Status: COMPLETE ✅
   
   B. Online Payment / Bank Transfer:
      - Status: Delivered
      - Payment Status: Paid (assumed paid upfront)
      - Order Status: Auto → COMPLETE ✅

```

---

## 🔄 Status Transitions Explained

### 1. **Pending → Delivered**
**Who:** Delivery Man  
**Action:** Clicks "Mark as Delivered" button  
**Result:**
- Order Status changes from `Pending` to `Delivered`
- Delivery Date is recorded
- Delivery Status updated in Delivery table

### 2. **Delivered → Complete** (TWO PATHS)

#### Path A: Cash on Delivery (COD)
**Who:** Delivery Man  
**Action:** Clicks "Confirm Cash Received" button  
**Conditions:**
- Order must be `Delivered`
- Payment Method = `Cash on Delivery`
- Payment Status = `Pending`

**Result:**
- Payment Status: `Pending` → `Paid`
- Order Status: `Delivered` → `Complete` ✅

#### Path B: Online/Bank Transfer (Automatic)
**Who:** System (Automatic)  
**When:** Order marked as Delivered  
**Conditions:**
- Order Status = `Delivered`
- Payment Method = `Online Payment` OR `Bank Transfer`

**Result:**
- Order Status: Automatically → `Complete` ✅
- (Payment already considered received)

---

## 📊 Status Definitions

| Status | Meaning | Who Can Set | Next Status |
|--------|---------|-------------|-------------|
| **Pending** | Order placed, awaiting delivery assignment | System | Pending (assigned) |
| **Delivered** | Order delivered to customer | Delivery Man | Complete |
| **Complete** | Delivered + Payment Received | System (auto) | Final State ✅ |

---

## 💳 Payment Status

| Status | Meaning | When |
|--------|---------|------|
| **Pending** | Payment not yet received | Initial state for COD orders |
| **Paid** | Payment received/confirmed | After cash received OR prepaid |

---

## 🎯 Automatic Status Updates

The system automatically updates order status in these scenarios:

### Scenario 1: Delivery Man Marks as Delivered
```python
if order.PaymentMethod in ['Online Payment', 'Bank Transfer']:
    order.OrderStatus = 'Complete'  # Auto-complete
else:  # Cash on Delivery
    order.OrderStatus = 'Delivered'  # Wait for cash
```

### Scenario 2: Delivery Man Confirms Cash Payment
```python
if order.OrderStatus == 'Delivered' and payment_status == 'Paid':
    order.OrderStatus = 'Complete'  # Now complete!
```

---

## 🚀 Step-by-Step Examples

### Example 1: Cash on Delivery Order

1. **Customer Action:** Places order, selects "Cash on Delivery"
   ```
   Status: Pending
   Payment: Pending
   ```

2. **Admin Action:** Assigns to delivery man "Karim"
   ```
   Status: Pending (but now assigned)
   Delivery Man: Karim Rahman
   ```

3. **Delivery Man Action:** Delivers order, clicks "Mark as Delivered"
   ```
   Status: Delivered
   Payment: Pending (still waiting for cash)
   ```

4. **Delivery Man Action:** Receives cash, clicks "Confirm Cash Received"
   ```
   Status: Complete ✅
   Payment: Paid ✅
   ```

### Example 2: Online Payment Order

1. **Customer Action:** Places order, selects "Online Payment", pays via bKash
   ```
   Status: Pending
   Payment: Paid (customer already paid)
   ```

2. **Admin Action:** Assigns to delivery man "Rahim"
   ```
   Status: Pending (assigned)
   ```

3. **Delivery Man Action:** Delivers order, clicks "Mark as Delivered"
   ```
   Status: Complete ✅ (AUTOMATICALLY!)
   Payment: Paid ✅
   ```
   *No extra step needed - auto-completed because payment was already done*

---

## 🔐 Security & Permissions

| Action | Permission Required |
|--------|-------------------|
| Assign Order | Admin only |
| Mark as Delivered | Assigned Delivery Man only |
| Confirm Payment | Assigned Delivery Man only |
| View Order | Customer OR Assigned Delivery Man OR Admin |

---

## 📱 User Interface Buttons

### Delivery Man Dashboard

**When Order is Pending:**
```
[✓ Mark as Delivered]  ← Click to deliver
```

**When Order is Delivered + COD + Payment Pending:**
```
[💰 Confirm Cash Received]  ← Click after receiving cash
```

**When Order is Complete:**
```
✅ Order Complete  ← Just shows status, no action needed
```

---

## 🧪 Testing the Workflow

### Test Case 1: COD Order
1. Login as customer: http://localhost:5000/login
2. Add items to cart and checkout
3. Select "Cash on Delivery"
4. Place order

5. Go to admin: http://localhost:5000/admin/orders
6. Assign order to delivery man

7. Login as delivery man: http://localhost:5000/delivery/login
8. Click "Mark as Delivered"
9. Click "Confirm Cash Received"
10. ✅ Status should now be "Complete"

### Test Case 2: Online Payment Order
1. Login as customer
2. Add items to cart and checkout
3. Select "Online Payment"
4. Place order

5. Admin assigns to delivery man

6. Delivery man clicks "Mark as Delivered"
7. ✅ Status automatically becomes "Complete"

---

## 💡 Key Points

✅ **Cash on Delivery** requires TWO actions by delivery man:
   1. Mark as Delivered
   2. Confirm Cash Received

✅ **Online/Bank Transfer** requires ONE action:
   1. Mark as Delivered (auto-completes)

✅ Orders cannot be marked complete without delivery confirmation

✅ COD orders cannot be completed without payment confirmation

✅ System automatically handles status transitions based on payment method

---

## 🛠️ Database Queries

### Check Order Status:
```sql
SELECT OrderID, OrderStatus, PaymentStatus, PaymentMethod 
FROM `Order` 
WHERE OrderID = 123;
```

### Find Incomplete COD Orders:
```sql
SELECT * FROM `Order` 
WHERE PaymentMethod = 'Cash on Delivery' 
  AND OrderStatus = 'Delivered' 
  AND PaymentStatus = 'Pending';
```

### Find All Complete Orders:
```sql
SELECT * FROM `Order` 
WHERE OrderStatus = 'Complete';
```

---

**Your order workflow is now fully automated! 🎉**

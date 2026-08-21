# Schema & Data Models

## Purpose
Defines the **Data Models, Entities, and DTO contracts** used in the Aisley Mobile Application (Flutter).

---

## 1. User & KYC Domain

### `BuyerProfile`
```dart
class BuyerProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String? middleInitial;
  final String email;
  final String contactNo;
  final String birthday;        // ISO 8601 string (YYYY-MM-DD)
  final int age;                 // Validated >= 18
  final String sex;              // 'Female', 'Male', 'Non-Binary', 'Prefer not to say'
  final PhilippineAddress address;
  final String kycIdType;        // PhilSys, Passport, Driver's License, etc.
  final String? kycIdFileUrl;
  final String? kycIdFileName;
  final BuyerStatus status;      // pending, approved, rejected
  final bool isVip;
  final String avatarUrl;
}
```

### `PhilippineAddress`
```dart
class PhilippineAddress {
  final String province;
  final String city;
  final String barangay;
  final String street;
  final String? houseNumber;
  final String postalCode;
}
```

---

## 2. Product & Catalog Domain

### `Product`
```dart
class Product {
  final String id;
  final String title;
  final String boutiqueName;
  final String sku;
  final String category;
  final String description;
  final double basePrice;
  final double compareAtPrice;
  final int stock;
  final String imageUrl;
  final List<String> images;
  final List<ProductVariant> variants;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final List<ProductReview> reviews;
}
```

### `ProductVariant`
```dart
class ProductVariant {
  final String id;
  final String name;
  final String sku;
  final double price;
  final int stock;
}
```

### `ProductReview`
```dart
class ProductReview {
  final String id;
  final String authorName;
  final String authorAvatar;
  final double rating;
  final String date;
  final String comment;
  final String? variantPurchased;
  final bool isVerifiedBuyer;
}
```

---

## 3. Shopping Bag & Order Domain

### `CartItem`
```dart
class CartItem {
  final String id;
  final Product product;
  final ProductVariant? variant;
  final String? selectedSize;
  final String? selectedColor;
  final int quantity;
  final bool isSelected;
}
```

### `BuyerOrder`
```dart
class BuyerOrder {
  final String id;
  final String orderNumber;
  final String trackingNumber;
  final String boutiqueName;
  final DateTime orderDate;
  final OrderStatus status;      // toShip, inTransit, outForDelivery, delivered
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double discountAmount;
  final double totalAmount;
  final String paymentMethod;    // GCash, Maya, Card, COD
  final PhilippineAddress shippingAddress;
  final List<TrackingMilestone> trackingMilestones;
  final CustomerReview? review;
}
```

### `Voucher`
```dart
class Voucher {
  final String id;
  final String code;
  final String title;
  final String description;
  final VoucherType type;        // percentage, fixed
  final double value;
  final double minSpend;
  final DateTime validUntil;
}
```

---

## 4. Concierge Chat Domain

### `ChatThread`
```dart
class ChatThread {
  final String id;
  final String boutiqueName;
  final String boutiqueAvatar;
  final String lastMessage;
  final String lastActive;
  final String location;
  final int unreadCount;
  final List<ChatMessage> messages;
}
```

### `ChatMessage`
```dart
class ChatMessage {
  final String id;
  final String text;
  final bool isFromBuyer;
  final DateTime timestamp;
  final ChatAttachment? attachment;
}
```

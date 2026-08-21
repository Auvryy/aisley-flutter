import 'package:flutter/material.dart';
import '../core/data/mock_buyer_data.dart';
import '../core/models/address.dart';
import '../core/models/buyer_profile.dart';
import '../core/models/cart_item.dart';
import '../core/models/chat.dart';
import '../core/models/order.dart';
import '../core/models/product.dart';
import '../core/models/voucher.dart';

enum AuthState {
  unauthenticated,
  pendingApproval,
  approved,
}

class BuyerState extends ChangeNotifier {
  AuthState _authState = AuthState.unauthenticated;
  BuyerProfile? _currentBuyer;
  ThemeMode _themeMode = ThemeMode.light;

  // Products
  final List<Product> _products = List.from(MOCK_PRODUCTS);
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Cart
  final List<CartItem> _cartItems = [];
  Voucher? _appliedVoucher;

  // Orders
  final List<BuyerOrder> _orders = List.from(INITIAL_BUYER_ORDERS);

  // Chat
  final List<ChatThread> _chatThreads = List.from(INITIAL_CHAT_THREADS);
  String _activeThreadId = 'chat-thread-1';

  BuyerState() {
    // Start with 1 sample item in cart for quick preview
    if (_products.isNotEmpty) {
      _cartItems.add(
        CartItem(
          id: 'cart-init-1',
          product: _products[0],
          selectedVariant: _products[0].variants.isNotEmpty ? _products[0].variants[0] : null,
          selectedSize: 'M',
          selectedColor: 'Noir Black',
          quantity: 1,
          isSelected: true,
        ),
      );
    }
  }

  // Getters
  AuthState get authState => _authState;
  BuyerProfile? get currentBuyer => _currentBuyer;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  List<Product> get products {
    return _products.where((p) {
      final matchesQuery = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.boutiqueName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  List<Product> get allProducts => _products;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<CartItem> get cartItems => _cartItems;
  Voucher? get appliedVoucher => _appliedVoucher;

  List<BuyerOrder> get orders => _orders;

  List<ChatThread> get chatThreads => _chatThreads;
  String get activeThreadId => _activeThreadId;
  ChatThread? get activeThread {
    try {
      return _chatThreads.firstWhere((t) => t.id == _activeThreadId);
    } catch (_) {
      return _chatThreads.isNotEmpty ? _chatThreads.first : null;
    }
  }

  // Cart Calculations
  double get cartSubtotal {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get cartShippingFee {
    final selectedCount = _cartItems.where((item) => item.isSelected).length;
    if (selectedCount == 0) return 0.0;
    return cartSubtotal >= 15000.0 ? 0.0 : 250.0; // Free white glove shipping over ₱15,000
  }

  double get cartVoucherDiscount {
    if (_appliedVoucher == null) return 0.0;
    return _appliedVoucher!.calculateDiscount(cartSubtotal);
  }

  double get cartGrandTotal {
    final total = cartSubtotal + cartShippingFee - cartVoucherDiscount;
    return total > 0 ? total : 0.0;
  }

  int get cartBadgeCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  int get unreadChatCount {
    return _chatThreads.fold(0, (sum, t) => sum + t.unreadCount);
  }

  // Auth actions
  void loginAsApproved() {
    _currentBuyer = MOCK_APPROVED_BUYER;
    _authState = AuthState.approved;
    notifyListeners();
  }

  void loginAsPending() {
    _currentBuyer = MOCK_PENDING_BUYER;
    _authState = AuthState.pendingApproval;
    notifyListeners();
  }

  void loginWithCredentials(String email, String password) {
    if (email.toLowerCase().contains('mateo') || email.toLowerCase().contains('pending')) {
      loginAsPending();
    } else {
      loginAsApproved();
    }
  }

  void registerBuyer({
    required String firstName,
    required String lastName,
    required String middleInitial,
    required String sex,
    required String email,
    required String contactNo,
    required String birthday,
    required int age,
    required PhilippineAddress address,
    required String kycIdType,
    required String kycIdFileName,
    String? kycIdPreviewUrl,
  }) {
    _currentBuyer = BuyerProfile(
      id: 'usr_buyer_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      firstName: firstName,
      lastName: lastName,
      middleInitial: middleInitial,
      sex: sex,
      contactNo: contactNo,
      birthday: birthday,
      age: age,
      address: address,
      kycIdType: kycIdType,
      kycIdFileName: kycIdFileName,
      kycIdPreviewUrl: kycIdPreviewUrl,
      submittedAt: DateTime.now().toIso8601String(),
      status: BuyerStatus.pending,
      isVip: false,
    );
    _authState = AuthState.pendingApproval;
    notifyListeners();
  }

  void simulateAdminApproval() {
    if (_currentBuyer != null) {
      _currentBuyer = _currentBuyer!.copyWith(
        status: BuyerStatus.approved,
        isVip: true,
      );
      _authState = AuthState.approved;
      notifyListeners();
    }
  }

  void simulateAdminPending() {
    if (_currentBuyer != null) {
      _currentBuyer = _currentBuyer!.copyWith(
        status: BuyerStatus.pending,
      );
      _authState = AuthState.pendingApproval;
      notifyListeners();
    }
  }

  void logout() {
    _authState = AuthState.unauthenticated;
    _currentBuyer = null;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Filter & Search
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Cart operations
  void addToCart(Product product, {ProductVariant? variant, String? size, String? color, int quantity = 1}) {
    final existingIndex = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor == color &&
          item.selectedVariant?.id == variant?.id,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(
          id: 'cart-${DateTime.now().millisecondsSinceEpoch}',
          product: product,
          selectedVariant: variant,
          selectedSize: size,
          selectedColor: color,
          quantity: quantity,
          isSelected: true,
        ),
      );
    }
    notifyListeners();
  }

  void updateCartItemQuantity(String itemId, int delta) {
    final index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final newQuantity = _cartItems[index].quantity + delta;
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void toggleCartItemSelection(String itemId) {
    final index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _cartItems[index].isSelected = !_cartItems[index].isSelected;
      notifyListeners();
    }
  }

  void toggleSelectAllCart(bool selectAll) {
    for (var item in _cartItems) {
      item.isSelected = selectAll;
    }
    notifyListeners();
  }

  void removeCartItem(String itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  bool applyVoucher(String code) {
    try {
      final voucher = MOCK_VOUCHERS.firstWhere(
        (v) => v.code.toUpperCase() == code.trim().toUpperCase(),
      );
      _appliedVoucher = voucher;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void removeVoucher() {
    _appliedVoucher = null;
    notifyListeners();
  }

  // Checkout & Order creation
  BuyerOrder placeOrder({
    required String paymentMethod,
    required PhilippineAddress deliveryAddress,
    String? notes,
  }) {
    final selectedItems = _cartItems.where((i) => i.isSelected).toList();
    final orderItemsData = selectedItems.map((cartItem) {
      return OrderItemData(
        productId: cartItem.product.id,
        productTitle: cartItem.product.title,
        boutiqueName: cartItem.product.boutiqueName,
        variantDescription: cartItem.variantDescription,
        unitPrice: cartItem.unitPrice,
        quantity: cartItem.quantity,
        imageUrl: cartItem.product.imageUrl,
      );
    }).toList();

    final orderNumber = 'AIS-2026-${(1000 + _orders.length + 1)}';
    final trackingNumber = 'AIS-EXP-${(8000 + _orders.length * 111)}-MNL';

    final newOrder = BuyerOrder(
      id: 'ord-${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: orderNumber,
      trackingNumber: trackingNumber,
      items: orderItemsData,
      subtotal: cartSubtotal,
      shippingFee: cartShippingFee,
      discountAmount: cartVoucherDiscount,
      voucherCode: _appliedVoucher?.code,
      totalAmount: cartGrandTotal,
      paymentMethod: paymentMethod,
      status: OrderStatus.toShip,
      courierName: 'Aisley White Glove Express',
      shippingAddress: deliveryAddress,
      createdAt: 'Just now',
      timeline: [
        TrackingMilestone(
          title: 'Order Placed & Payment Authorized',
          description: 'Payment authorized via $paymentMethod.',
          timestamp: 'Just now',
          isCompleted: true,
        ),
        const TrackingMilestone(
          title: 'Awaiting Boutique Packing',
          description: 'Boutique is notified to prepare parcel.',
          timestamp: 'Pending',
          isCompleted: false,
        ),
      ],
    );

    _orders.insert(0, newOrder);

    // Remove selected items from cart
    _cartItems.removeWhere((item) => item.isSelected);
    _appliedVoucher = null;

    notifyListeners();
    return newOrder;
  }

  // Reviews
  void submitOrderReview(String orderId, double rating, String comment) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final updated = _orders[index].copyWith(
        review: CustomerReview(
          rating: rating,
          comment: comment,
          createdAt: 'Just now',
        ),
      );
      _orders[index] = updated;
      notifyListeners();
    }
  }

  // Chat
  void selectChatThread(String threadId) {
    _activeThreadId = threadId;
    final index = _chatThreads.indexWhere((t) => t.id == threadId);
    if (index >= 0) {
      final thread = _chatThreads[index];
      _chatThreads[index] = ChatThread(
        id: thread.id,
        boutiqueName: thread.boutiqueName,
        boutiqueAvatar: thread.boutiqueAvatar,
        location: thread.location,
        messages: thread.messages,
        unreadCount: 0,
        lastActive: thread.lastActive,
      );
    }
    notifyListeners();
  }

  void sendMessage(String text, {ChatProductAttachment? attachment}) {
    if (text.trim().isEmpty && attachment == null) return;

    final index = _chatThreads.indexWhere((t) => t.id == _activeThreadId);
    if (index >= 0) {
      final thread = _chatThreads[index];
      final newMsg = ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        senderId: _currentBuyer?.id ?? 'buyer',
        senderName: _currentBuyer?.firstName ?? 'You',
        isFromBuyer: true,
        text: text,
        timestamp: 'Just now',
        attachment: attachment,
      );

      final updatedMessages = List<ChatMessage>.from(thread.messages)..add(newMsg);
      _chatThreads[index] = ChatThread(
        id: thread.id,
        boutiqueName: thread.boutiqueName,
        boutiqueAvatar: thread.boutiqueAvatar,
        location: thread.location,
        messages: updatedMessages,
        unreadCount: 0,
        lastActive: 'Just now',
      );
      notifyListeners();
    }
  }
}

class BuyerStateProvider extends InheritedNotifier<BuyerState> {
  const BuyerStateProvider({
    super.key,
    required BuyerState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static BuyerState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<BuyerStateProvider>();
    assert(provider != null, 'No BuyerStateProvider found in context');
    return provider!.notifier!;
  }
}

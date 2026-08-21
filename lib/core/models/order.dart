import 'address.dart';

enum OrderStatus {
  toShip,
  inTransit,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.toShip:
        return 'To Ship';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class TrackingMilestone {
  final String title;
  final String description;
  final String timestamp;
  final bool isCompleted;

  const TrackingMilestone({
    required this.title,
    required this.description,
    required this.timestamp,
    this.isCompleted = true,
  });
}

class CustomerReview {
  final double rating;
  final String comment;
  final String createdAt;
  final List<String> photos;

  const CustomerReview({
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.photos = const [],
  });
}

class OrderItemData {
  final String productId;
  final String productTitle;
  final String boutiqueName;
  final String variantDescription;
  final double unitPrice;
  final int quantity;
  final String imageUrl;

  const OrderItemData({
    required this.productId,
    required this.productTitle,
    required this.boutiqueName,
    required this.variantDescription,
    required this.unitPrice,
    required this.quantity,
    required this.imageUrl,
  });

  double get totalPrice => unitPrice * quantity;
}

class BuyerOrder {
  final String id;
  final String orderNumber;
  final String trackingNumber;
  final List<OrderItemData> items;
  final double subtotal;
  final double shippingFee;
  final double discountAmount;
  final String? voucherCode;
  final double totalAmount;
  final String paymentMethod;
  final OrderStatus status;
  final String courierName;
  final PhilippineAddress shippingAddress;
  final String createdAt;
  final List<TrackingMilestone> timeline;
  final CustomerReview? review;

  const BuyerOrder({
    required this.id,
    required this.orderNumber,
    required this.trackingNumber,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.discountAmount,
    this.voucherCode,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.courierName,
    required this.shippingAddress,
    required this.createdAt,
    required this.timeline,
    this.review,
  });

  BuyerOrder copyWith({
    String? id,
    String? orderNumber,
    String? trackingNumber,
    List<OrderItemData>? items,
    double? subtotal,
    double? shippingFee,
    double? discountAmount,
    String? voucherCode,
    double? totalAmount,
    String? paymentMethod,
    OrderStatus? status,
    String? courierName,
    PhilippineAddress? shippingAddress,
    String? createdAt,
    List<TrackingMilestone>? timeline,
    CustomerReview? review,
  }) {
    return BuyerOrder(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      discountAmount: discountAmount ?? this.discountAmount,
      voucherCode: voucherCode ?? this.voucherCode,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      courierName: courierName ?? this.courierName,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      createdAt: createdAt ?? this.createdAt,
      timeline: timeline ?? this.timeline,
      review: review ?? this.review,
    );
  }
}

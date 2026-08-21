import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final ProductVariant? selectedVariant;
  final String? selectedSize;
  final String? selectedColor;
  int quantity;
  bool isSelected;

  CartItem({
    required this.id,
    required this.product,
    this.selectedVariant,
    this.selectedSize,
    this.selectedColor,
    this.quantity = 1,
    this.isSelected = true,
  });

  double get unitPrice => selectedVariant?.price ?? product.basePrice;

  double get totalPrice => unitPrice * quantity;

  String get variantDescription {
    final parts = <String>[];
    if (selectedSize != null && selectedSize!.isNotEmpty) {
      parts.add('Size: $selectedSize');
    }
    if (selectedColor != null && selectedColor!.isNotEmpty) {
      parts.add('Color: $selectedColor');
    }
    if (parts.isEmpty && selectedVariant != null) {
      return selectedVariant!.name;
    }
    return parts.join(' • ');
  }
}

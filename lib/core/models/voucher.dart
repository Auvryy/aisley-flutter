enum VoucherDiscountType {
  percentage,
  fixed,
}

class Voucher {
  final String id;
  final String code;
  final String description;
  final VoucherDiscountType discountType;
  final double discountValue; // e.g. 15 for 15% or 1000 for ₱1000
  final double minSpend;
  final double? maxDiscount;
  final String validUntil;

  const Voucher({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minSpend,
    this.maxDiscount,
    required this.validUntil,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minSpend) return 0.0;
    if (discountType == VoucherDiscountType.percentage) {
      double discount = subtotal * (discountValue / 100.0);
      if (maxDiscount != null && discount > maxDiscount!) {
        discount = maxDiscount!;
      }
      return discount;
    } else {
      return discountValue;
    }
  }
}

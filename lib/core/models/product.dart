class ProductVariant {
  final String id;
  final String name;
  final String sku;
  final double price;
  final int stock;

  const ProductVariant({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.stock,
  });
}

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

  const Product({
    required this.id,
    required this.title,
    required this.boutiqueName,
    required this.sku,
    required this.category,
    required this.description,
    required this.basePrice,
    required this.compareAtPrice,
    required this.stock,
    required this.imageUrl,
    required this.images,
    required this.variants,
    required this.sizes,
    required this.colors,
    this.rating = 5.0,
    this.reviewCount = 12,
    this.isFeatured = false,
  });
}

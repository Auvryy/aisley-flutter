import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/models/product.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/aisley_button.dart';
import '../../core/widgets/aisley_image.dart';
import '../../core/widgets/status_badge.dart';
import '../../state/buyer_state.dart';
import '../chat/buyer_chat_view.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;
  bool _isFavorited = false;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors.first;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ProductVariant? get _matchedVariant {
    if (widget.product.variants.isEmpty) return null;
    return widget.product.variants.first;
  }

  double get _currentPrice {
    return _matchedVariant?.price ?? widget.product.basePrice;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);
    final allImages = widget.product.images.isNotEmpty ? widget.product.images : [widget.product.imageUrl];
    final suggestedProducts = state.products.where((p) => p.id != widget.product.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.boutiqueName,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            tooltip: 'Add to Wishlist',
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited ? AisleyColors.accentPink : null,
            ),
            onPressed: () {
              setState(() => _isFavorited = !_isFavorited);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFavorited ? 'Saved to your Wishlist.' : 'Removed from Wishlist.'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: AisleyColors.accentPink,
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Shopping Bag',
            icon: Badge(
              isLabelVisible: state.cartBadgeCount > 0,
              label: Text('${state.cartBadgeCount}'),
              backgroundColor: AisleyColors.accentPink,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery with PageView & Indicator
            Stack(
              children: [
                SizedBox(
                  height: 380,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: allImages.length,
                    onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
                    itemBuilder: (context, index) {
                      return AisleyNetworkImage(
                        imageUrl: allImages[index],
                        width: double.infinity,
                        height: 380,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                if (allImages.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(allImages.length, (idx) {
                        final isSelected = _currentImageIndex == idx;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected ? AisleyColors.accentPink : Colors.white70,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
                Positioned(
                  top: 14,
                  left: 16,
                  child: StatusBadge(
                    label: widget.product.category.toUpperCase(),
                    type: BadgeType.pink,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Boutique Atelier Card with Direct Chat Action
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AisleyColors.obsidianSurface : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AisleyColors.accentPink.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.storefront_rounded, size: 20, color: AisleyColors.accentPink),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.product.boutiqueName,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, size: 14, color: AisleyColors.accentPink),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Verified Luxury Atelier • Metro Manila',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AisleyColors.accentPink),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 13, color: AisleyColors.accentPink),
                          label: const Text('Chat', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AisleyColors.accentPink)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const BuyerChatView()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title & Rating
                  Text(
                    widget.product.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
                      height: 1.25,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return const Icon(Icons.star, size: 15, color: Colors.amber);
                            }),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.product.rating} (${widget.product.reviewCount} reviews)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'SKU: ${widget.product.sku}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Price Section
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      Text(
                        AisleyFormatters.formatPhp(_currentPrice),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AisleyColors.accentPink,
                          letterSpacing: -0.6,
                        ),
                      ),
                      if (widget.product.compareAtPrice > widget.product.basePrice) ...[
                        Text(
                          AisleyFormatters.formatPhp(widget.product.compareAtPrice),
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AisleyColors.accentPink.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'SPECIAL ATELIER PRICING',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AisleyColors.accentPink,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Craftsmanship & Story',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Variation: Sizes
                  if (widget.product.sizes.isNotEmpty) ...[
                    const Text(
                      'Select Size / Dimensions',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: widget.product.sizes.map((s) {
                        final isSelected = _selectedSize == s;
                        return ChoiceChip(
                          label: Text(s),
                          selected: isSelected,
                          selectedColor: AisleyColors.pinkTint,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? AisleyColors.accentPink : (isDark ? Colors.white : AisleyColors.textDarkPrimary),
                          ),
                          side: BorderSide(
                            color: isSelected ? AisleyColors.accentPink : (isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder),
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedSize = s);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Variation: Colors
                  if (widget.product.colors.isNotEmpty) ...[
                    const Text(
                      'Select Color / Finish',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: widget.product.colors.map((c) {
                        final isSelected = _selectedColor == c;
                        return ChoiceChip(
                          label: Text(c),
                          selected: isSelected,
                          selectedColor: AisleyColors.pinkTint,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? AisleyColors.accentPink : (isDark ? Colors.white : AisleyColors.textDarkPrimary),
                          ),
                          side: BorderSide(
                            color: isSelected ? AisleyColors.accentPink : (isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder),
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedColor = c);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Quantity Stepper
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Quantity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                            Text(
                              '${widget.product.stock} items remaining in atelier stock',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: _quantity < widget.product.stock ? () => setState(() => _quantity++) : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Authenticity & White Glove Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AisleyColors.accentPink.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AisleyColors.accentPink.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: AisleyColors.accentPink, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Aisley Authenticity & White-Glove Guarantee',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AisleyColors.accentPink),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Direct from verified Philippine atelier. Insured courier dispatch with tracking and complimentary gift presentation.',
                                style: TextStyle(fontSize: 11, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Customer Reviews & Ratings Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Clientele Reviews',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -0.3),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.product.rating} / 5.0',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (widget.product.reviews.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark ? AisleyColors.obsidianSurface : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Be the first to review this atelier masterpiece.', style: TextStyle(fontSize: 12)),
                    )
                  else
                    Column(
                      children: widget.product.reviews.map((rev) => _buildReviewCard(rev, isDark)).toList(),
                    ),
                  const SizedBox(height: 28),

                  // Suggested Products ("You May Also Like")
                  if (suggestedProducts.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'You May Also Like',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -0.3),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: suggestedProducts.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, idx) {
                          final p = suggestedProducts[idx];
                          return _buildSuggestedProductCard(context, p, isDark);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AisleyColors.obsidianSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Concierge Inquiry Button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  tooltip: 'Concierge Inquiry',
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: AisleyColors.accentPink),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BuyerChatView()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AisleyButton(
                  text: 'Add to Bag',
                  variant: AisleyButtonVariant.outline,
                  leadingIcon: Icons.shopping_bag_outlined,
                  onPressed: () {
                    state.addToCart(
                      widget.product,
                      variant: _matchedVariant,
                      size: _selectedSize,
                      color: _selectedColor,
                      quantity: _quantity,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${widget.product.title} to your bag!'),
                        backgroundColor: AisleyColors.emeraldSuccess,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AisleyButton(
                  text: 'Direct Purchase',
                  leadingIcon: Icons.credit_card_rounded,
                  onPressed: () {
                    state.addToCart(
                      widget.product,
                      variant: _matchedVariant,
                      size: _selectedSize,
                      color: _selectedColor,
                      quantity: _quantity,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(ProductReview review, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AisleyColors.obsidianSurface : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AisleyNetworkImage(
                imageUrl: review.authorAvatar,
                width: 32,
                height: 32,
                borderRadius: BorderRadius.circular(16),
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.authorName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                        ),
                        if (review.isVerifiedBuyer) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.check_circle, size: 12, color: AisleyColors.emeraldSuccess),
                        ],
                      ],
                    ),
                    if (review.variantPurchased != null)
                      Text(
                        review.variantPurchased!,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                review.date,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 13,
                color: index < review.rating.round() ? Colors.amber : Colors.grey.shade300,
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : AisleyColors.textDarkPrimary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedProductCard(BuildContext context, Product p, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: p),
          ),
        );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: isDark ? AisleyColors.obsidianSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AisleyNetworkImage(
              imageUrl: p.imageUrl,
              width: 140,
              height: 120,
              fit: BoxFit.cover,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.boutiqueName,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AisleyFormatters.formatPhp(p.basePrice),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AisleyColors.accentPink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/models/product.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/aisley_button.dart';
import '../../core/widgets/aisley_image.dart';
import '../../core/widgets/status_badge.dart';
import '../../state/buyer_state.dart';

class ProductDetailSheet extends StatefulWidget {
  final Product product;

  const ProductDetailSheet({super.key, required this.product});

  @override
  State<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<ProductDetailSheet> {
  late String _selectedSize;
  late String _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes[0] : '';
    _selectedColor = widget.product.colors.isNotEmpty ? widget.product.colors[0] : '';
  }

  ProductVariant? get _matchedVariant {
    if (widget.product.variants.isEmpty) return null;
    try {
      return widget.product.variants.firstWhere(
        (v) =>
            v.name.toLowerCase().contains(_selectedSize.toLowerCase()) ||
            v.name.toLowerCase().contains(_selectedColor.toLowerCase()),
      );
    } catch (_) {
      return widget.product.variants.first;
    }
  }

  double get _currentPrice => _matchedVariant?.price ?? widget.product.basePrice;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AisleyColors.obsidianSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AisleyColors.obsidianBorder : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Product Hero Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AisleyNetworkImage(
                imageUrl: widget.product.imageUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Boutique and category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.boutiqueName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AisleyColors.accentPink,
                        ),
                      ),
                      StatusBadge(
                        label: '${widget.product.rating} ★ (${widget.product.reviewCount})',
                        type: BadgeType.neutral,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    widget.product.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Row(
                    children: [
                      Text(
                        AisleyFormatters.formatPhp(_currentPrice),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AisleyColors.accentPink,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (widget.product.compareAtPrice > _currentPrice) ...[
                        const SizedBox(width: 8),
                        Text(
                          AisleyFormatters.formatPhp(widget.product.compareAtPrice),
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sizes selector
                  if (widget.product.sizes.isNotEmpty) ...[
                    const Text(
                      'Select Size / Option',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
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
                    const SizedBox(height: 14),
                  ],

                  // Colors selector
                  if (widget.product.colors.isNotEmpty) ...[
                    const Text(
                      'Select Color / Finish',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
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

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                          ),
                        ),
                        child: Row(
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
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Actions: Add to Cart & Buy Now
                  Row(
                    children: [
                      Expanded(
                        child: AisleyButton(
                          text: 'Add to Cart',
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
                            Navigator.of(context).pop();
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: AisleyButton(
                          text: 'Direct Purchase',
                          leadingIcon: Icons.credit_card_outlined,
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

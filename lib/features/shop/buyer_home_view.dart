import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/models/product.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/aisley_image.dart';
import '../../core/widgets/status_badge.dart';
import '../../state/buyer_state.dart';
import 'product_detail_sheet.dart';

class BuyerHomeView extends StatelessWidget {
  const BuyerHomeView({super.key});

  final List<String> _categories = const [
    'All',
    'Apparel & Haute Couture',
    'Fine Jewelry & Metals',
    'Artisanal Leather',
    'Botanical Fragrances',
    'Handcrafted Ceramics',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);
    final products = state.products;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AisleyColors.accentPink,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.diamond_outlined, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text('AISLEY', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                onChanged: (val) => state.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search luxury blazers, fine jewelry, leather...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: AisleyColors.accentPink),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => state.setSearchQuery(''),
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AisleyColors.obsidianSurface : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Lookbook Hero Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: AisleyColors.accentPink.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      StatusBadge(
                        label: 'VERIFIED PHILIPPINE ATELIERS',
                        type: BadgeType.pink,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Haute Couture &\nArtisanal Lifestyle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Direct from master artisans in Makati, Marikina, Cebu & Ilocos with insured white-glove courier fulfillment.',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category Pills
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = state.selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AisleyColors.pinkTint,
                    backgroundColor: isDark ? AisleyColors.obsidianSurface : Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AisleyColors.accentPink : (isDark ? Colors.white : AisleyColors.textDarkPrimary),
                    ),
                    side: BorderSide(
                      color: isSelected ? AisleyColors.accentPink : (isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder),
                    ),
                    onSelected: (val) {
                      if (val) state.setSelectedCategory(cat);
                    },
                  );
                },
              ),
            ),
          ),

          // Products Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.selectedCategory == 'All' ? 'Curated Collection' : state.selectedCategory,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    '${products.length} Items Available',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Grid
          if (products.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(40),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, size: 48, color: AisleyColors.lightTextMuted),
                    const SizedBox(height: 12),
                    const Text(
                      'No luxury items match your query.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () {
                        state.setSearchQuery('');
                        state.setSelectedCategory('All');
                      },
                      child: const Text('Reset Search Filters', style: TextStyle(color: AisleyColors.accentPink)),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.64,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return _buildProductCard(context, product, isDark);
                  },
                  childCount: products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, bool isDark) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ProductDetailSheet(product: product),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AisleyColors.obsidianSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with boutique badge
            Expanded(
              child: Stack(
                children: [
                  AisleyNetworkImage(
                    imageUrl: product.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.boutiqueName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, size: 14, color: AisleyColors.accentPink),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AisleyFormatters.formatPhp(product.basePrice),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AisleyColors.accentPink,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AisleyColors.accentPink.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.add_shopping_cart, size: 13, color: AisleyColors.accentPink),
                      ),
                    ],
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

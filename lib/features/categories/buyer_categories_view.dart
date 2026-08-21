import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../state/buyer_state.dart';

class CategoryItemData {
  final String title;
  final String description;
  final String itemCount;
  final String imageUrl;

  const CategoryItemData({
    required this.title,
    required this.description,
    required this.itemCount,
    required this.imageUrl,
  });
}

class BuyerCategoriesView extends StatelessWidget {
  final ValueChanged<int>? onNavigateToTab;

  const BuyerCategoriesView({super.key, this.onNavigateToTab});

  final List<CategoryItemData> _categories = const [
    CategoryItemData(
      title: 'Apparel & Haute Couture',
      description: 'Structured raw silk blazers, handwoven inabel gowns, contemporary Filipiniana.',
      itemCount: '24 Curated Pieces',
      imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&auto=format&fit=crop&q=80',
    ),
    CategoryItemData(
      title: 'Silks & Handwoven Textiles',
      description: 'Mulberry silk scarves, Hablon wraps, Yakan artisanal weaves.',
      itemCount: '16 Curated Pieces',
      imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=600&auto=format&fit=crop&q=80',
    ),
    CategoryItemData(
      title: 'Fine Jewelry & Metals',
      description: 'Solid 925 silver cuffs, 18k gold vermeil, South Sea baroque pearls.',
      itemCount: '32 Curated Pieces',
      imageUrl: 'https://images.unsplash.com/photo-1611591475837-77565e3cf758?w=600&auto=format&fit=crop&q=80',
    ),
    CategoryItemData(
      title: 'Artisanal Leather',
      description: 'Full-grain calfskin bags, hand-stitched Marikina boots, cardholders.',
      itemCount: '19 Curated Pieces',
      imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80',
    ),
    CategoryItemData(
      title: 'Botanical Fragrances',
      description: 'Philippine sampaguita enfleurage, sandalwood, extrait de parfum.',
      itemCount: '11 Curated Pieces',
      imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=600&auto=format&fit=crop&q=80',
    ),
    CategoryItemData(
      title: 'Handcrafted Ceramics',
      description: 'Wood-fired terracotta vessels, reduction stoneware, studio pottery.',
      itemCount: '8 Curated Pieces',
      imageUrl: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=600&auto=format&fit=crop&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories & Ateliers'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return InkWell(
            onTap: () {
              state.setSelectedCategory(cat.title);
              onNavigateToTab?.call(0); // Switch to Discovery / Shop tab
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(cat.imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.55),
                    BlendMode.darken,
                  ),
                ),
                border: Border.all(
                  color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AisleyColors.accentPink,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      cat.itemCount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cat.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../state/buyer_state.dart';
import 'account/buyer_account_view.dart';
import 'cart/buyer_cart_view.dart';
import 'categories/buyer_categories_view.dart';
import 'chat/buyer_chat_view.dart';
import 'orders/buyer_orders_view.dart';
import 'shop/buyer_home_view.dart';

class BuyerMainNavigation extends StatefulWidget {
  const BuyerMainNavigation({super.key});

  @override
  State<BuyerMainNavigation> createState() => _BuyerMainNavigationState();
}

class _BuyerMainNavigationState extends State<BuyerMainNavigation> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);

    final List<Widget> pages = [
      BuyerHomeView(
        onOpenChat: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BuyerChatView()),
        ),
        onOpenCategories: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BuyerCategoriesView()),
        ),
      ),
      BuyerCartView(onNavigateToTab: _onTabTapped),
      const BuyerOrdersView(),
      BuyerAccountView(onNavigateToTab: _onTabTapped),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AisleyColors.obsidianSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTabTapped,
            backgroundColor: Colors.transparent,
            indicatorColor: AisleyColors.accentPink.withValues(alpha: 0.15),
            elevation: 0,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront, color: AisleyColors.accentPink),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: state.cartBadgeCount > 0,
                  label: Text('${state.cartBadgeCount}'),
                  backgroundColor: AisleyColors.accentPink,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: state.cartBadgeCount > 0,
                  label: Text('${state.cartBadgeCount}'),
                  backgroundColor: AisleyColors.accentPink,
                  child: const Icon(Icons.shopping_bag, color: AisleyColors.accentPink),
                ),
                label: 'Cart',
              ),
              const NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long, color: AisleyColors.accentPink),
                label: 'Orders',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: AisleyColors.accentPink),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

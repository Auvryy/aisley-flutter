import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/models/order.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/aisley_image.dart';
import '../../core/widgets/status_badge.dart';
import '../../state/buyer_state.dart';
import 'rate_feedback_modal.dart';

class BuyerOrdersView extends StatefulWidget {
  const BuyerOrdersView({super.key});

  @override
  State<BuyerOrdersView> createState() => _BuyerOrdersViewState();
}

class _BuyerOrdersViewState extends State<BuyerOrdersView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'All',
    'To Ship',
    'In Transit',
    'Out for Delivery',
    'Delivered',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BuyerOrder> _filterOrders(List<BuyerOrder> orders, int tabIndex) {
    if (tabIndex == 0) return orders;
    switch (tabIndex) {
      case 1:
        return orders.where((o) => o.status == OrderStatus.toShip).toList();
      case 2:
        return orders.where((o) => o.status == OrderStatus.inTransit).toList();
      case 3:
        return orders.where((o) => o.status == OrderStatus.outForDelivery).toList();
      case 4:
        return orders.where((o) => o.status == OrderStatus.delivered).toList();
      default:
        return orders;
    }
  }

  void _showTrackingTimeline(BuyerOrder order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? AisleyColors.obsidianSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AisleyColors.obsidianBorder : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Tracking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
                    ),
                  ),
                  StatusBadge(
                    label: order.courierName,
                    type: BadgeType.info,
                    icon: Icons.local_shipping_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Tracking No: ${order.trackingNumber}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AisleyColors.accentPink),
              ),
              const Divider(height: 24),

              // Milestones
              ...order.timeline.asMap().entries.map((entry) {
                final idx = entry.key;
                final milestone = entry.value;
                final isLast = idx == order.timeline.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: milestone.isCompleted ? AisleyColors.emeraldSuccess : const Color(0xFFE2E8F0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            milestone.isCompleted ? Icons.check : Icons.schedule,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 36,
                            color: milestone.isCompleted ? AisleyColors.emeraldSuccess : const Color(0xFFE2E8F0),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            milestone.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            milestone.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            milestone.timestamp,
                            style: const TextStyle(fontSize: 10, color: AisleyColors.accentPink, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History & Tracking'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AisleyColors.accentPink,
          unselectedLabelColor: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
          indicatorColor: AisleyColors.accentPink,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_tabs.length, (tabIdx) {
          final filtered = _filterOrders(state.orders, tabIdx);
          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 56, color: AisleyColors.lightTextMuted),
                  const SizedBox(height: 12),
                  Text(
                    'No orders in "${_tabs[tabIdx]}" status.',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final order = filtered[index];
              return _buildOrderCard(context, order, isDark);
            },
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, BuyerOrder order, bool isDark) {
    BadgeType badgeType;
    switch (order.status) {
      case OrderStatus.delivered:
        badgeType = BadgeType.success;
        break;
      case OrderStatus.inTransit:
      case OrderStatus.outForDelivery:
        badgeType = BadgeType.info;
        break;
      case OrderStatus.toShip:
        badgeType = BadgeType.warning;
        break;
      case OrderStatus.cancelled:
        badgeType = BadgeType.danger;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AisleyColors.obsidianSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Number & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              StatusBadge(
                label: order.status.displayName,
                type: badgeType,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Placed on ${order.createdAt} • ${order.paymentMethod}',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
            ),
          ),
          const Divider(height: 20),

          // Items List
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  AisleyNetworkImage(
                    imageUrl: item.imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          '${item.boutiqueName} • ${item.variantDescription}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${item.quantity}x ${AisleyFormatters.formatPhp(item.unitPrice)}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            );
          }),

          const Divider(height: 16),

          // Total & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grand Total',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    AisleyFormatters.formatPhp(order.totalAmount),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AisleyColors.accentPink,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      side: BorderSide(color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder),
                    ),
                    icon: const Icon(Icons.timeline, size: 14),
                    label: const Text('Track', style: TextStyle(fontSize: 12)),
                    onPressed: () => _showTrackingTimeline(order),
                  ),
                  if (order.status == OrderStatus.delivered) ...[
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AisleyColors.accentPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      icon: const Icon(Icons.star_rate_rounded, size: 14),
                      label: Text(
                        order.review != null ? 'Review (${order.review!.rating.toInt()}★)' : 'Rate',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => RateFeedbackModal(order: order),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

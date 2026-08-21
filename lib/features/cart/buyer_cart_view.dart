import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/data/mock_buyer_data.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/aisley_button.dart';
import '../../core/widgets/aisley_image.dart';
import '../../state/buyer_state.dart';
import 'checkout_modal.dart';

class BuyerCartView extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const BuyerCartView({super.key, this.onNavigateToTab});

  @override
  State<BuyerCartView> createState() => _BuyerCartViewState();
}

class _BuyerCartViewState extends State<BuyerCartView> {
  final TextEditingController _voucherController = TextEditingController();

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  void _applyVoucher(BuyerState state, String code) {
    final success = state.applyVoucher(code);
    if (success) {
      _voucherController.text = code;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voucher "$code" applied successfully!'),
          backgroundColor: AisleyColors.emeraldSuccess,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid voucher code "$code" or min spend not met.'),
          backgroundColor: AisleyColors.roseDanger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);
    final items = state.cartItems;
    final allSelected = items.isNotEmpty && items.every((i) => i.isSelected);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Bag (${state.cartBadgeCount})'),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 64, color: AisleyColors.lightTextMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'Your shopping bag is empty.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Explore our curated luxury ateliers and haute couture.',
                    style: TextStyle(fontSize: 12, color: AisleyColors.lightTextMuted),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: AisleyButton(
                      text: 'Explore Catalog',
                      onPressed: () => widget.onNavigateToTab?.call(0),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Select All Header
                  Row(
                    children: [
                      Checkbox(
                        value: allSelected,
                        activeColor: AisleyColors.accentPink,
                        onChanged: (val) => state.toggleSelectAllCart(val ?? false),
                      ),
                      Text(
                        'Select All (${items.length} Items)',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Cart Items List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AisleyColors.obsidianSurface : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: item.isSelected,
                              activeColor: AisleyColors.accentPink,
                              onChanged: (_) => state.toggleCartItemSelection(item.id),
                            ),
                            AisleyNetworkImage(
                              imageUrl: item.product.imageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.boutiqueName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AisleyColors.accentPink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.variantDescription,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AisleyFormatters.formatPhp(item.unitPrice),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: AisleyColors.accentPink,
                                        ),
                                      ),
                                      // Quantity counter
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () => state.updateCartItemQuantity(item.id, -1),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                child: Icon(Icons.remove, size: 14),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 6),
                                              child: Text(
                                                '${item.quantity}',
                                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => state.updateCartItemQuantity(item.id, 1),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                child: Icon(Icons.add, size: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Voucher Input & Promos
                  Container(
                    padding: const EdgeInsets.all(14),
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
                        const Text(
                          'Promotions & Boutique Vouchers',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _voucherController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter promo code e.g. AISLEY15',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AisleyColors.accentPink,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              onPressed: () => _applyVoucher(state, _voucherController.text),
                              child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: MOCK_VOUCHERS.map((v) {
                            final isApplied = state.appliedVoucher?.id == v.id;
                            return ActionChip(
                              label: Text('${v.code} (${v.discountType.name == 'percentage' ? '${v.discountValue.toInt()}%' : '₱${v.discountValue.toInt()}'} OFF)'),
                              backgroundColor: isApplied ? AisleyColors.pinkTint : null,
                              labelStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: isApplied ? AisleyColors.accentPink : null,
                              ),
                              onPressed: () => _applyVoucher(state, v.code),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Summary Breakdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AisleyColors.obsidianSurface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', AisleyFormatters.formatPhp(state.cartSubtotal), isDark),
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'Insured Delivery',
                          state.cartShippingFee == 0 ? 'FREE (Complimentary)' : AisleyFormatters.formatPhp(state.cartShippingFee),
                          isDark,
                        ),
                        if (state.cartVoucherDiscount > 0) ...[
                          const SizedBox(height: 6),
                          _buildSummaryRow(
                            'Voucher Discount (${state.appliedVoucher?.code})',
                            '- ${AisleyFormatters.formatPhp(state.cartVoucherDiscount)}',
                            isDark,
                            highlight: true,
                          ),
                        ],
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Grand Total',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              AisleyFormatters.formatPhp(state.cartGrandTotal),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AisleyColors.accentPink,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Checkout Button
                  AisleyButton(
                    text: 'Proceed to Checkout (${AisleyFormatters.formatPhp(state.cartGrandTotal)})',
                    trailingIcon: Icons.arrow_forward_rounded,
                    onPressed: state.cartSubtotal > 0
                        ? () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => CheckoutModal(
                                onOrderPlaced: widget.onNavigateToTab,
                              ),
                            );
                          }
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryRow(String title, String value, bool isDark, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: highlight ? AisleyColors.emeraldSuccess : (isDark ? Colors.white : AisleyColors.textDarkPrimary),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/models/address.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/aisley_button.dart';
import '../../state/buyer_state.dart';

class CheckoutModal extends StatefulWidget {
  final ValueChanged<int>? onOrderPlaced;

  const CheckoutModal({super.key, this.onOrderPlaced});

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  String _selectedPaymentMethod = 'GCash';
  final TextEditingController _notesController = TextEditingController();
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'GCash',
      'name': 'GCash (Philippine e-Wallet)',
      'desc': 'Instant VIP mobile authorization',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'id': 'Maya',
      'name': 'Maya (PayMaya)',
      'desc': 'Digital wallet & Maya credit',
      'icon': Icons.wallet_outlined,
    },
    {
      'id': 'Credit Card',
      'name': 'Credit / Debit Card (Visa, Mastercard)',
      'desc': 'Secure 3D-Secure payment',
      'icon': Icons.credit_card_outlined,
    },
    {
      'id': 'COD',
      'name': 'Cash on Delivery (White Glove)',
      'desc': 'Pay courier upon doorstep inspection',
      'icon': Icons.local_shipping_outlined,
    },
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder(BuyerState state) {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      final address = state.currentBuyer?.address ??
          const PhilippineAddress(
            province: 'Metro Manila (NCR)',
            city: 'Makati City',
            barangay: 'Forbes Park',
            street: '28 Narra Avenue',
            houseNumber: 'Villa 14',
            postalCode: '1200',
          );

      final order = state.placeOrder(
        paymentMethod: _selectedPaymentMethod,
        deliveryAddress: address,
        notes: _notesController.text.trim(),
      );

      Navigator.of(context).pop(); // Close checkout modal

      // Show success dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: AisleyColors.emeraldSuccess, size: 28),
              SizedBox(width: 10),
              Text('Order Confirmed!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Ref: ${order.orderNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Tracking: ${order.trackingNumber}', style: const TextStyle(fontSize: 12, color: AisleyColors.lightTextMuted)),
              const SizedBox(height: 8),
              Text('Amount Paid: ${AisleyFormatters.formatPhp(order.totalAmount)} (${order.paymentMethod})'),
              const SizedBox(height: 12),
              const Text(
                'Your parcel has been routed to the atelier for luxury inspection & packaging.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AisleyColors.accentPink,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                widget.onOrderPlaced?.call(2); // Switch to Orders tab (index 2)
              },
              child: const Text('View Order Tracking'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);
    final address = state.currentBuyer?.address;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AisleyColors.obsidianSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Confirm & Checkout',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.4),
                      ),
                      Text(
                        AisleyFormatters.formatPhp(state.cartGrandTotal),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AisleyColors.accentPink),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Delivery Address Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
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
                            const Icon(Icons.location_on_outlined, size: 16, color: AisleyColors.accentPink),
                            const SizedBox(width: 6),
                            const Text(
                              'White Glove Delivery Destination',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state.currentBuyer?.fullName ?? 'Sophia Rustia',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          address?.formattedAddress ?? '28 Narra Avenue, Forbes Park, Makati City, Metro Manila, 1200',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Method Selector
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: _paymentMethods.map((m) {
                      final isSelected = _selectedPaymentMethod == m['id'];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: isSelected
                              ? AisleyColors.pinkTint
                              : (isDark ? const Color(0xFF1E293B) : Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? AisleyColors.accentPink
                                  : (isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => setState(() => _selectedPaymentMethod = m['id']),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                    color: isSelected
                                        ? AisleyColors.accentPink
                                        : (isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(m['icon'] as IconData, size: 20, color: isSelected ? AisleyColors.accentPink : null),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m['name'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: isSelected
                                                ? AisleyColors.accentPink
                                                : (isDark ? Colors.white : AisleyColors.textDarkPrimary),
                                          ),
                                        ),
                                        Text(
                                          m['desc'],
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),

                  // Notes for boutique/courier
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      hintText: 'Special delivery or gift packaging instructions...',
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Authorize button
                  AisleyButton(
                    text: 'Authorize & Place Order (${AisleyFormatters.formatPhp(state.cartGrandTotal)})',
                    isLoading: _isProcessing,
                    trailingIcon: Icons.lock_outline,
                    onPressed: () => _handlePlaceOrder(state),
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

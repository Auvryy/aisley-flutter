import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/models/order.dart';
import '../../core/widgets/aisley_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../state/buyer_state.dart';

class BuyerAccountView extends StatelessWidget {
  final ValueChanged<int>? onNavigateToTab;

  const BuyerAccountView({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);
    final buyer = state.currentBuyer;

    final toShipCount = state.orders.where((o) => o.status == OrderStatus.toShip).length;
    final inTransitCount = state.orders.where((o) => o.status == OrderStatus.inTransit).length;
    final deliveredCount = state.orders.where((o) => o.status == OrderStatus.delivered).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Header Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AisleyColors.obsidianSurface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      buyer?.avatarUrl ??
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              buyer?.fullName ?? 'Sophia Rustia',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          buyer?.email ?? 'sophia.rustia@luxmail.ph',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            StatusBadge(
                              label: 'Admin Verified Buyer',
                              type: BadgeType.success,
                              icon: Icons.verified_user,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order Metrics Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                color: isDark ? AisleyColors.obsidianSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricItem('To Ship', '$toShipCount', Icons.inventory_2_outlined, isDark, () {
                    onNavigateToTab?.call(3);
                  }),
                  _buildMetricDivider(isDark),
                  _buildMetricItem('In Transit', '$inTransitCount', Icons.local_shipping_outlined, isDark, () {
                    onNavigateToTab?.call(3);
                  }),
                  _buildMetricDivider(isDark),
                  _buildMetricItem('Delivered', '$deliveredCount', Icons.check_circle_outline, isDark, () {
                    onNavigateToTab?.call(3);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Saved Philippine Address & KYC ID Verification Details
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Identity & Delivery Records',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  _buildRecordTile(
                    icon: Icons.location_on_outlined,
                    title: 'Registered Shipping Address',
                    subtitle: buyer?.address.formattedAddress ??
                        '28 Narra Avenue, Forbes Park, Makati City, Metro Manila, 1200',
                    isDark: isDark,
                  ),
                  const Divider(height: 16),
                  _buildRecordTile(
                    icon: Icons.badge_outlined,
                    title: 'Government ID Document',
                    subtitle: '${buyer?.kycIdType ?? "Philippine Passport"} (${buyer?.kycIdFileName ?? "passport_sophia.pdf"}) • Verified',
                    isDark: isDark,
                  ),
                  const Divider(height: 16),
                  _buildRecordTile(
                    icon: Icons.phone_android_outlined,
                    title: 'Authenticated Phone',
                    subtitle: buyer?.contactNo ?? '+63 917 882 9901',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // App Preferences & Theme Switcher
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Preferences',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: Colors.transparent,
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AisleyColors.accentPink,
                      title: const Text('Obsidian Noir Dark Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        isDark ? 'Dark Mode Active' : 'Light Canvas Active',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                        ),
                      ),
                      value: isDark,
                      onChanged: (_) => state.toggleTheme(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Prototype State Switchers & Reset
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prototype Test Controls',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AisleyColors.accentPink),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AisleyColors.amberWarning),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {
                            state.simulateAdminPending();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Switched to Pending Admin Review status.'),
                                backgroundColor: AisleyColors.amberWarning,
                              ),
                            );
                          },
                          child: const Text('Simulate Pending Review', style: TextStyle(fontSize: 11, color: AisleyColors.amberWarning, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            AisleyButton(
              text: 'Sign Out of Aisley',
              variant: AisleyButtonVariant.danger,
              leadingIcon: Icons.logout_rounded,
              onPressed: () => state.logout(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String count, IconData icon, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 20, color: AisleyColors.accentPink),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricDivider(bool isDark) {
    return Container(
      width: 1,
      height: 32,
      color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
    );
  }

  Widget _buildRecordTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AisleyColors.accentPink),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

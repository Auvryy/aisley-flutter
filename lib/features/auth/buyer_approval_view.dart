import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/aisley_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../state/buyer_state.dart';

class BuyerApprovalView extends StatelessWidget {
  const BuyerApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);
    final buyer = state.currentBuyer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Verification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () => state.logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Warning / Pending Status Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.hourglass_top_rounded, color: AisleyColors.amberWarning, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Application Pending Administrator Approval',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF92400E),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Your buyer registration and uploaded Government ID are currently being reviewed by the Aisley trust & safety team.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFB45309),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Interactive Simulator Card (For testing)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AisleyColors.obsidianSurface : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AisleyColors.accentPink.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bolt, color: AisleyColors.accentPink, size: 18),
                          const SizedBox(width: 6),
                          const Text(
                            'ADMIN APPROVAL SIMULATOR',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: AisleyColors.accentPink,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'As an admin or tester, you can instantly grant verification clearance to inspect the active storefront experience.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AisleyButton(
                        text: 'Simulate Admin Approval (Enter Storefront)',
                        leadingIcon: Icons.check_circle_outline,
                        onPressed: () {
                          state.simulateAdminApproval();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account approved by Administrator! Welcome to Aisley.'),
                              backgroundColor: AisleyColors.emeraldSuccess,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Milestone Progress Tracker
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AisleyColors.obsidianSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verification Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMilestone(
                        step: 1,
                        title: 'Registration Form Received',
                        subtitle: 'Profile data and contact details recorded.',
                        status: 'completed',
                        isDark: isDark,
                      ),
                      _buildMilestone(
                        step: 2,
                        title: 'Identity & Age Validation',
                        subtitle: 'Age threshold (18+) verified against records.',
                        status: 'completed',
                        isDark: isDark,
                      ),
                      _buildMilestone(
                        step: 3,
                        title: 'Administrator Clearance & Compliance',
                        subtitle: 'Admin checking uploaded government identification.',
                        status: 'in_progress',
                        isDark: isDark,
                      ),
                      _buildMilestone(
                        step: 4,
                        title: 'Boutique Storefront & Cart Activation',
                        subtitle: 'Full marketplace access and white-glove ordering.',
                        status: 'pending',
                        isDark: isDark,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Submitted Entity Summary
                if (buyer != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AisleyColors.obsidianSurface : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Submitted Application Data',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const StatusBadge(
                              label: 'Under Review',
                              type: BadgeType.warning,
                              icon: Icons.access_time,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildDataRow('Applicant Name', buyer.fullName, isDark),
                        _buildDataRow('Email', buyer.email, isDark),
                        _buildDataRow('Contact No.', buyer.contactNo, isDark),
                        _buildDataRow('Birthday / Age', '${buyer.birthday} (${buyer.age} yrs old)', isDark),
                        _buildDataRow('Delivery Address', buyer.address.formattedAddress, isDark),
                        _buildDataRow('Government ID', '${buyer.kycIdType} (${buyer.kycIdFileName})', isDark),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMilestone({
    required int step,
    required String title,
    required String subtitle,
    required String status,
    required bool isDark,
    bool isLast = false,
  }) {
    Color iconBg;
    Color iconColor;
    IconData icon;

    if (status == 'completed') {
      iconBg = AisleyColors.emeraldSuccess;
      iconColor = Colors.white;
      icon = Icons.check;
    } else if (status == 'in_progress') {
      iconBg = AisleyColors.amberWarning;
      iconColor = Colors.white;
      icon = Icons.hourglass_top_rounded;
    } else {
      iconBg = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
      iconColor = isDark ? const Color(0xFF64748B) : Colors.white;
      icon = Icons.lock_outline;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: iconColor),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: status == 'completed'
                    ? AisleyColors.emeraldSuccess
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
                ),
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
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

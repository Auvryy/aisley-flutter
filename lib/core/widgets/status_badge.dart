import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum BadgeType {
  success,
  warning,
  info,
  danger,
  neutral,
  pink,
}

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? icon;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.neutral,
    this.icon,
    this.fontSize = 11.0,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;

    switch (type) {
      case BadgeType.success:
        bg = const Color(0xFFECFDF5);
        fg = AisleyColors.emeraldSuccess;
        border = const Color(0xFFA7F3D0);
        break;
      case BadgeType.warning:
        bg = const Color(0xFFFFFBEB);
        fg = AisleyColors.amberWarning;
        border = const Color(0xFFFDE68A);
        break;
      case BadgeType.info:
        bg = const Color(0xFFF0F9FF);
        fg = AisleyColors.electricSky;
        border = const Color(0xFFBAE6FD);
        break;
      case BadgeType.danger:
        bg = const Color(0xFFFFF1F2);
        fg = AisleyColors.roseDanger;
        border = const Color(0xFFFECDD3);
        break;
      case BadgeType.pink:
        bg = AisleyColors.pinkTint;
        fg = AisleyColors.accentPink;
        border = const Color(0xFFFBCFE8);
        break;
      case BadgeType.neutral:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        border = const Color(0xFFCBD5E1);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum AisleyButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

class AisleyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AisleyButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double borderRadius;

  const AisleyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AisleyButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 50.0,
    this.borderRadius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case AisleyButtonVariant.primary:
        backgroundColor = AisleyColors.accentPink;
        foregroundColor = Colors.white;
        break;
      case AisleyButtonVariant.secondary:
        backgroundColor = isDark ? AisleyColors.obsidianBorder : const Color(0xFFE2E8F0);
        foregroundColor = isDark ? AisleyColors.textLightPrimary : AisleyColors.textDarkPrimary;
        break;
      case AisleyButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark ? Colors.white : AisleyColors.textDarkPrimary;
        borderSide = BorderSide(
          color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
          width: 1.5,
        );
        break;
      case AisleyButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = AisleyColors.accentPink;
        break;
      case AisleyButtonVariant.danger:
        backgroundColor = AisleyColors.roseDanger;
        foregroundColor = Colors.white;
        break;
    }

    final childContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18, color: foregroundColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        if (!isLoading && trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 18, color: foregroundColor),
        ],
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: isLoading ? null : onPressed,
        child: childContent,
      ),
    );
  }
}

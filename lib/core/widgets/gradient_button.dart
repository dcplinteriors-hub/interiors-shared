import 'package:flutter/material.dart';

import '../../theme/brand_gradient.dart';

/// The single "molten" call-to-action — a filled button painted with the DCPL
/// brand gradient.
///
/// Use **at most one per screen** (the primary action: Submit, Create, Approve);
/// every other button stays a [FilledButton] (graphite) or [OutlinedButton], so
/// the heat reads as special. Metrics match the themed buttons (48 min height,
/// 10px corners, w600 label) so it lines up cleanly beside them. Pass
/// `onPressed: null` (or `loading: true`) to disable.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.loading = false,
    this.expand = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;

  /// Shows a spinner and blocks taps while an action is in flight.
  final bool loading;

  /// Stretch to the full available width (e.g. a form's submit row).
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final radius = BorderRadius.circular(10);

    final row = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: BrandGradient.horizontal,
          borderRadius: radius,
          boxShadow: enabled
              ? const [
                  BoxShadow(
                    color: Color(0x47ED1C45), // crimson @ ~28%
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: enabled ? onPressed : null,
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: row,
            ),
          ),
        ),
      ),
    );
  }
}

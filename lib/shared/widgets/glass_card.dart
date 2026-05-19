import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Translucent glass surface used everywhere — cards, palette, sheets.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry radius;
  final double blur;
  final Color? tint;
  final Border? border;
  final bool elevated;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = const BorderRadius.all(Radius.circular(18)),
    this.blur = 18,
    this.tint,
    this.border,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ClipRRect(
      borderRadius: radius is BorderRadius
          ? radius as BorderRadius
          : BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint ?? colors.glass,
            borderRadius: radius is BorderRadius
                ? radius as BorderRadius
                : BorderRadius.circular(18),
            border: border ?? Border.all(color: colors.glassEdge),
            boxShadow: elevated
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 32,
                      offset: const Offset(0, 18),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

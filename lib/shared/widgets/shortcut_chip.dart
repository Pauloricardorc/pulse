import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Rendered key like `⌘K` or `G D` — used in tooltips, the palette, the
/// cheatsheet, and inline hints.
class ShortcutChip extends StatelessWidget {
  final String label;
  const ShortcutChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.glass,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: colors.glassEdge),
      ),
      child: Text(
        label,
        style: monoStyle(
          size: 10.5,
          weight: FontWeight.w700,
          color: colors.textSecondary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// macOS uses ⌘; Windows/Linux use Ctrl.
String get cmdKey => Platform.isMacOS ? '⌘' : 'Ctrl';

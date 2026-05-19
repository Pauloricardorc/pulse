import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A breathing neon dot. `null` = pending (amber, slow pulse),
/// `true` = up (mint, calm), `false` = down (coral, faster pulse).
class StatusDot extends StatefulWidget {
  final bool? isUp;
  final double size;
  const StatusDot({super.key, required this.isUp, this.size = 9});

  @override
  State<StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<StatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.isUp == false ? 900 : 2200),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant StatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isUp != widget.isUp) {
      _ctrl.duration =
          Duration(milliseconds: widget.isUp == false ? 900 : 2200);
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color get _color {
    switch (widget.isUp) {
      case true:
        return AppTheme.statusUp;
      case false:
        return AppTheme.statusDown;
      default:
        return AppTheme.statusPending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        final color = _color;
        return SizedBox(
          width: widget.size * 2.2,
          height: widget.size * 2.2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.size + 6 + 4 * t,
                height: widget.size + 6 + 4 * t,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.10 * (1 - t)),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.85),
                      blurRadius: 8 + 4 * t,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

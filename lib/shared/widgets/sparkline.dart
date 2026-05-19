import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Compact, neon-aware sparkline for response time history.
/// Renders as: smooth filled area + bright line + glow + dot on the latest sample.
class Sparkline extends StatelessWidget {
  /// Latencies in ms, ordered oldest → newest. Nulls drawn as gaps.
  final List<int?> values;
  final double height;
  final double width;
  final Color color;
  final bool degraded;

  const Sparkline({
    super.key,
    required this.values,
    this.height = 28,
    this.width = 110,
    this.color = AppTheme.accent,
    this.degraded = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SparkPainter(
          values: values,
          color: degraded ? AppTheme.statusDown : color,
        ),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  final List<int?> values;
  final Color color;
  _SparkPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final nums = values.where((v) => v != null).cast<int>().toList();
    if (nums.isEmpty) return;

    final maxV = nums.reduce((a, b) => a > b ? a : b);
    final minV = nums.reduce((a, b) => a < b ? a : b);
    final span = (maxV - minV).clamp(1, 1 << 30).toDouble();

    double mapX(int i) =>
        values.length == 1 ? size.width / 2 : i / (values.length - 1) * size.width;
    double mapY(int v) => size.height - ((v - minV) / span) * (size.height - 4) - 2;

    final line = Path();
    final area = Path()..moveTo(0, size.height);

    var started = false;
    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      if (v == null) {
        started = false;
        continue;
      }
      final x = mapX(i);
      final y = mapY(v);
      if (!started) {
        line.moveTo(x, y);
        area.lineTo(x, size.height);
        area.lineTo(x, y);
        started = true;
      } else {
        line.lineTo(x, y);
        area.lineTo(x, y);
      }
    }
    area.lineTo(size.width, size.height);
    area.close();

    // Area fill
    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.0),
          ],
        ).createShader(Offset.zero & size),
    );

    // Glow line
    canvas.drawPath(
      line,
      Paint()
        ..color = color.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // Crisp line
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );

    // Dot on the latest sample
    int? lastIdx;
    for (var i = values.length - 1; i >= 0; i--) {
      if (values[i] != null) {
        lastIdx = i;
        break;
      }
    }
    if (lastIdx != null) {
      final p = Offset(mapX(lastIdx), mapY(values[lastIdx]!));
      canvas.drawCircle(p, 4.5, Paint()..color = color.withValues(alpha: 0.25));
      canvas.drawCircle(p, 2.4, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_SparkPainter old) =>
      old.values.length != values.length ||
      old.color != color ||
      !_eq(old.values, values);

  bool _eq(List<int?> a, List<int?> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

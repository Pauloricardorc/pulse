import 'dart:math';
import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Animated mesh-gradient aurora used as the app's signature backdrop.
///
/// Three colored blobs drift slowly across a deep-ink canvas; a final pass
/// flattens them through layered radial gradients so the result looks like
/// a painted glow rather than crisp shapes.
class AuroraBackground extends StatefulWidget {
  final Widget child;
  final double intensity;
  const AuroraBackground({super.key, required this.child, this.intensity = 0.45});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              return CustomPaint(
                painter: _AuroraPainter(
                  t: _ctrl.value,
                  background: colors.background,
                  deep: colors.backgroundDeep,
                  a: colors.auroraA,
                  b: colors.auroraB,
                  c: colors.auroraC,
                  intensity: widget.intensity,
                ),
              );
            },
          ),
        ),
        // Subtle grain over everything
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.025,
              child: CustomPaint(painter: _NoisePainter()),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double t;
  final Color background, deep, a, b, c;
  final double intensity;

  _AuroraPainter({
    required this.t,
    required this.background,
    required this.deep,
    required this.a,
    required this.b,
    required this.c,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base ink with vertical gradient to add depth.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [background, deep],
        ).createShader(rect),
    );

    final w = size.width, h = size.height;
    // Push blobs to the corners so the central reading area stays calm.
    final blobs = <_Blob>[
      _Blob(
        cx: w * (-0.05 + 0.08 * sin(2 * pi * t)),
        cy: h * (-0.05 + 0.05 * cos(2 * pi * t)),
        r: max(w, h) * 0.55,
        color: a,
        opacity: 0.30 * intensity,
      ),
      _Blob(
        cx: w * (1.05 + 0.06 * cos(2 * pi * (t + 0.33))),
        cy: h * (1.08 + 0.05 * sin(2 * pi * (t + 0.33))),
        r: max(w, h) * 0.60,
        color: b,
        opacity: 0.26 * intensity,
      ),
      _Blob(
        cx: w * (1.10 + 0.06 * sin(2 * pi * (t + 0.66))),
        cy: h * (-0.10 + 0.08 * cos(2 * pi * (t + 0.66))),
        r: max(w, h) * 0.45,
        color: c,
        opacity: 0.22 * intensity,
      ),
    ];

    for (final blob in blobs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            blob.color.withValues(alpha: blob.opacity),
            blob.color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(blob.cx, blob.cy),
          radius: blob.r,
        ))
        ..imageFilter = null;
      canvas.drawCircle(Offset(blob.cx, blob.cy), blob.r, paint);
    }

    // Heavy vignette: keeps the reading area calm and dark.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            deep.withValues(alpha: 0.85),
          ],
          stops: const [0.30, 1.0],
          center: Alignment.center,
        ).createShader(rect),
    );

    // Uniform darken pass on top to guarantee text contrast.
    canvas.drawRect(
      rect,
      Paint()..color = deep.withValues(alpha: 0.35),
    );
  }

  @override
  bool shouldRepaint(_AuroraPainter old) =>
      old.t != t ||
      old.background != background ||
      old.deep != deep ||
      old.a != a ||
      old.b != b ||
      old.c != c ||
      old.intensity != intensity;
}

class _Blob {
  final double cx, cy, r, opacity;
  final Color color;
  _Blob({
    required this.cx,
    required this.cy,
    required this.r,
    required this.color,
    required this.opacity,
  });
}

/// Cheap deterministic dot noise — keeps glass surfaces from looking plastic.
class _NoisePainter extends CustomPainter {
  static final _rng = Random(7);
  static final _points = List<Offset>.generate(
    900,
    (_) => Offset(_rng.nextDouble(), _rng.nextDouble()),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (final p in _points) {
      canvas.drawRect(
        Rect.fromLTWH(p.dx * size.width, p.dy * size.height, 1, 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_NoisePainter old) => false;
}

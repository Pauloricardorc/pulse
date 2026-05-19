import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/database_provider.dart';
import '../../features/command_palette/command_palette.dart';
import '../theme/app_theme.dart';
import '../theme/aurora_background.dart';
import 'glass_card.dart';
import 'shortcut_chip.dart';
import 'update_banner.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

    return AuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            _SideNav(active: location),
            Expanded(
              child: Column(
                children: [
                  _TopBar(),
                  const UpdateBanner(),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Side nav ────────────────────────────────────────────────────────────────

class _SideNav extends StatelessWidget {
  final String active;
  const _SideNav({required this.active});

  static const _items = <_NavItem>[
    _NavItem(Icons.dashboard_rounded, 'Dashboard', '/dashboard', 'G D'),
    _NavItem(Icons.hub_rounded, 'Serviços', '/services', 'G S'),
    _NavItem(Icons.warning_amber_rounded, 'Incidentes', '/incidents', 'G I'),
    _NavItem(Icons.webhook_rounded, 'Webhooks', '/webhooks', 'G W'),
  ];

  bool _isActive(String path) => active.startsWith(path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 0, 14),
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(10, 18, 10, 14),
        radius: const BorderRadius.all(Radius.circular(22)),
        child: SizedBox(
          width: 64,
          child: Column(
            children: [
              const _PulseMark(),
              const SizedBox(height: 22),
              for (final item in _items) ...[
                _NavTile(item: item, selected: _isActive(item.path)),
                const SizedBox(height: 6),
              ],
              const Spacer(),
              _NavTile(
                item: const _NavItem(
                    Icons.tune_rounded, 'Preferências', '/settings', 'G P'),
                selected: _isActive('/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String path;
  final String chord;
  const _NavItem(this.icon, this.label, this.path, this.chord);
}

class _NavTile extends StatefulWidget {
  final _NavItem item;
  final bool selected;
  const _NavTile({required this.item, required this.selected});

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final iconColor = widget.selected
        ? AppTheme.accent
        : _hovered
            ? colors.textPrimary
            : colors.textSecondary;

    return Tooltip(
      message: '${widget.item.label}  ·  ${widget.item.chord}',
      preferBelow: false,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.go(widget.item.path),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: widget.selected
                  ? AppTheme.accent.withValues(alpha: 0.12)
                  : _hovered
                      ? colors.glass
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.selected
                    ? AppTheme.accent.withValues(alpha: 0.45)
                    : Colors.transparent,
              ),
              boxShadow: widget.selected
                  ? [
                      BoxShadow(
                        color: AppTheme.accent.withValues(alpha: 0.35),
                        blurRadius: 16,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Icon(widget.item.icon, size: 19, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Brand mark — soft mesh ring with a stroke pulse ────────────────────────

class _PulseMark extends StatefulWidget {
  const _PulseMark();

  @override
  State<_PulseMark> createState() => _PulseMarkState();
}

class _PulseMarkState extends State<_PulseMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => CustomPaint(
          painter: _PulseMarkPainter(_ctrl.value),
        ),
      ),
    );
  }
}

class _PulseMarkPainter extends CustomPainter {
  final double t;
  _PulseMarkPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    const r = 20.0;

    // Mesh-gradient ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = SweepGradient(
          colors: [
            AppTheme.accent,
            AppTheme.accentSpark,
            AppTheme.accent,
          ],
          startAngle: 0,
          endAngle: 6.283,
          transform: GradientRotation(t * 6.283),
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2),
    );

    // Inner core dot
    final pulse = (0.5 + 0.5 * (t < 0.5 ? t * 2 : (1 - t) * 2));
    canvas.drawCircle(
      Offset(cx, cy),
      4 + 1.5 * pulse,
      Paint()..color = AppTheme.accent.withValues(alpha: 0.85),
    );
    canvas.drawCircle(
      Offset(cx, cy),
      4 + 1.5 * pulse,
      Paint()
        ..color = AppTheme.accentSpark.withValues(alpha: 0.6 * pulse)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  @override
  bool shouldRepaint(_PulseMarkPainter old) => old.t != t;
}

// ─── Top bar ─────────────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final services = ref.watch(allServicesProvider).asData?.value ?? const [];
    final envs = ref.watch(allEnvironmentsProvider).asData?.value ?? const [];
    final incidents = ref.watch(openIncidentsProvider).asData?.value ?? const [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 18, 0),
      child: Row(
        children: [
          Text('Pulse',
              style: displayStyle(
                  size: 22,
                  color: colors.textPrimary,
                  weight: FontWeight.w800)),
          const SizedBox(width: 18),
          Text(
            '${services.length} serviços · ${envs.length} ambientes',
            style: bodyStyle(size: 12, color: colors.textMuted),
          ),
          if (incidents.isNotEmpty) ...[
            const SizedBox(width: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.statusDown.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppTheme.statusDown.withValues(alpha: 0.45)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.statusDown,
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.statusDown.withValues(alpha: 0.8),
                            blurRadius: 6),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${incidents.length} incidente${incidents.length == 1 ? '' : 's'}',
                    style: bodyStyle(
                        size: 12,
                        color: AppTheme.statusDown,
                        weight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
          _PaletteTrigger(),
        ],
      ),
    );
  }
}

class _PaletteTrigger extends StatefulWidget {
  @override
  State<_PaletteTrigger> createState() => _PaletteTriggerState();
}

class _PaletteTriggerState extends State<_PaletteTrigger> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => CommandPalette.open(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? colors.glassStrong : colors.glass,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.glassEdge),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded,
                  size: 14, color: colors.textSecondary),
              const SizedBox(width: 8),
              Text('Buscar ou comandos',
                  style: bodyStyle(size: 12, color: colors.textMuted)),
              const SizedBox(width: 14),
              ShortcutChip('$cmdKey K'),
            ],
          ),
        ),
      ),
    );
  }
}

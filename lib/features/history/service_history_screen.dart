import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/metrics_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/status_dot.dart';

class ServiceHistoryScreen extends ConsumerStatefulWidget {
  final int serviceId;
  final int? initialEnvId;

  const ServiceHistoryScreen({
    super.key,
    required this.serviceId,
    this.initialEnvId,
  });

  @override
  ConsumerState<ServiceHistoryScreen> createState() =>
      _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends ConsumerState<ServiceHistoryScreen> {
  int? _selectedEnv;
  Duration _window = const Duration(days: 1);

  @override
  void initState() {
    super.initState();
    _selectedEnv = widget.initialEnvId;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final envs =
        ref.watch(environmentsByServiceProvider(widget.serviceId)).asData?.value ??
            const [];
    final service = ref
        .watch(allServicesProvider)
        .asData
        ?.value
        .where((s) => s.id == widget.serviceId)
        .firstOrNull;

    _selectedEnv ??= envs.isNotEmpty ? envs.first.id : null;
    final env = envs.where((e) => e.id == _selectedEnv).firstOrNull;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: 6),
              Text(service?.name ?? 'Histórico',
                  style: displayStyle(
                      size: 30,
                      color: colors.textPrimary,
                      weight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          if (envs.isEmpty)
            GlassCard(
              padding: const EdgeInsets.all(28),
              child: Text(
                'Adicione um ambiente para ver o histórico.',
                style: bodyStyle(size: 13.5, color: colors.textSecondary),
              ),
            )
          else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: envs
                  .map((e) => _EnvChip(
                        env: e,
                        selected: e.id == _selectedEnv,
                        onTap: () => setState(() => _selectedEnv = e.id),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 18),
            _WindowPicker(
              value: _window,
              onChanged: (v) => setState(() => _window = v),
            ),
            const SizedBox(height: 18),
            if (env != null) ...[
              _MetricsBlock(env: env, window: _window),
              const SizedBox(height: 14),
              _ChartCard(env: env, window: _window),
            ],
          ],
        ],
      ),
    );
  }
}

class _EnvChip extends StatelessWidget {
  final Environment env;
  final bool selected;
  final VoidCallback onTap;
  const _EnvChip({
    required this.env,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final envColor = AppTheme.environmentColor(env.name);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? envColor.withValues(alpha: 0.18)
              : colors.glass,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? envColor.withValues(alpha: 0.55)
                : colors.glassEdge,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(env.name.toUpperCase(),
                style: monoStyle(
                    size: 11,
                    color: selected ? envColor : colors.textPrimary,
                    weight: FontWeight.w800,
                    letterSpacing: 0.6)),
            const SizedBox(width: 8),
            Text(env.url,
                style:
                    monoStyle(size: 10.5, color: colors.textMuted),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _WindowPicker extends StatelessWidget {
  final Duration value;
  final ValueChanged<Duration> onChanged;
  const _WindowPicker({required this.value, required this.onChanged});

  static const _options = <(Duration, String)>[
    (Duration(hours: 1), '1h'),
    (Duration(hours: 24), '24h'),
    (Duration(days: 7), '7d'),
    (Duration(days: 30), '30d'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: _options.map((o) {
        final selected = o.$1 == value;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: GestureDetector(
            onTap: () => onChanged(o.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.accent.withValues(alpha: 0.15)
                    : colors.glass,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? AppTheme.accent.withValues(alpha: 0.5)
                      : colors.glassEdge,
                ),
              ),
              child: Text(o.$2,
                  style: monoStyle(
                      size: 11.5,
                      color: selected
                          ? AppTheme.accent
                          : colors.textPrimary,
                      weight: FontWeight.w700)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MetricsBlock extends ConsumerWidget {
  final Environment env;
  final Duration window;
  const _MetricsBlock({required this.env, required this.window});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync =
        ref.watch(envMetricsProvider((envId: env.id, window: window)));
    return metricsAsync.maybeWhen(
      data: (m) => _MetricsCards(metrics: m),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _MetricsCards extends StatelessWidget {
  final EnvironmentMetrics metrics;
  const _MetricsCards({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _Mini(label: 'CHECKS', value: '${metrics.totalChecks}'),
      _Mini(
          label: 'UPTIME',
          value:
              '${metrics.uptimePct.toStringAsFixed(metrics.uptimePct >= 99 ? 2 : 1)}%',
          color: AppTheme.statusUp),
      _Mini(
          label: 'AVG',
          value: metrics.avgMs == null ? '—' : '${metrics.avgMs}ms',
          color: AppTheme.accent),
      _Mini(
          label: 'P95',
          value: metrics.p95Ms == null ? '—' : '${metrics.p95Ms}ms',
          color: AppTheme.accentSpark),
    ];
    return Row(
      children: cards
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: c,
                ),
              ))
          .toList(),
    );
  }
}

class _Mini extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Mini({
    required this.label,
    required this.value,
    this.color = AppTheme.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: monoStyle(
                  size: 10,
                  color: colors.textMuted,
                  weight: FontWeight.w700,
                  letterSpacing: 1.4)),
          const SizedBox(height: 8),
          Text(value,
              style: displayStyle(
                  size: 22, color: color, weight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ChartCard extends ConsumerWidget {
  final Environment env;
  final Duration window;
  const _ChartCard({required this.env, required this.window});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    return FutureBuilder<List<CheckResult>>(
      future: ref.watch(databaseProvider).getChecksInPeriod(
            env.id,
            DateTime.now().subtract(window),
            DateTime.now(),
          ),
      builder: (context, snapshot) {
        final data = snapshot.data ?? const [];
        if (data.isEmpty) {
          return GlassCard(
            padding: const EdgeInsets.all(28),
            child: Text(
              'Sem checks na janela escolhida.',
              style: bodyStyle(size: 13, color: colors.textSecondary),
            ),
          );
        }
        final df = DateFormat('HH:mm');
        final spots = <FlSpot>[];
        for (var i = 0; i < data.length; i++) {
          final v = data[i].responseTimeMs;
          if (v == null) continue;
          spots.add(FlSpot(i.toDouble(), v.toDouble()));
        }

        return GlassCard(
          padding: const EdgeInsets.fromLTRB(20, 18, 18, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('LATÊNCIA',
                      style: monoStyle(
                          size: 10,
                          color: colors.textMuted,
                          letterSpacing: 1.4,
                          weight: FontWeight.w700)),
                  const Spacer(),
                  Row(children: [
                    StatusDot(isUp: data.last.isUp, size: 7),
                    const SizedBox(width: 6),
                    Text(
                      '${data.length} checks · último ${df.format(data.last.checkedAt.toLocal())}',
                      style: monoStyle(
                          size: 11, color: colors.textSecondary),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 220,
                child: LineChart(LineChartData(
                  minY: 0,
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 100,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: colors.glassEdge,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.18,
                      color: AppTheme.accent,
                      barWidth: 1.6,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.accent.withValues(alpha: 0.35),
                            AppTheme.accent.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

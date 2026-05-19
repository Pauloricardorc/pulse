import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/monitoring_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/sparkline.dart';
import '../../shared/widgets/status_dot.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(allServicesProvider);

    return servicesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (services) => services.isEmpty
          ? const _EmptyState()
          : _Dashboard(services: services),
    );
  }
}

class _Dashboard extends ConsumerWidget {
  final List<Service> services;
  const _Dashboard({required this.services});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEnvs = ref.watch(allEnvironmentsProvider).asData?.value ?? const [];

    int up = 0, down = 0, pending = 0;
    final latencies = <int>[];
    for (final env in allEnvs) {
      final check = ref.watch(latestCheckProvider(env.id)).asData?.value;
      if (check == null) {
        pending++;
      } else {
        if (check.isUp) {
          up++;
        } else {
          down++;
        }
        if (check.responseTimeMs != null) latencies.add(check.responseTimeMs!);
      }
    }
    latencies.sort();
    int? p95;
    if (latencies.isNotEmpty) {
      final idx = (0.95 * (latencies.length - 1)).round();
      p95 = latencies[idx];
    }
    final uptimePct = allEnvs.isEmpty ? 0.0 : (up / allEnvs.length * 100);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(servicesCount: services.length, envCount: allEnvs.length),
          const SizedBox(height: 22),
          _StatsRow(
            online: up,
            down: down,
            pending: pending,
            total: allEnvs.length,
            uptimePct: uptimePct,
            p95Ms: p95,
          ),
          const SizedBox(height: 24),
          Text('SERVIÇOS',
              style: monoStyle(
                  size: 10,
                  color: AppColors.of(context).textMuted,
                  letterSpacing: 1.6,
                  weight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final s in services) ...[
            _ServiceCard(service: s),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  final int servicesCount, envCount;
  const _Header({required this.servicesCount, required this.envCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Visão geral',
                style: displayStyle(
                    size: 36,
                    color: colors.textPrimary,
                    weight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
              'Pulse acompanha $servicesCount serviços e $envCount ambientes em tempo real.',
              style: bodyStyle(size: 13.5, color: colors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        OutlinedButton.icon(
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Recheck'),
          onPressed: () => ref.read(monitoringServiceProvider).recheckAll(),
        ),
      ],
    );
  }
}

// ─── Stats row ───────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int online, down, pending, total;
  final double uptimePct;
  final int? p95Ms;

  const _StatsRow({
    required this.online,
    required this.down,
    required this.pending,
    required this.total,
    required this.uptimePct,
    required this.p95Ms,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            big: '$online',
            small: 'online',
            color: AppTheme.statusUp,
            progress: total == 0 ? 0 : online / total,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            big: '$down',
            small: 'offline',
            color: AppTheme.statusDown,
            progress: total == 0 ? 0 : down / total,
            highlight: down > 0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            big: '${uptimePct.toStringAsFixed(uptimePct >= 99 ? 2 : 1)}%',
            small: 'uptime agora',
            color: AppTheme.accent,
            progress: uptimePct / 100,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            big: p95Ms == null ? '—' : '${p95Ms}ms',
            small: 'p95 latência',
            color: AppTheme.accentSpark,
            progress: p95Ms == null ? 0 : (p95Ms!.clamp(0, 1500) / 1500),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String big, small;
  final Color color;
  final double progress;
  final bool highlight;
  const _StatCard({
    required this.big,
    required this.small,
    required this.color,
    required this.progress,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      border: highlight
          ? Border.all(color: color.withValues(alpha: 0.55))
          : Border.all(color: colors.glassEdge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            small.toUpperCase(),
            style: monoStyle(
                size: 10,
                color: colors.textMuted,
                letterSpacing: 1.6,
                weight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(big,
              style: displayStyle(
                  size: 36, color: color, weight: FontWeight.w800)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 3,
              child: Row(
                children: [
                  Flexible(
                    flex: (progress.clamp(0.0, 1.0) * 1000).round(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        boxShadow: [
                          BoxShadow(
                              color: color.withValues(alpha: 0.7), blurRadius: 6),
                        ],
                      ),
                    ),
                  ),
                  if (progress < 1)
                    Flexible(
                      flex: ((1 - progress.clamp(0.0, 1.0)) * 1000).round(),
                      child: Container(color: colors.glassEdge),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Service card ────────────────────────────────────────────────────────────

class _ServiceCard extends ConsumerWidget {
  final Service service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final envs =
        ref.watch(environmentsByServiceProvider(service.id)).asData?.value ??
            const [];

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
            child: Row(
              children: [
                Text(service.name,
                    style: displayStyle(
                        size: 18,
                        color: colors.textPrimary,
                        weight: FontWeight.w700)),
                if (service.description.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      service.description,
                      overflow: TextOverflow.ellipsis,
                      style: bodyStyle(
                          size: 12.5, color: colors.textMuted),
                    ),
                  ),
                ] else
                  const Spacer(),
                Text(
                  '${envs.length} ambientes',
                  style: monoStyle(
                      size: 11, color: colors.textMuted, letterSpacing: 0.4),
                ),
              ],
            ),
          ),
          Container(height: 1, color: colors.glassEdge),
          if (envs.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Text(
                'Nenhum ambiente configurado.',
                style: bodyStyle(size: 12.5, color: colors.textMuted),
              ),
            )
          else
            for (var i = 0; i < envs.length; i++) ...[
              _EnvRow(env: envs[i]),
              if (i < envs.length - 1)
                Container(height: 1, color: colors.glassEdge),
            ],
        ],
      ),
    );
  }
}

class _EnvRow extends ConsumerStatefulWidget {
  final Environment env;
  const _EnvRow({required this.env});

  @override
  ConsumerState<_EnvRow> createState() => _EnvRowState();
}

class _EnvRowState extends ConsumerState<_EnvRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final env = widget.env;
    final check = ref.watch(latestCheckProvider(env.id)).asData?.value;
    final recent = ref.watch(recentChecksProvider(env.id)).asData?.value ?? const [];
    final envColor = AppTheme.environmentColor(env.name);

    final latencies = recent.reversed.map((c) => c.responseTimeMs).toList();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/history/${env.serviceId}?env=${env.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          color: _hovered ? colors.glass : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            children: [
              StatusDot(isUp: check?.isUp),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: envColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: envColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  env.name.toUpperCase(),
                  style: monoStyle(
                      size: 9.5,
                      color: envColor,
                      weight: FontWeight.w800,
                      letterSpacing: 0.8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  env.url,
                  overflow: TextOverflow.ellipsis,
                  style: monoStyle(size: 11.5, color: colors.textSecondary),
                ),
              ),
              if (latencies.isNotEmpty) ...[
                Sparkline(
                  values: latencies,
                  width: 110,
                  height: 26,
                  color: AppTheme.latencyColor(check?.responseTimeMs),
                  degraded: check?.isUp == false,
                ),
                const SizedBox(width: 14),
              ],
              SizedBox(
                width: 64,
                child: Text(
                  check?.responseTimeMs == null
                      ? '—'
                      : '${check!.responseTimeMs}ms',
                  textAlign: TextAlign.right,
                  style: monoStyle(
                      size: 12,
                      color: AppTheme.latencyColor(check?.responseTimeMs),
                      weight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedOpacity(
                opacity: _hovered ? 1 : 0.3,
                duration: const Duration(milliseconds: 140),
                child: Icon(Icons.chevron_right_rounded,
                    size: 16, color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: GlassCard(
          padding: const EdgeInsets.fromLTRB(36, 38, 36, 32),
          elevated: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accent.withValues(alpha: 0.55),
                      AppTheme.accentSpark.withValues(alpha: 0.45),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.5),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: const Icon(Icons.monitor_heart_rounded,
                    size: 28, color: Colors.white),
              ),
              const SizedBox(height: 22),
              Text('Comece a monitorar',
                  style: displayStyle(
                      size: 26,
                      color: colors.textPrimary,
                      weight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                'Adicione um serviço, configure seus ambientes e o Pulse passa a verificar a saúde deles em tempo real.',
                style: bodyStyle(
                    size: 13.5, color: colors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/services/new'),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Novo serviço'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/import'),
                    child: const Text('Importar workspace'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

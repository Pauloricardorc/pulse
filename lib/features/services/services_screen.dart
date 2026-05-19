import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/monitoring_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import 'service_form_dialog.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final services = ref.watch(allServicesProvider).asData?.value ?? const [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Serviços',
                      style: displayStyle(
                          size: 32,
                          color: colors.textPrimary,
                          weight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    'Cada serviço agrupa ambientes (prod, staging, dev, …).',
                    style: bodyStyle(size: 13, color: colors.textSecondary),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Novo serviço'),
                onPressed: () => context.go('/services/new'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          for (final s in services) ...[
            _ServiceTile(service: s),
            const SizedBox(height: 12),
          ],
          if (services.isEmpty)
            GlassCard(
              padding: const EdgeInsets.all(28),
              child: Text(
                'Nenhum serviço ainda. Crie o primeiro para começar.',
                style: bodyStyle(size: 13.5, color: colors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceTile extends ConsumerWidget {
  final Service service;
  const _ServiceTile({required this.service});

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
            padding: const EdgeInsets.fromLTRB(18, 14, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.name,
                          style: displayStyle(
                              size: 18,
                              color: colors.textPrimary,
                              weight: FontWeight.w700)),
                      if (service.description.isNotEmpty)
                        Text(
                          service.description,
                          style:
                              bodyStyle(size: 12.5, color: colors.textMuted),
                        ),
                    ],
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Ambiente'),
                  onPressed: () => context.go(
                      '/services/${service.id}/environments/new'),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  tooltip: 'Editar serviço',
                  onPressed: () => ServiceFormDialog.show(context, ref,
                      existing: service),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded,
                      size: 16, color: AppTheme.statusDown),
                  tooltip: 'Remover serviço',
                  onPressed: () =>
                      _confirmDelete(context, ref, service),
                ),
              ],
            ),
          ),
          Container(height: 1, color: colors.glassEdge),
          if (envs.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              child: Text(
                'Sem ambientes ainda.',
                style: bodyStyle(size: 12.5, color: colors.textMuted),
              ),
            )
          else
            for (var i = 0; i < envs.length; i++) ...[
              _EnvRow(env: envs[i], service: service),
              if (i < envs.length - 1)
                Container(height: 1, color: colors.glassEdge),
            ],
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Service s) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Remover ${s.name}?'),
        content: const Text(
            'Isso remove o serviço e todos os ambientes, histórico e incidentes vinculados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.statusDown),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                final envs = await ref
                    .read(databaseProvider)
                    .getEnvironmentsByService(s.id);
                for (final env in envs) {
                  ref
                      .read(monitoringServiceProvider)
                      .removeEnvironment(env.id);
                }
                await ref.read(databaseProvider).deleteService(s.id);
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Não consegui remover: $e')),
                );
              }
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}

class _EnvRow extends ConsumerWidget {
  final Environment env;
  final Service service;
  const _EnvRow({required this.env, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final envColor = AppTheme.environmentColor(env.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      child: Row(
        children: [
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(env.url,
                    overflow: TextOverflow.ellipsis,
                    style:
                        monoStyle(size: 11.5, color: colors.textSecondary)),
                Text(
                  '${env.method} · cada ${env.checkIntervalSeconds}s · ${_matcherSummary(env)}',
                  style: bodyStyle(size: 11, color: colors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 14),
            tooltip: 'Checar agora',
            onPressed: () =>
                ref.read(monitoringServiceProvider).checkNow(env),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, size: 14),
            tooltip: 'Editar',
            onPressed: () => context.go(
                '/services/${service.id}/environments/${env.id}'),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                size: 14, color: AppTheme.statusDown),
            tooltip: 'Remover',
            onPressed: () => _confirmDeleteEnv(context, ref, env),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteEnv(BuildContext context, WidgetRef ref, Environment env) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Remover ${env.name}?'),
        content: Text(
          'Remove o ambiente "${env.name}" do serviço "${service.name}", '
          'incluindo todo o histórico e incidentes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.statusDown),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                ref.read(monitoringServiceProvider).removeEnvironment(env.id);
                await ref.read(databaseProvider).deleteEnvironment(env.id);
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Não consegui remover: $e')),
                );
              }
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  String _matcherSummary(Environment e) {
    switch (e.matchType) {
      case 'status':
        return 'status ${e.matchValue}';
      case 'range':
        return 'status ${e.statusRangeFrom}-${e.statusRangeTo}';
      case 'contains':
        return 'contém "${e.matchValue}"';
      case 'regex':
        return 'regex /${e.matchValue}/';
      case 'jsonpath':
        return 'json ${e.matchValue}';
      default:
        return e.matchType;
    }
  }
}

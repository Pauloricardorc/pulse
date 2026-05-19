import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/status_dot.dart';

class IncidentsScreen extends ConsumerWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final incidents = ref.watch(allIncidentsProvider).asData?.value ?? const [];
    final envs = ref.watch(allEnvironmentsProvider).asData?.value ?? const [];
    final services = ref.watch(allServicesProvider).asData?.value ?? const [];

    Service? svcOf(int envId) {
      final env = envs.firstWhere(
        (e) => e.id == envId,
        orElse: () => Environment(
          id: 0, serviceId: 0, name: '?', url: '', role: '',
          method: 'GET', headersJson: '{}', body: '', matchType: 'status',
          matchValue: '200', statusRangeFrom: 200, statusRangeTo: 299,
          timeoutMs: 0, checkIntervalSeconds: 0, isActive: false,
          createdAt: DateTime.now(),
        ),
      );
      return services.where((s) => s.id == env.serviceId).cast<Service?>().firstWhere(
            (e) => true,
            orElse: () => null,
          );
    }

    final open = incidents.where((i) => i.endedAt == null).toList();
    final resolved = incidents.where((i) => i.endedAt != null).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Incidentes',
              style: displayStyle(
                  size: 32,
                  color: colors.textPrimary,
                  weight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            'Cada queda detectada vira um incidente. Resolvido quando o ambiente volta.',
            style: bodyStyle(size: 13, color: colors.textSecondary),
          ),
          const SizedBox(height: 22),
          if (open.isEmpty && resolved.isEmpty)
            GlassCard(
              padding: const EdgeInsets.all(28),
              child: Text(
                'Nenhum incidente registrado.',
                style: bodyStyle(size: 13.5, color: colors.textSecondary),
              ),
            ),
          if (open.isNotEmpty) ...[
            _Section(title: 'ATIVOS', count: open.length),
            const SizedBox(height: 8),
            for (final i in open)
              _IncidentTile(
                incident: i,
                env: envs.firstWhere(
                  (e) => e.id == i.environmentId,
                  orElse: () => _placeholderEnv(),
                ),
                service: svcOf(i.environmentId),
              ),
          ],
          if (resolved.isNotEmpty) ...[
            const SizedBox(height: 18),
            _Section(title: 'RESOLVIDOS', count: resolved.length),
            const SizedBox(height: 8),
            for (final i in resolved)
              _IncidentTile(
                incident: i,
                env: envs.firstWhere(
                  (e) => e.id == i.environmentId,
                  orElse: () => _placeholderEnv(),
                ),
                service: svcOf(i.environmentId),
              ),
          ],
        ],
      ),
    );
  }

  Environment _placeholderEnv() => Environment(
        id: 0, serviceId: 0, name: '—', url: '', role: '',
        method: 'GET', headersJson: '{}', body: '', matchType: 'status',
        matchValue: '200', statusRangeFrom: 200, statusRangeTo: 299,
        timeoutMs: 0, checkIntervalSeconds: 0, isActive: false,
        createdAt: DateTime.now(),
      );
}

class _Section extends StatelessWidget {
  final String title;
  final int count;
  const _Section({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Text(title,
            style: monoStyle(
                size: 10,
                color: colors.textMuted,
                letterSpacing: 1.6,
                weight: FontWeight.w700)),
        const SizedBox(width: 8),
        Text('$count',
            style: monoStyle(
                size: 11, color: colors.textSecondary,
                weight: FontWeight.w700)),
      ],
    );
  }
}

class _IncidentTile extends ConsumerStatefulWidget {
  final Incident incident;
  final Environment env;
  final Service? service;
  const _IncidentTile({
    required this.incident,
    required this.env,
    required this.service,
  });

  @override
  ConsumerState<_IncidentTile> createState() => _IncidentTileState();
}

class _IncidentTileState extends ConsumerState<_IncidentTile> {
  late final _noteCtrl = TextEditingController(text: widget.incident.note);

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  String _format(DateTime d) =>
      DateFormat('dd/MM/yyyy HH:mm:ss').format(d.toLocal());

  String _duration() {
    final end = widget.incident.endedAt ?? DateTime.now();
    final dur = end.difference(widget.incident.startedAt);
    if (dur.inMinutes < 1) return '${dur.inSeconds}s';
    if (dur.inHours < 1) return '${dur.inMinutes}min';
    if (dur.inHours < 24) {
      return '${dur.inHours}h${dur.inMinutes % 60 == 0 ? '' : ' ${dur.inMinutes % 60}min'}';
    }
    return '${dur.inDays}d ${dur.inHours % 24}h';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final i = widget.incident;
    final isOpen = i.endedAt == null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        border: Border.all(
          color: isOpen
              ? AppTheme.statusDown.withValues(alpha: 0.45)
              : colors.glassEdge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusDot(isUp: isOpen ? false : true, size: 8),
                const SizedBox(width: 10),
                Text(
                  '${widget.service?.name ?? '—'} · ${widget.env.name}',
                  style: bodyStyle(
                      size: 14,
                      color: colors.textPrimary,
                      weight: FontWeight.w700),
                ),
                const SizedBox(width: 10),
                Text(_duration(),
                    style: monoStyle(
                        size: 11,
                        color: isOpen
                            ? AppTheme.statusDown
                            : colors.textSecondary,
                        weight: FontWeight.w700)),
                const Spacer(),
                if (isOpen)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.statusDown.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.statusDown.withValues(alpha: 0.45)),
                    ),
                    child: Text('aberto',
                        style: monoStyle(
                            size: 10,
                            color: AppTheme.statusDown,
                            weight: FontWeight.w700,
                            letterSpacing: 1)),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.statusUp.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.statusUp.withValues(alpha: 0.45)),
                    ),
                    child: Text('resolvido',
                        style: monoStyle(
                            size: 10,
                            color: AppTheme.statusUp,
                            weight: FontWeight.w700,
                            letterSpacing: 1)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_format(i.startedAt)}  →  ${i.endedAt == null ? '…' : _format(i.endedAt!)}',
              style: monoStyle(size: 11.5, color: colors.textSecondary),
            ),
            if (i.cause.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Causa: ${i.cause}',
                  style: bodyStyle(
                      size: 12.5, color: colors.textSecondary)),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: _noteCtrl,
              maxLines: 2,
              style: bodyStyle(size: 12.5, color: colors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Adicionar nota (post-mortem, contexto, link…)',
              ),
              onChanged: (v) async {
                await ref
                    .read(databaseProvider)
                    .updateIncidentNote(i.id, v);
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (!i.acknowledged && isOpen)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.visibility_rounded, size: 14),
                    label: const Text('Reconhecer'),
                    onPressed: () => ref
                        .read(databaseProvider)
                        .setIncidentAcknowledged(i.id, true),
                  ),
                if (i.acknowledged && isOpen)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: AppTheme.accent.withValues(alpha: 0.4)),
                    ),
                    child: Text('Reconhecido',
                        style: monoStyle(
                            size: 11, color: AppTheme.accent)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

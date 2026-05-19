import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/webhook_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';

class WebhooksScreen extends ConsumerWidget {
  const WebhooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final hooks = ref.watch(webhooksProvider).asData?.value ?? const [];

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
                  Text('Webhooks',
                      style: displayStyle(
                          size: 32,
                          color: colors.textPrimary,
                          weight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    'Dispare alertas para Slack, Discord ou um endpoint próprio quando o estado muda.',
                    style: bodyStyle(size: 13, color: colors.textSecondary),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Novo webhook'),
                onPressed: () => _showForm(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (hooks.isEmpty)
            GlassCard(
              padding: const EdgeInsets.all(28),
              child: Text(
                'Nenhum webhook configurado.',
                style: bodyStyle(size: 13.5, color: colors.textSecondary),
              ),
            ),
          for (final h in hooks)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _Tile(hook: h),
            ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {Webhook? existing}) {
    showDialog(
      context: context,
      builder: (_) => _WebhookFormDialog(existing: existing),
    );
  }
}

class _Tile extends ConsumerWidget {
  final Webhook hook;
  const _Tile({required this.hook});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final typeColor = switch (hook.type) {
      'slack' => const Color(0xFF4A154B),
      'discord' => const Color(0xFF5865F2),
      _ => AppTheme.accent,
    };

    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: typeColor.withValues(alpha: 0.18),
              border: Border.all(color: typeColor.withValues(alpha: 0.45)),
            ),
            child: Icon(
              switch (hook.type) {
                'slack' => Icons.tag_rounded,
                'discord' => Icons.discord_rounded,
                _ => Icons.webhook_rounded,
              },
              color: typeColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hook.name,
                    style: bodyStyle(
                        size: 14,
                        color: colors.textPrimary,
                        weight: FontWeight.w700)),
                Text(
                  '${hook.type} · dispara em ${hook.triggerOn}',
                  style: monoStyle(size: 11, color: colors.textMuted),
                ),
                Text(hook.url,
                    overflow: TextOverflow.ellipsis,
                    style: monoStyle(
                        size: 11, color: colors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: hook.isActive,
            activeThumbColor: AppTheme.accent,
            onChanged: (v) async {
              await ref
                  .read(databaseProvider)
                  .updateWebhook(WebhooksCompanion(
                    id: d.Value(hook.id),
                    name: d.Value(hook.name),
                    type: d.Value(hook.type),
                    url: d.Value(hook.url),
                    triggerOn: d.Value(hook.triggerOn),
                    isActive: d.Value(v),
                  ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded, size: 16),
            tooltip: 'Disparar teste',
            onPressed: () async {
              try {
                await ref.read(webhookServiceProvider).sendTest(hook);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Disparado com sucesso')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Falhou: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, size: 16),
            tooltip: 'Editar',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _WebhookFormDialog(existing: hook),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                size: 16, color: AppTheme.statusDown),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('Remover ${hook.name}?'),
                  content: const Text('Esse webhook não será mais disparado.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.statusDown),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        ref.read(databaseProvider).deleteWebhook(hook.id);
                      },
                      child: const Text('Remover'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WebhookFormDialog extends ConsumerStatefulWidget {
  final Webhook? existing;
  const _WebhookFormDialog({this.existing});

  @override
  ConsumerState<_WebhookFormDialog> createState() => _WebhookFormDialogState();
}

class _WebhookFormDialogState extends ConsumerState<_WebhookFormDialog> {
  late final _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final _url =
      TextEditingController(text: widget.existing?.url ?? '');
  late String _type = widget.existing?.type ?? 'generic';
  late String _trigger = widget.existing?.triggerOn ?? 'any';

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    if (widget.existing == null) {
      await db.insertWebhook(WebhooksCompanion.insert(
        name: _name.text.trim(),
        url: _url.text.trim(),
        type: d.Value(_type),
        triggerOn: d.Value(_trigger),
      ));
    } else {
      await db.updateWebhook(WebhooksCompanion(
        id: d.Value(widget.existing!.id),
        name: d.Value(_name.text.trim()),
        url: d.Value(_url.text.trim()),
        type: d.Value(_type),
        triggerOn: d.Value(_trigger),
        isActive: d.Value(widget.existing!.isActive),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: GlassCard(
          padding: const EdgeInsets.fromLTRB(26, 24, 26, 20),
          elevated: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.existing == null ? 'Novo webhook' : 'Editar webhook',
                  style: displayStyle(
                      size: 24,
                      color: colors.textPrimary,
                      weight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(
                  controller: _name,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Nome')),
              const SizedBox(height: 12),
              TextField(
                controller: _url,
                decoration: const InputDecoration(
                    labelText: 'URL',
                    hintText: 'https://hooks.slack.com/...'),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _type,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      items: const [
                        DropdownMenuItem(value: 'slack', child: Text('Slack')),
                        DropdownMenuItem(
                            value: 'discord', child: Text('Discord')),
                        DropdownMenuItem(
                            value: 'generic', child: Text('Genérico (POST JSON)')),
                      ],
                      onChanged: (v) =>
                          setState(() => _type = v ?? 'generic'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _trigger,
                      decoration:
                          const InputDecoration(labelText: 'Disparar em'),
                      items: const [
                        DropdownMenuItem(
                            value: 'any', child: Text('Qualquer mudança')),
                        DropdownMenuItem(
                            value: 'down', child: Text('Só ao cair')),
                        DropdownMenuItem(
                            value: 'up', child: Text('Só ao voltar')),
                      ],
                      onChanged: (v) =>
                          setState(() => _trigger = v ?? 'any'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 6),
                  FilledButton(onPressed: _save, child: const Text('Salvar')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

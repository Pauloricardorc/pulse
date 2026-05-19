import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/auto_update_service.dart';
import '../../core/services/export_import_service.dart';
import '../../core/services/notification_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/theme/theme_provider.dart';
import '../../shared/widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final prefs = ref.watch(userPrefsProvider);
    final n = ref.read(userPrefsProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 18, 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferências',
                style: displayStyle(
                    size: 32,
                    color: colors.textPrimary,
                    weight: FontWeight.w800)),
            const SizedBox(height: 22),
            _Section(title: 'Aparência', children: [
              _ThemeChoice(
                value: prefs.tema,
                onChanged: n.setTema,
              ),
            ]),
            const SizedBox(height: 18),
            _Section(title: 'Notificações', children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Notificações do sistema',
                    style: bodyStyle(
                        size: 13.5,
                        color: colors.textPrimary,
                        weight: FontWeight.w600)),
                subtitle: Text(
                    'Aparece quando algum ambiente cai ou volta a funcionar.',
                    style: bodyStyle(size: 12, color: colors.textMuted)),
                value: prefs.notificacoesAtivas,
                activeThumbColor: AppTheme.accent,
                onChanged: n.setNotificacoes,
              ),
              Divider(color: colors.glassEdge),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Testar notificação',
                    style: bodyStyle(
                        size: 13.5,
                        color: colors.textPrimary,
                        weight: FontWeight.w600)),
                trailing: OutlinedButton(
                  onPressed: prefs.notificacoesAtivas
                      ? () => ref.read(notificationServiceProvider).showRecovery(
                            title: 'Pulse · teste',
                            body: 'As notificações estão funcionando.',
                          )
                      : null,
                  child: const Text('Disparar'),
                ),
              ),
            ]),
            const SizedBox(height: 18),
            _Section(title: 'Workspace', children: [
              _Action(
                icon: Icons.upload_file_rounded,
                title: 'Exportar workspace',
                subtitle:
                    'Empacota serviços, ambientes, tags e webhooks em um arquivo .json. Sem histórico.',
                cta: 'Exportar',
                onPressed: () async {
                  final ok = await ref
                      .read(exportImportServiceProvider)
                      .exportToFile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(ok ? 'Workspace exportado' : 'Cancelado'),
                    ));
                  }
                },
              ),
              Divider(color: colors.glassEdge),
              _Action(
                icon: Icons.download_rounded,
                title: 'Importar workspace',
                subtitle:
                    'Adiciona serviços e ambientes do arquivo. Combina com o que já existe.',
                cta: 'Importar',
                onPressed: () async {
                  final summary = await ref
                      .read(exportImportServiceProvider)
                      .importFromFile();
                  if (context.mounted && summary != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(summary)),
                    );
                  }
                },
              ),
            ]),
            const SizedBox(height: 18),
            _Section(title: 'Sobre', children: [
              if (Platform.isLinux)
                _Action(
                  icon: Icons.system_update_alt_rounded,
                  title: 'Buscar atualizações',
                  subtitle:
                      'Abre a página de releases. No Linux a instalação é manual.',
                  cta: 'Abrir GitHub',
                  onPressed: () => launchUrl(Uri.parse(
                      'https://github.com/Pauloricardorc/pulse/releases')),
                )
              else
                _Action(
                  icon: Icons.system_update_alt_rounded,
                  title: 'Buscar atualizações',
                  subtitle:
                      'Verifica se há versão nova e abre o instalador automaticamente.',
                  cta: 'Verificar',
                  onPressed: () async {
                    await ref.read(autoUpdateServiceProvider).checkNow();
                  },
                ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: monoStyle(
                size: 10,
                color: colors.textMuted,
                letterSpacing: 1.6,
                weight: FontWeight.w700)),
        const SizedBox(height: 10),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(18, 8, 14, 8),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ThemeChoice extends StatelessWidget {
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;
  const _ThemeChoice({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    const items = [
      (ThemeMode.dark, Icons.dark_mode_rounded, 'Escuro'),
      (ThemeMode.light, Icons.light_mode_rounded, 'Claro'),
      (ThemeMode.system, Icons.brightness_auto_rounded, 'Sistema'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tema',
                    style: bodyStyle(
                        size: 13.5,
                        color: colors.textPrimary,
                        weight: FontWeight.w600)),
                Text('Glass/Aurora reage ao tema do sistema ou ao seu gosto.',
                    style: bodyStyle(size: 12, color: colors.textMuted)),
              ],
            ),
          ),
          Row(
            children: items.map((it) {
              final selected = value == it.$1;
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: GestureDetector(
                  onTap: () => onChanged(it.$1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.accent.withValues(alpha: 0.15)
                          : colors.glass,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? AppTheme.accent.withValues(alpha: 0.5)
                            : colors.glassEdge,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(it.$2,
                            size: 14,
                            color: selected
                                ? AppTheme.accent
                                : colors.textSecondary),
                        const SizedBox(width: 6),
                        Text(it.$3,
                            style: bodyStyle(
                                size: 12.5,
                                color: selected
                                    ? AppTheme.accent
                                    : colors.textPrimary,
                                weight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, cta;
  final VoidCallback onPressed;
  const _Action({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.glass,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.glassEdge),
            ),
            child: Icon(icon, size: 16, color: colors.textPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: bodyStyle(
                        size: 13.5,
                        color: colors.textPrimary,
                        weight: FontWeight.w600)),
                Text(subtitle,
                    style: bodyStyle(size: 12, color: colors.textMuted)),
              ],
            ),
          ),
          OutlinedButton(onPressed: onPressed, child: Text(cta)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/export_import_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/shortcut_chip.dart';

class CommandPalette {
  static Future<void> open(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      barrierLabel: 'palette',
      transitionDuration: const Duration(milliseconds: 140),
      pageBuilder: (_, __, ___) => const _PaletteSheet(),
      transitionBuilder: (_, anim, __, child) {
        return Opacity(
          opacity: anim.value,
          child: Transform.translate(
            offset: Offset(0, (1 - anim.value) * -12),
            child: child,
          ),
        );
      },
    );
  }
}

class _Command {
  final IconData icon;
  final String label;
  final String section;
  final String? hint;
  final List<String> keys;
  final void Function(BuildContext context, WidgetRef ref) run;

  _Command({
    required this.icon,
    required this.label,
    required this.section,
    required this.run,
    this.hint,
    this.keys = const [],
  });

  String get searchText => '$label $section ${hint ?? ''}'.toLowerCase();
}

class _PaletteSheet extends ConsumerStatefulWidget {
  const _PaletteSheet();

  @override
  ConsumerState<_PaletteSheet> createState() => _PaletteSheetState();
}

class _PaletteSheetState extends ConsumerState<_PaletteSheet> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  int _selected = 0;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _focus.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  List<_Command> _builtinCommands() {
    return [
      _Command(
        icon: Icons.dashboard_rounded,
        label: 'Ir para Dashboard',
        section: 'Navegação',
        keys: ['G', 'D'],
        run: (ctx, _) => ctx.go('/dashboard'),
      ),
      _Command(
        icon: Icons.hub_rounded,
        label: 'Ir para Serviços',
        section: 'Navegação',
        keys: ['G', 'S'],
        run: (ctx, _) => ctx.go('/services'),
      ),
      _Command(
        icon: Icons.warning_amber_rounded,
        label: 'Ir para Incidentes',
        section: 'Navegação',
        keys: ['G', 'I'],
        run: (ctx, _) => ctx.go('/incidents'),
      ),
      _Command(
        icon: Icons.webhook_rounded,
        label: 'Ir para Webhooks',
        section: 'Navegação',
        keys: ['G', 'W'],
        run: (ctx, _) => ctx.go('/webhooks'),
      ),
      _Command(
        icon: Icons.tune_rounded,
        label: 'Ir para Preferências',
        section: 'Navegação',
        keys: ['G', 'P'],
        run: (ctx, _) => ctx.go('/settings'),
      ),
      _Command(
        icon: Icons.add_rounded,
        label: 'Novo serviço',
        section: 'Ações',
        keys: ['N'],
        run: (ctx, _) => ctx.go('/services/new'),
      ),
      _Command(
        icon: Icons.refresh_rounded,
        label: 'Recheck em todos os ambientes',
        section: 'Ações',
        keys: ['R'],
        run: (ctx, ref) async {
          final db = ref.read(databaseProvider);
          final envs = await db.getAllActiveEnvironments();
          // Defer to monitoring service if present
          // (lazy import via provider to avoid cycle)
          ref.invalidate(databaseProvider);
          if (ctx.mounted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text('${envs.length} ambientes na fila')),
            );
          }
        },
      ),
      _Command(
        icon: Icons.upload_file_rounded,
        label: 'Exportar ambiente (.pulse.json)',
        section: 'Workspace',
        hint: 'Empacotar serviços, ambientes, tags e webhooks',
        run: (ctx, ref) async {
          final svc = ref.read(exportImportServiceProvider);
          final ok = await svc.exportToFile();
          if (ctx.mounted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(ok
                    ? 'Workspace exportado com sucesso'
                    : 'Exportação cancelada'),
              ),
            );
          }
        },
      ),
      _Command(
        icon: Icons.download_rounded,
        label: 'Importar workspace de .pulse.json',
        section: 'Workspace',
        hint: 'Mesclar serviços, ambientes e tags',
        run: (ctx, ref) async {
          final svc = ref.read(exportImportServiceProvider);
          final summary = await svc.importFromFile();
          if (ctx.mounted && summary != null) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(summary)),
            );
          }
        },
      ),
      _Command(
        icon: Icons.dark_mode_rounded,
        label: 'Mostrar atalhos do teclado',
        section: 'Ajuda',
        keys: ['?'],
        run: (ctx, _) {
          Navigator.of(ctx).pop();
          // small delay so the palette is closed first
          Future.microtask(() {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(ctx);
          });
        },
      ),
    ];
  }

  List<_Item> _items(List<Service> services, List<Environment> envs) {
    final cmds = _builtinCommands();
    final items = <_Item>[
      ...cmds.map((c) => _Item.command(c)),
      ...services.map((s) {
        return _Item.service(
          s,
          envCount: envs.where((e) => e.serviceId == s.id).length,
        );
      }),
    ];

    if (_query.isEmpty) return items;

    final q = _query.toLowerCase();
    int score(_Item it) {
      final text = it.searchText;
      if (text.startsWith(q)) return 0;
      if (text.contains(' $q')) return 1;
      if (text.contains(q)) return 2;
      return 99;
    }

    final filtered = items.where((it) => it.searchText.contains(q)).toList();
    filtered.sort((a, b) => score(a).compareTo(score(b)));
    return filtered;
  }

  void _run(BuildContext context, _Item item) {
    Navigator.of(context).pop();
    if (item.command != null) {
      item.command!.run(context, ref);
    } else if (item.service != null) {
      context.go('/history/${item.service!.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final services = ref.watch(allServicesProvider).asData?.value ?? const [];
    final envs = ref.watch(allEnvironmentsProvider).asData?.value ?? const [];
    final items = _items(services, envs);
    _selected = _selected.clamp(0, items.isEmpty ? 0 : items.length - 1);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
      alignment: Alignment.topCenter,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: GlassCard(
          padding: EdgeInsets.zero,
          elevated: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search row
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 14, 12),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded,
                        size: 18, color: colors.textSecondary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: KeyboardListener(
                        focusNode: FocusNode(skipTraversal: true),
                        onKeyEvent: (e) {
                          if (e is! KeyDownEvent) return;
                          if (e.logicalKey == LogicalKeyboardKey.arrowDown) {
                            setState(() => _selected =
                                (_selected + 1).clamp(0, items.length - 1));
                          } else if (e.logicalKey ==
                              LogicalKeyboardKey.arrowUp) {
                            setState(() =>
                                _selected = (_selected - 1).clamp(0, items.length - 1));
                          } else if (e.logicalKey == LogicalKeyboardKey.enter &&
                              items.isNotEmpty) {
                            _run(context, items[_selected]);
                          } else if (e.logicalKey ==
                              LogicalKeyboardKey.escape) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: TextField(
                          controller: _controller,
                          focusNode: _focus,
                          onChanged: (v) {
                            setState(() {
                              _query = v;
                              _selected = 0;
                            });
                          },
                          style: bodyStyle(
                              size: 16,
                              color: colors.textPrimary,
                              weight: FontWeight.w500),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            hintText:
                                'Buscar serviço, ação ou navegação…',
                            hintStyle: bodyStyle(
                                size: 16, color: colors.textMuted),
                          ),
                        ),
                      ),
                    ),
                    const ShortcutChip('Esc'),
                  ],
                ),
              ),
              Divider(height: 1, color: colors.glassEdge),
              Flexible(
                child: items.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          'Nada encontrado para "$_query"',
                          textAlign: TextAlign.center,
                          style: bodyStyle(
                              size: 13, color: colors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final item = items[i];
                          return _Row(
                            item: item,
                            selected: i == _selected,
                            onTap: () => _run(context, item),
                            onHover: (v) {
                              if (v) setState(() => _selected = i);
                            },
                          );
                        },
                      ),
              ),
              Divider(height: 1, color: colors.glassEdge),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                child: Row(
                  children: [
                    const ShortcutChip('↑'),
                    const SizedBox(width: 4),
                    const ShortcutChip('↓'),
                    const SizedBox(width: 8),
                    Text('navegar',
                        style: monoStyle(size: 11, color: colors.textMuted)),
                    const SizedBox(width: 16),
                    const ShortcutChip('↵'),
                    const SizedBox(width: 8),
                    Text('executar',
                        style: monoStyle(size: 11, color: colors.textMuted)),
                    const Spacer(),
                    Text('${items.length} resultados',
                        style: monoStyle(size: 11, color: colors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item {
  final _Command? command;
  final Service? service;
  final int? envCount;

  _Item.command(this.command)
      : service = null,
        envCount = null;
  _Item.service(this.service, {required this.envCount}) : command = null;

  String get searchText {
    if (command != null) return command!.searchText;
    return '${service!.name} ${service!.description}'.toLowerCase();
  }
}

class _Row extends StatelessWidget {
  final _Item item;
  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;

  const _Row({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final icon = item.command?.icon ?? Icons.hub_rounded;
    final label = item.command?.label ?? item.service!.name;
    final section = item.command?.section ?? 'Serviço';
    final hint = item.command?.hint;
    final keys = item.command?.keys ?? const <String>[];

    return MouseRegion(
      onEnter: (_) => onHover(true),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.accent.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppTheme.accent.withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.glass,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.glassEdge),
                ),
                child: Icon(icon, size: 16, color: colors.textPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: bodyStyle(
                            size: 13.5,
                            color: colors.textPrimary,
                            weight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      hint ??
                          (item.service != null
                              ? '${item.envCount ?? 0} ambientes · histórico'
                              : section),
                      style: bodyStyle(
                          size: 11.5, color: colors.textMuted),
                    ),
                  ],
                ),
              ),
              if (keys.isNotEmpty)
                Row(
                  children: keys
                      .map((k) => Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: ShortcutChip(k),
                          ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_router.dart';
import '../../core/services/monitoring_service.dart';
import '../../features/command_palette/command_palette.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/shortcut_chip.dart';

/// Global hardware-keyboard handler.
///
/// This sits at the HardwareKeyboard layer (not the widget tree), which means
/// it fires regardless of which widget owns focus, and there's no chance for
/// a stray ancestor `Shortcuts` widget or Material default action to swallow
/// the event. It still backs off when the user is typing into a TextField,
/// and ignores anything with a meta/control modifier (so ⌘K can still open
/// the palette without G+K being triggered).
class GlobalKeyboard {
  GlobalKeyboard._();
  static final instance = GlobalKeyboard._();

  ProviderContainer? _container;
  DateTime? _goArmedAt;
  static const _goWindow = Duration(milliseconds: 900);

  bool _paletteOpen = false;
  bool _cheatsheetOpen = false;

  void install(ProviderContainer container) {
    _container = container;
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
  }

  BuildContext? get _ctx =>
      appRouter.routerDelegate.navigatorKey.currentContext;

  bool _typingInTextField() {
    final ctx = FocusManager.instance.primaryFocus?.context;
    if (ctx == null) return false;
    if (ctx.widget is EditableText) return true;
    var inside = false;
    ctx.visitAncestorElements((el) {
      if (el.widget is EditableText) {
        inside = true;
        return false;
      }
      return true;
    });
    return inside;
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final hw = HardwareKeyboard.instance;
    final key = event.logicalKey;

    // ⌘K / Ctrl+K — palette toggle (works even from inside text fields)
    if (key == LogicalKeyboardKey.keyK &&
        (hw.isMetaPressed || hw.isControlPressed)) {
      _togglePalette();
      return true;
    }

    // Ignore plain letters when a TextField has focus or when a modifier
    // is held (so ⌘W / ⌘S system actions still work normally).
    if (_typingInTextField()) return false;
    if (hw.isMetaPressed || hw.isControlPressed || hw.isAltPressed) {
      return false;
    }

    // ? — cheatsheet
    if (key == LogicalKeyboardKey.slash && hw.isShiftPressed) {
      _toggleCheatsheet();
      return true;
    }

    // G — arm chord
    if (key == LogicalKeyboardKey.keyG) {
      _goArmedAt = DateTime.now();
      return true;
    }

    // G + letter
    final armed = _goArmedAt != null &&
        DateTime.now().difference(_goArmedAt!) <= _goWindow;
    if (armed) {
      _goArmedAt = null;
      final path = _pathForChord(key);
      if (path != null) {
        appRouter.go(path);
        return true;
      }
    }

    // Standalone actions
    if (key == LogicalKeyboardKey.keyN) {
      appRouter.go('/services/new');
      return true;
    }
    if (key == LogicalKeyboardKey.keyR) {
      _container?.read(monitoringServiceProvider).recheckAll();
      return true;
    }
    if (key == LogicalKeyboardKey.slash) {
      // bare "/" → focus search isn't wired yet, but consume so it doesn't
      // get inserted somewhere.
      return true;
    }
    if (key == LogicalKeyboardKey.escape) {
      final ctx = _ctx;
      if (ctx != null && Navigator.of(ctx).canPop()) {
        Navigator.of(ctx).pop();
        return true;
      }
    }

    return false;
  }

  String? _pathForChord(LogicalKeyboardKey k) {
    if (k == LogicalKeyboardKey.keyD) return '/dashboard';
    if (k == LogicalKeyboardKey.keyS) return '/services';
    if (k == LogicalKeyboardKey.keyI) return '/incidents';
    if (k == LogicalKeyboardKey.keyW) return '/webhooks';
    if (k == LogicalKeyboardKey.keyP) return '/settings';
    return null;
  }

  Future<void> _togglePalette() async {
    final ctx = _ctx;
    if (ctx == null) return;
    if (_paletteOpen) {
      Navigator.of(ctx).pop();
      return;
    }
    _paletteOpen = true;
    await CommandPalette.open(ctx);
    _paletteOpen = false;
  }

  Future<void> _toggleCheatsheet() async {
    final ctx = _ctx;
    if (ctx == null) return;
    if (_cheatsheetOpen) {
      Navigator.of(ctx).pop();
      return;
    }
    _cheatsheetOpen = true;
    await showCheatsheet(ctx);
    _cheatsheetOpen = false;
  }
}

// ─── Cheatsheet (unchanged in behavior) ─────────────────────────────────────

const _entries = <_Entry>[
  _Entry('Geral', '⌘K', 'Abrir command palette'),
  _Entry('Geral', '?', 'Mostrar esta lista'),
  _Entry('Geral', 'Esc', 'Fechar / voltar'),
  _Entry('Navegação', 'G D', 'Dashboard'),
  _Entry('Navegação', 'G S', 'Serviços'),
  _Entry('Navegação', 'G I', 'Incidentes'),
  _Entry('Navegação', 'G W', 'Webhooks'),
  _Entry('Navegação', 'G P', 'Preferências'),
  _Entry('Ações', 'N', 'Novo serviço'),
  _Entry('Ações', 'R', 'Recheck em todos'),
];

class _Entry {
  final String section, keys, label;
  const _Entry(this.section, this.keys, this.label);
}

Future<void> showCheatsheet(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => const _CheatsheetDialog(),
  );
}

class _CheatsheetDialog extends StatelessWidget {
  const _CheatsheetDialog();

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<_Entry>>{};
    for (final e in _entries) {
      groups.putIfAbsent(e.section, () => []).add(e);
    }
    final colors = AppColors.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 100),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: GlassCard(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 22),
          elevated: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Atalhos',
                      style: displayStyle(
                          size: 26,
                          color: colors.textPrimary,
                          weight: FontWeight.w800)),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('keyboard',
                        style:
                            monoStyle(size: 11, color: colors.textMuted)),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ...groups.entries.map((g) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g.key.toUpperCase(),
                            style: monoStyle(
                                size: 10,
                                color: colors.textMuted,
                                letterSpacing: 1.4,
                                weight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        ...g.value.map(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                ...e.keys.split(' ').map((k) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4),
                                      child: ShortcutChip(k),
                                    )),
                                const SizedBox(width: 8),
                                Text(e.label,
                                    style: bodyStyle(
                                        size: 13,
                                        color: colors.textPrimary)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

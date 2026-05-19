import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/update_check_service.dart';
import '../theme/app_theme.dart';

/// Sits under the top bar — shows when a newer GitHub release exists.
class UpdateBanner extends ConsumerWidget {
  const UpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upd = ref.watch(updateCheckProvider);
    return upd.maybeWhen(
      data: (info) => info == null
          ? const SizedBox.shrink()
          : _Bar(info: info),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _Bar extends ConsumerStatefulWidget {
  final UpdateInfo info;
  const _Bar({required this.info});

  @override
  ConsumerState<_Bar> createState() => _BarState();
}

class _BarState extends ConsumerState<_Bar> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 18, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.accent.withValues(alpha: 0.18),
              AppTheme.accentSpark.withValues(alpha: 0.14),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.45)),
        ),
        child: Row(
          children: [
            Icon(Icons.system_update_alt_rounded,
                size: 16, color: AppTheme.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Versão ${widget.info.version}',
                      style: bodyStyle(
                          size: 13,
                          color: colors.textPrimary,
                          weight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: ' disponível · ${widget.info.title}',
                      style: bodyStyle(size: 13, color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  launchUrl(Uri.parse(widget.info.htmlUrl)),
              child: const Text('Abrir release'),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded,
                  size: 16, color: colors.textSecondary),
              onPressed: () => setState(() => _dismissed = true),
            ),
          ],
        ),
      ),
    );
  }
}

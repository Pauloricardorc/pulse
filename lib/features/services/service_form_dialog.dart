import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';

/// Compact dialog to create or edit a service (name + description).
class ServiceFormDialog {
  static Future<Service?> show(
    BuildContext context,
    WidgetRef ref, {
    Service? existing,
  }) {
    return showDialog<Service>(
      context: context,
      builder: (_) => _ServiceFormDialog(existing: existing),
    );
  }
}

class _ServiceFormDialog extends ConsumerStatefulWidget {
  final Service? existing;
  const _ServiceFormDialog({this.existing});

  @override
  ConsumerState<_ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends ConsumerState<_ServiceFormDialog> {
  late final _nameCtrl =
      TextEditingController(text: widget.existing?.name ?? '');
  late final _descCtrl =
      TextEditingController(text: widget.existing?.description ?? '');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final db = ref.read(databaseProvider);
    if (widget.existing == null) {
      await db.insertService(ServicesCompanion.insert(
        name: name,
        description: d.Value(_descCtrl.text.trim()),
      ));
    } else {
      await db.updateService(ServicesCompanion(
        id: d.Value(widget.existing!.id),
        name: d.Value(name),
        description: d.Value(_descCtrl.text.trim()),
        createdAt: d.Value(widget.existing!.createdAt),
      ));
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isEdit = widget.existing != null;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 100),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: GlassCard(
          padding: const EdgeInsets.fromLTRB(26, 24, 26, 20),
          elevated: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isEdit ? 'Editar serviço' : 'Novo serviço',
                  style: displayStyle(
                      size: 24,
                      color: colors.textPrimary,
                      weight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(
                controller: _nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                maxLines: 2,
                decoration:
                    const InputDecoration(labelText: 'Descrição (opcional)'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 6),
                  FilledButton(
                    onPressed: _save,
                    child: Text(isEdit ? 'Salvar' : 'Criar'),
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

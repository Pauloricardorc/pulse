import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';

/// Quick service creation — name + description only. After saving we drop
/// the user into the environment form so they can add a first ambiente.
class NewServiceScreen extends ConsumerStatefulWidget {
  const NewServiceScreen({super.key});

  @override
  ConsumerState<NewServiceScreen> createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends ConsumerState<NewServiceScreen> {
  final _name = TextEditingController();
  final _desc = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final n = _name.text.trim();
    if (n.isEmpty) return;
    final db = ref.read(databaseProvider);
    final id = await db.insertService(ServicesCompanion.insert(
      name: n,
      description: d.Value(_desc.text.trim()),
    ));
    if (mounted) {
      context.go('/services/$id/environments/new');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 18, 22),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
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
                Text('Novo serviço',
                    style: displayStyle(
                        size: 28,
                        color: colors.textPrimary,
                        weight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Um serviço agrupa um ou mais ambientes (prod, staging, dev…).',
              style: bodyStyle(size: 13, color: colors.textSecondary),
            ),
            const SizedBox(height: 22),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NOME',
                      style: monoStyle(
                          size: 10,
                          color: colors.textMuted,
                          letterSpacing: 1.4,
                          weight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _name,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText: 'ex.: Checkout, Auth, Payments'),
                  ),
                  const SizedBox(height: 18),
                  Text('DESCRIÇÃO',
                      style: monoStyle(
                          size: 10,
                          color: colors.textMuted,
                          letterSpacing: 1.4,
                          weight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _desc,
                    maxLines: 2,
                    decoration:
                        const InputDecoration(hintText: 'opcional'),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        'No próximo passo você adiciona o primeiro ambiente.',
                        style:
                            bodyStyle(size: 12, color: colors.textMuted),
                      ),
                      const Spacer(),
                      FilledButton(
                          onPressed: _save,
                          child: const Text('Continuar')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

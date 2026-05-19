import 'dart:convert';

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/monitoring_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';

/// Single screen used to add or edit an environment.
class EnvironmentFormScreen extends ConsumerStatefulWidget {
  final int serviceId;
  final int? environmentId;

  const EnvironmentFormScreen({
    super.key,
    required this.serviceId,
    this.environmentId,
  });

  @override
  ConsumerState<EnvironmentFormScreen> createState() =>
      _EnvironmentFormScreenState();
}

class _EnvironmentFormScreenState
    extends ConsumerState<EnvironmentFormScreen> {
  Environment? _existing;
  bool _loaded = false;

  final _name = TextEditingController();
  final _url = TextEditingController();
  String _method = 'GET';
  final _headersRows = <(TextEditingController, TextEditingController)>[];
  final _body = TextEditingController();

  String _matchType = 'status';
  final _matchValue = TextEditingController(text: '200');
  final _rangeFrom = TextEditingController(text: '200');
  final _rangeTo = TextEditingController(text: '299');

  final _interval = TextEditingController(text: '60');
  final _timeout = TextEditingController(text: '10000');
  String _role = '';
  bool _active = true;

  final _tagsCtrl = TextEditingController();
  final _selectedTags = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.environmentId != null) {
      final db = ref.read(databaseProvider);
      _existing = await db.getEnvironment(widget.environmentId!);
      if (_existing != null) {
        _name.text = _existing!.name;
        _url.text = _existing!.url;
        _method = _existing!.method;
        _body.text = _existing!.body;
        _matchType = _existing!.matchType;
        _matchValue.text = _existing!.matchValue;
        _rangeFrom.text = '${_existing!.statusRangeFrom}';
        _rangeTo.text = '${_existing!.statusRangeTo}';
        _interval.text = '${_existing!.checkIntervalSeconds}';
        _timeout.text = '${_existing!.timeoutMs}';
        _role = _existing!.role;
        _active = _existing!.isActive;
        try {
          final headers =
              (jsonDecode(_existing!.headersJson) as Map).cast<String, dynamic>();
          for (final entry in headers.entries) {
            _headersRows.add((
              TextEditingController(text: entry.key),
              TextEditingController(text: '${entry.value}'),
            ));
          }
        } catch (_) {}
        final tags = await db.getTagsForEnvironment(_existing!.id);
        _selectedTags.addAll(tags.map((t) => t.name));
      }
    }
    setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    _body.dispose();
    _matchValue.dispose();
    _rangeFrom.dispose();
    _rangeTo.dispose();
    _interval.dispose();
    _timeout.dispose();
    _tagsCtrl.dispose();
    for (final row in _headersRows) {
      row.$1.dispose();
      row.$2.dispose();
    }
    super.dispose();
  }

  String _serializeHeaders() {
    final map = <String, String>{};
    for (final row in _headersRows) {
      final k = row.$1.text.trim();
      if (k.isEmpty) continue;
      map[k] = row.$2.text;
    }
    return jsonEncode(map);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final url = _url.text.trim();
    if (name.isEmpty || url.isEmpty) return;

    final db = ref.read(databaseProvider);
    final monitor = ref.read(monitoringServiceProvider);

    final companion = EnvironmentsCompanion(
      id: _existing == null ? const d.Value.absent() : d.Value(_existing!.id),
      serviceId: d.Value(widget.serviceId),
      name: d.Value(name),
      url: d.Value(url),
      role: d.Value(_role),
      method: d.Value(_method),
      headersJson: d.Value(_serializeHeaders()),
      body: d.Value(_body.text),
      matchType: d.Value(_matchType),
      matchValue: d.Value(_matchValue.text.trim()),
      statusRangeFrom:
          d.Value(int.tryParse(_rangeFrom.text.trim()) ?? 200),
      statusRangeTo: d.Value(int.tryParse(_rangeTo.text.trim()) ?? 299),
      checkIntervalSeconds:
          d.Value(int.tryParse(_interval.text.trim()) ?? 60),
      timeoutMs: d.Value(int.tryParse(_timeout.text.trim()) ?? 10000),
      isActive: d.Value(_active),
      createdAt: _existing == null
          ? const d.Value.absent()
          : d.Value(_existing!.createdAt),
    );

    int envId;
    if (_existing == null) {
      envId = await db.insertEnvironment(companion);
    } else {
      await db.updateEnvironment(companion);
      envId = _existing!.id;
    }

    // tags
    final tagIds = <int>[];
    for (final name in _selectedTags) {
      final existing = await (db.select(db.tags)..where((x) => x.name.equals(name)))
          .getSingleOrNull();
      tagIds.add(
        existing?.id ?? await db.insertTag(TagsCompanion.insert(name: name)),
      );
    }
    await db.setTagsForEnvironment(envId, tagIds);

    final saved = await db.getEnvironment(envId);
    if (saved != null) monitor.rescheduleEnvironment(saved);

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }
    final colors = AppColors.of(context);
    final isEdit = _existing != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 18, 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 8),
                Text(isEdit ? 'Editar ambiente' : 'Novo ambiente',
                    style: displayStyle(
                        size: 28,
                        color: colors.textPrimary,
                        weight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 24),
            _section('Identificação', [
              _Row2(children: [
                _Field(label: 'Nome', controller: _name, hint: 'prod, staging…'),
                _Field(label: 'Papel (opcional)', child: DropdownButtonFormField<String>(
                  initialValue: _role.isEmpty ? null : _role,
                  decoration: const InputDecoration(),
                  hint: const Text('frontend, backend, api…'),
                  items: const [
                    DropdownMenuItem(value: '', child: Text('—')),
                    DropdownMenuItem(value: 'frontend', child: Text('frontend')),
                    DropdownMenuItem(value: 'backend', child: Text('backend')),
                    DropdownMenuItem(value: 'api', child: Text('api')),
                    DropdownMenuItem(value: 'health', child: Text('health')),
                  ],
                  onChanged: (v) => setState(() => _role = v ?? ''),
                )),
              ]),
              const SizedBox(height: 12),
              _Field(label: 'URL', controller: _url, hint: 'https://...'),
            ]),
            const SizedBox(height: 18),
            _section('Requisição', [
              _Row2(children: [
                _Field(
                    label: 'Método',
                    child: DropdownButtonFormField<String>(
                      initialValue: _method,
                      items: const ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD']
                          .map((m) =>
                              DropdownMenuItem(value: m, child: Text(m)))
                          .toList(),
                      onChanged: (v) => setState(() => _method = v ?? 'GET'),
                      decoration: const InputDecoration(),
                    )),
                _Field(
                    label: 'Timeout (ms)',
                    controller: _timeout,
                    keyboardType: TextInputType.number),
              ]),
              const SizedBox(height: 14),
              _HeadersEditor(
                rows: _headersRows,
                onAdd: () => setState(() => _headersRows.add((
                      TextEditingController(),
                      TextEditingController(),
                    ))),
                onRemove: (i) => setState(() {
                  _headersRows[i].$1.dispose();
                  _headersRows[i].$2.dispose();
                  _headersRows.removeAt(i);
                }),
              ),
              const SizedBox(height: 14),
              _Field(
                label: 'Body (opcional)',
                controller: _body,
                maxLines: 4,
                monoFont: true,
              ),
            ]),
            const SizedBox(height: 18),
            _section('Critério de saúde', [
              _MatcherEditor(
                matchType: _matchType,
                matchValue: _matchValue,
                rangeFrom: _rangeFrom,
                rangeTo: _rangeTo,
                onChangeType: (v) => setState(() => _matchType = v),
              ),
            ]),
            const SizedBox(height: 18),
            _section('Verificação', [
              _Row2(children: [
                _Field(
                    label: 'Intervalo (segundos)',
                    controller: _interval,
                    keyboardType: TextInputType.number),
                _Field(
                    label: 'Estado',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _active ? 'Ativo' : 'Pausado',
                          style: bodyStyle(
                              size: 13.5,
                              color: colors.textPrimary,
                              weight: FontWeight.w600),
                        ),
                        value: _active,
                        activeThumbColor: AppTheme.accent,
                        onChanged: (v) => setState(() => _active = v),
                      ),
                    )),
              ]),
            ]),
            const SizedBox(height: 18),
            _section('Tags', [
              _TagsEditor(
                selected: _selectedTags,
                controller: _tagsCtrl,
                onAdd: (name) {
                  if (name.trim().isEmpty) return;
                  setState(() => _selectedTags.add(name.trim()));
                  _tagsCtrl.clear();
                },
                onRemove: (n) => setState(() => _selectedTags.remove(n)),
              ),
            ]),
            const SizedBox(height: 22),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancelar')),
                const SizedBox(width: 10),
                FilledButton.icon(
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: Text(isEdit ? 'Salvar alterações' : 'Criar ambiente'),
                  onPressed: _save,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    final colors = AppColors.of(context);
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: monoStyle(
                  size: 10,
                  color: colors.textMuted,
                  letterSpacing: 1.6,
                  weight: FontWeight.w700)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

// ─── Form pieces ─────────────────────────────────────────────────────────────

class _Row2 extends StatelessWidget {
  final List<Widget> children;
  const _Row2({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Widget? child;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool monoFont;

  const _Field({
    required this.label,
    this.controller,
    this.child,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.monoFont = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: bodyStyle(
                size: 11.5,
                color: colors.textMuted,
                weight: FontWeight.w600)),
        const SizedBox(height: 6),
        child ??
            TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              style: monoFont
                  ? monoStyle(size: 12, color: colors.textPrimary)
                  : bodyStyle(size: 13.5, color: colors.textPrimary),
              decoration: InputDecoration(hintText: hint),
            ),
      ],
    );
  }
}

class _HeadersEditor extends StatelessWidget {
  final List<(TextEditingController, TextEditingController)> rows;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const _HeadersEditor({
    required this.rows,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Headers',
            style: bodyStyle(
                size: 11.5,
                color: colors.textMuted,
                weight: FontWeight.w600)),
        const SizedBox(height: 6),
        for (var i = 0; i < rows.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: rows[i].$1,
                    style:
                        monoStyle(size: 12.5, color: colors.textPrimary),
                    decoration: const InputDecoration(hintText: 'Header'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: rows[i].$2,
                    style:
                        monoStyle(size: 12.5, color: colors.textPrimary),
                    decoration: const InputDecoration(hintText: 'valor'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 16, color: colors.textSecondary),
                  onPressed: () => onRemove(i),
                ),
              ],
            ),
          ),
        OutlinedButton.icon(
          icon: const Icon(Icons.add_rounded, size: 14),
          label: const Text('Adicionar header'),
          onPressed: onAdd,
        ),
      ],
    );
  }
}

class _MatcherEditor extends StatelessWidget {
  final String matchType;
  final TextEditingController matchValue;
  final TextEditingController rangeFrom;
  final TextEditingController rangeTo;
  final ValueChanged<String> onChangeType;

  const _MatcherEditor({
    required this.matchType,
    required this.matchValue,
    required this.rangeFrom,
    required this.rangeTo,
    required this.onChangeType,
  });

  @override
  Widget build(BuildContext context) {
    const types = [
      ('status', 'Status exato'),
      ('range', 'Range de status'),
      ('contains', 'Body contém'),
      ('regex', 'Regex no body'),
      ('jsonpath', 'JSON path'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: types.map((t) {
            final selected = matchType == t.$1;
            return _Choice(
              label: t.$2,
              selected: selected,
              onTap: () => onChangeType(t.$1),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        if (matchType == 'range')
          Row(
            children: [
              Expanded(
                child: _Field(
                  label: 'De',
                  controller: rangeFrom,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Field(
                  label: 'Até',
                  controller: rangeTo,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          )
        else
          _Field(
            label: switch (matchType) {
              'status' => 'Código esperado',
              'contains' => 'Texto que precisa aparecer',
              'regex' => 'Expressão regular',
              'jsonpath' => 'Caminho (ex.: data.user.id)',
              _ => 'Valor',
            },
            controller: matchValue,
            monoFont: matchType != 'status',
            keyboardType: matchType == 'status'
                ? TextInputType.number
                : TextInputType.text,
          ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.accent.withValues(alpha: 0.16)
              : colors.glass,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppTheme.accent.withValues(alpha: 0.55)
                : colors.glassEdge,
          ),
        ),
        child: Text(label,
            style: bodyStyle(
                size: 12.5,
                color: selected ? AppTheme.accent : colors.textPrimary,
                weight: selected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }
}

class _TagsEditor extends StatelessWidget {
  final Set<String> selected;
  final TextEditingController controller;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const _TagsEditor({
    required this.selected,
    required this.controller,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final t in selected)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.tagColor(t).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppTheme.tagColor(t).withValues(alpha: 0.45)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(t,
                        style: monoStyle(
                            size: 11,
                            color: AppTheme.tagColor(t),
                            weight: FontWeight.w700)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => onRemove(t),
                      child: Icon(Icons.close_rounded,
                          size: 12, color: AppTheme.tagColor(t)),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: onAdd,
                decoration: InputDecoration(
                  hintText: 'nova tag (ex.: billing, infra) — Enter',
                  hintStyle:
                      bodyStyle(size: 12.5, color: colors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => onAdd(controller.text),
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}

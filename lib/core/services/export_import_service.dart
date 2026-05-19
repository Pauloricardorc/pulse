import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import 'monitoring_service.dart';

class ExportImportService {
  final AppDatabase _db;
  final Ref _ref;
  ExportImportService(this._db, this._ref);

  static const _fileExtension = 'json';
  static const _formatVersion = 1;

  Future<bool> exportToFile() async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Exportar workspace Pulse',
      fileName: 'pulse-workspace.$_fileExtension',
      type: FileType.custom,
      allowedExtensions: [_fileExtension],
    );
    if (path == null) return false;

    final json = await buildExport();
    await File(path).writeAsString(const JsonEncoder.withIndent('  ').convert(json));
    return true;
  }

  Future<Map<String, dynamic>> buildExport() async {
    final services = await _db.getAllServices();
    final allEnvs = <Environment>[];
    final envTags = <int, List<String>>{};
    for (final svc in services) {
      final envs = await _db.getEnvironmentsByService(svc.id);
      allEnvs.addAll(envs);
      for (final e in envs) {
        final tags = await _db.getTagsForEnvironment(e.id);
        envTags[e.id] = tags.map((t) => t.name).toList();
      }
    }
    final webhooks = await _db.getActiveWebhooks();

    return {
      'format': 'pulse-workspace',
      'version': _formatVersion,
      'exported_at': DateTime.now().toIso8601String(),
      'services': services
          .map((s) => {
                'id': s.id,
                'name': s.name,
                'description': s.description,
              })
          .toList(),
      'environments': allEnvs
          .map((e) => {
                'service_id': e.serviceId,
                'name': e.name,
                'url': e.url,
                'role': e.role,
                'method': e.method,
                'headers_json': e.headersJson,
                'body': e.body,
                'match_type': e.matchType,
                'match_value': e.matchValue,
                'status_range_from': e.statusRangeFrom,
                'status_range_to': e.statusRangeTo,
                'timeout_ms': e.timeoutMs,
                'check_interval_seconds': e.checkIntervalSeconds,
                'is_active': e.isActive,
                'tags': envTags[e.id] ?? <String>[],
              })
          .toList(),
      'webhooks': webhooks
          .map((w) => {
                'name': w.name,
                'type': w.type,
                'url': w.url,
                'trigger_on': w.triggerOn,
              })
          .toList(),
    };
  }

  /// Picks a file, validates the schema, and merges into the workspace.
  /// Returns a human-readable summary, or null on cancel.
  Future<String?> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Importar workspace Pulse',
      type: FileType.custom,
      allowedExtensions: [_fileExtension],
    );
    if (result == null || result.files.single.path == null) return null;
    final file = File(result.files.single.path!);
    final content = await file.readAsString();

    Map<String, dynamic> data;
    try {
      data = jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      return 'Arquivo inválido: não é JSON';
    }
    if (data['format'] != 'pulse-workspace') {
      return 'Arquivo não parece ser um workspace Pulse';
    }
    return _applyImport(data);
  }

  Future<String> _applyImport(Map<String, dynamic> data) async {
    var newServices = 0, newEnvs = 0, newTags = 0, newHooks = 0;

    await _db.transaction(() async {
      // services
      final existingServices = await _db.getAllServices();
      final existingNames = {for (final s in existingServices) s.name: s.id};
      final idMap = <int, int>{}; // export id → local id

      for (final raw in (data['services'] as List? ?? const [])) {
        final s = raw as Map<String, dynamic>;
        final name = s['name'] as String;
        var localId = existingNames[name];
        if (localId == null) {
          localId = await _db.insertService(ServicesCompanion.insert(
            name: name,
            description: Value(s['description'] as String? ?? ''),
          ));
          newServices++;
        }
        idMap[s['id'] as int] = localId;
      }

      // environments
      for (final raw in (data['environments'] as List? ?? const [])) {
        final e = raw as Map<String, dynamic>;
        final serviceId = idMap[e['service_id'] as int];
        if (serviceId == null) continue;

        final localId = await _db.insertEnvironment(EnvironmentsCompanion.insert(
          serviceId: serviceId,
          name: e['name'] as String,
          url: e['url'] as String,
          role: Value(e['role'] as String? ?? ''),
          method: Value(e['method'] as String? ?? 'GET'),
          headersJson: Value(e['headers_json'] as String? ?? '{}'),
          body: Value(e['body'] as String? ?? ''),
          matchType: Value(e['match_type'] as String? ?? 'status'),
          matchValue: Value(e['match_value'] as String? ?? '200'),
          statusRangeFrom: Value(e['status_range_from'] as int? ?? 200),
          statusRangeTo: Value(e['status_range_to'] as int? ?? 299),
          timeoutMs: Value(e['timeout_ms'] as int? ?? 10000),
          checkIntervalSeconds:
              Value(e['check_interval_seconds'] as int? ?? 60),
          isActive: Value(e['is_active'] as bool? ?? true),
        ));
        newEnvs++;

        final tagNames = (e['tags'] as List? ?? const []).cast<String>();
        final tagIds = <int>[];
        for (final t in tagNames) {
          final existing = await (_db.select(_db.tags)..where((x) => x.name.equals(t)))
              .getSingleOrNull();
          int id;
          if (existing != null) {
            id = existing.id;
          } else {
            id = await _db.insertTag(TagsCompanion.insert(name: t));
            newTags++;
          }
          tagIds.add(id);
        }
        if (tagIds.isNotEmpty) {
          await _db.setTagsForEnvironment(localId, tagIds);
        }
      }

      // webhooks
      for (final raw in (data['webhooks'] as List? ?? const [])) {
        final w = raw as Map<String, dynamic>;
        await _db.insertWebhook(WebhooksCompanion.insert(
          name: w['name'] as String,
          url: w['url'] as String,
          type: Value(w['type'] as String? ?? 'generic'),
          triggerOn: Value(w['trigger_on'] as String? ?? 'any'),
        ));
        newHooks++;
      }
    });

    // schedule freshly imported environments
    _ref.read(monitoringServiceProvider).start();

    return 'Importado: $newServices serviços, $newEnvs ambientes, '
        '$newTags tags, $newHooks webhooks';
  }
}

final exportImportServiceProvider = Provider<ExportImportService>((ref) {
  return ExportImportService(ref.watch(databaseProvider), ref);
});

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Services extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Environments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serviceId =>
      integer().references(Services, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get url => text()();
  TextColumn get role => text().withDefault(const Constant(''))();

  TextColumn get method => text().withDefault(const Constant('GET'))();
  TextColumn get headersJson => text().withDefault(const Constant('{}'))();
  TextColumn get body => text().withDefault(const Constant(''))();

  // 'status' | 'range' | 'contains' | 'regex' | 'jsonpath'
  TextColumn get matchType => text().withDefault(const Constant('status'))();
  TextColumn get matchValue => text().withDefault(const Constant('200'))();
  IntColumn get statusRangeFrom =>
      integer().withDefault(const Constant(200))();
  IntColumn get statusRangeTo =>
      integer().withDefault(const Constant(299))();

  IntColumn get timeoutMs => integer().withDefault(const Constant(10000))();
  IntColumn get checkIntervalSeconds =>
      integer().withDefault(const Constant(60))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
}

class EnvironmentTags extends Table {
  IntColumn get environmentId =>
      integer().references(Environments, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {environmentId, tagId};
}

class CheckResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get environmentId =>
      integer().references(Environments, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get checkedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get statusCode => integer().nullable()();
  IntColumn get responseTimeMs => integer().nullable()();
  BoolColumn get isUp => boolean()();
  TextColumn get errorMessage => text().nullable()();
}

class Incidents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get environmentId =>
      integer().references(Environments, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get cause => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get acknowledged => boolean().withDefault(const Constant(false))();
}

class Webhooks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  // 'slack' | 'discord' | 'generic'
  TextColumn get type => text().withDefault(const Constant('generic'))();
  TextColumn get url => text()();
  // 'down' | 'up' | 'any'
  TextColumn get triggerOn => text().withDefault(const Constant('any'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [
  Services,
  Environments,
  Tags,
  EnvironmentTags,
  CheckResults,
  Incidents,
  Webhooks,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ─── Services ──────────────────────────────────────────────────────────────

  Stream<List<Service>> watchAllServices() =>
      (select(services)..orderBy([(s) => OrderingTerm.asc(s.name)])).watch();

  Future<List<Service>> getAllServices() => select(services).get();

  Future<Service?> getServiceById(int id) =>
      (select(services)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<int> insertService(ServicesCompanion service) =>
      into(services).insert(service);

  Future<bool> updateService(ServicesCompanion service) =>
      update(services).replace(service);

  Future<int> deleteService(int id) =>
      (delete(services)..where((t) => t.id.equals(id))).go();

  // ─── Environments ──────────────────────────────────────────────────────────

  Stream<List<Environment>> watchEnvironmentsByService(int serviceId) =>
      (select(environments)
            ..where((e) => e.serviceId.equals(serviceId))
            ..orderBy([(e) => OrderingTerm.asc(e.createdAt)]))
          .watch();

  Stream<List<Environment>> watchAllEnvironments() =>
      (select(environments)..orderBy([(e) => OrderingTerm.asc(e.createdAt)]))
          .watch();

  Future<List<Environment>> getEnvironmentsByService(int serviceId) =>
      (select(environments)..where((e) => e.serviceId.equals(serviceId))).get();

  Future<List<Environment>> getAllActiveEnvironments() =>
      (select(environments)..where((e) => e.isActive.equals(true))).get();

  Future<Environment?> getEnvironment(int id) =>
      (select(environments)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<int> insertEnvironment(EnvironmentsCompanion env) =>
      into(environments).insert(env);

  Future<bool> updateEnvironment(EnvironmentsCompanion env) =>
      update(environments).replace(env);

  Future<int> deleteEnvironment(int id) =>
      (delete(environments)..where((e) => e.id.equals(id))).go();

  // ─── Tags ──────────────────────────────────────────────────────────────────

  Stream<List<Tag>> watchAllTags() =>
      (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<List<Tag>> getAllTags() => select(tags).get();

  Future<int> insertTag(TagsCompanion tag) => into(tags).insert(tag);

  Future<int> deleteTag(int id) =>
      (delete(tags)..where((t) => t.id.equals(id))).go();

  Future<List<Tag>> getTagsForEnvironment(int envId) async {
    final query = select(tags).join([
      innerJoin(environmentTags, environmentTags.tagId.equalsExp(tags.id)),
    ])
      ..where(environmentTags.environmentId.equals(envId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(tags)).toList();
  }

  Stream<List<Tag>> watchTagsForEnvironment(int envId) {
    final query = select(tags).join([
      innerJoin(environmentTags, environmentTags.tagId.equalsExp(tags.id)),
    ])
      ..where(environmentTags.environmentId.equals(envId));
    return query.watch().map((rows) => rows.map((r) => r.readTable(tags)).toList());
  }

  Future<void> setTagsForEnvironment(int envId, List<int> tagIds) async {
    await transaction(() async {
      await (delete(environmentTags)
            ..where((e) => e.environmentId.equals(envId)))
          .go();
      for (final tagId in tagIds) {
        await into(environmentTags).insert(
          EnvironmentTagsCompanion.insert(environmentId: envId, tagId: tagId),
        );
      }
    });
  }

  // ─── CheckResults ──────────────────────────────────────────────────────────

  Future<int> insertCheckResult(CheckResultsCompanion result) =>
      into(checkResults).insert(result);

  Future<CheckResult?> getLatestCheckResult(int environmentId) async {
    final query = select(checkResults)
      ..where((r) => r.environmentId.equals(environmentId))
      ..orderBy([(r) => OrderingTerm.desc(r.checkedAt)])
      ..limit(1);
    final results = await query.get();
    return results.isEmpty ? null : results.first;
  }

  Stream<CheckResult?> watchLatestCheckResult(int environmentId) {
    final query = select(checkResults)
      ..where((r) => r.environmentId.equals(environmentId))
      ..orderBy([(r) => OrderingTerm.desc(r.checkedAt)])
      ..limit(1);
    return query.watch().map((rows) => rows.isEmpty ? null : rows.first);
  }

  Stream<List<CheckResult>> watchRecentChecks(int environmentId,
      {int limit = 60}) {
    return (select(checkResults)
          ..where((r) => r.environmentId.equals(environmentId))
          ..orderBy([(r) => OrderingTerm.desc(r.checkedAt)])
          ..limit(limit))
        .watch();
  }

  Future<List<CheckResult>> getChecksInPeriod(
    int environmentId,
    DateTime from,
    DateTime to,
  ) =>
      (select(checkResults)
            ..where((r) =>
                r.environmentId.equals(environmentId) &
                r.checkedAt.isBetweenValues(from, to))
            ..orderBy([(r) => OrderingTerm.asc(r.checkedAt)]))
          .get();

  Future<void> deleteOldCheckResults(DateTime before) =>
      (delete(checkResults)..where((r) => r.checkedAt.isSmallerThanValue(before)))
          .go();

  // ─── Incidents ─────────────────────────────────────────────────────────────

  Stream<List<Incident>> watchIncidents({bool onlyOpen = false}) {
    final q = select(incidents)
      ..orderBy([(i) => OrderingTerm.desc(i.startedAt)]);
    if (onlyOpen) q.where((i) => i.endedAt.isNull());
    return q.watch();
  }

  Future<Incident?> getOpenIncident(int envId) async {
    final q = select(incidents)
      ..where((i) => i.environmentId.equals(envId) & i.endedAt.isNull())
      ..limit(1);
    final r = await q.get();
    return r.isEmpty ? null : r.first;
  }

  Future<int> openIncident(int envId, DateTime at, String cause) =>
      into(incidents).insert(IncidentsCompanion.insert(
        environmentId: envId,
        startedAt: at,
        cause: Value(cause),
      ));

  Future<int> closeIncident(int id, DateTime at) =>
      (update(incidents)..where((i) => i.id.equals(id))).write(
        IncidentsCompanion(endedAt: Value(at)),
      );

  Future<int> updateIncidentNote(int id, String note) =>
      (update(incidents)..where((i) => i.id.equals(id))).write(
        IncidentsCompanion(note: Value(note)),
      );

  Future<int> setIncidentAcknowledged(int id, bool ack) =>
      (update(incidents)..where((i) => i.id.equals(id))).write(
        IncidentsCompanion(acknowledged: Value(ack)),
      );

  // ─── Webhooks ──────────────────────────────────────────────────────────────

  Stream<List<Webhook>> watchWebhooks() =>
      (select(webhooks)..orderBy([(w) => OrderingTerm.asc(w.name)])).watch();

  Future<List<Webhook>> getActiveWebhooks() =>
      (select(webhooks)..where((w) => w.isActive.equals(true))).get();

  Future<int> insertWebhook(WebhooksCompanion w) =>
      into(webhooks).insert(w);

  Future<bool> updateWebhook(WebhooksCompanion w) =>
      update(webhooks).replace(w);

  Future<int> deleteWebhook(int id) =>
      (delete(webhooks)..where((w) => w.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'pulse_v2.db'));
    return NativeDatabase.createInBackground(file);
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final allServicesProvider = StreamProvider<List<Service>>((ref) {
  return ref.watch(databaseProvider).watchAllServices();
});

final environmentsByServiceProvider =
    StreamProvider.family<List<Environment>, int>((ref, serviceId) {
  return ref.watch(databaseProvider).watchEnvironmentsByService(serviceId);
});

final allEnvironmentsProvider = StreamProvider<List<Environment>>((ref) {
  return ref.watch(databaseProvider).watchAllEnvironments();
});

final latestCheckProvider =
    StreamProvider.family<CheckResult?, int>((ref, envId) {
  return ref.watch(databaseProvider).watchLatestCheckResult(envId);
});

final recentChecksProvider =
    StreamProvider.family<List<CheckResult>, int>((ref, envId) {
  return ref.watch(databaseProvider).watchRecentChecks(envId);
});

final allTagsProvider = StreamProvider<List<Tag>>((ref) {
  return ref.watch(databaseProvider).watchAllTags();
});

final tagsForEnvironmentProvider =
    StreamProvider.family<List<Tag>, int>((ref, envId) {
  return ref.watch(databaseProvider).watchTagsForEnvironment(envId);
});

final openIncidentsProvider = StreamProvider<List<Incident>>((ref) {
  return ref.watch(databaseProvider).watchIncidents(onlyOpen: true);
});

final allIncidentsProvider = StreamProvider<List<Incident>>((ref) {
  return ref.watch(databaseProvider).watchIncidents();
});

final webhooksProvider = StreamProvider<List<Webhook>>((ref) {
  return ref.watch(databaseProvider).watchWebhooks();
});

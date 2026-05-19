import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class EnvironmentMetrics {
  final int totalChecks;
  final int successfulChecks;
  final double uptimePct;
  final int? p95Ms;
  final int? avgMs;

  const EnvironmentMetrics({
    required this.totalChecks,
    required this.successfulChecks,
    required this.uptimePct,
    required this.p95Ms,
    required this.avgMs,
  });

  static const empty = EnvironmentMetrics(
    totalChecks: 0,
    successfulChecks: 0,
    uptimePct: 0,
    p95Ms: null,
    avgMs: null,
  );
}

class MetricsService {
  final AppDatabase _db;
  MetricsService(this._db);

  Future<EnvironmentMetrics> metricsFor(int envId, Duration window) async {
    final from = DateTime.now().subtract(window);
    final checks = await _db.getChecksInPeriod(envId, from, DateTime.now());
    if (checks.isEmpty) return EnvironmentMetrics.empty;

    final total = checks.length;
    final ups = checks.where((c) => c.isUp).length;
    final latencies = checks
        .where((c) => c.responseTimeMs != null)
        .map((c) => c.responseTimeMs!)
        .toList()
      ..sort();

    int? p95;
    int? avg;
    if (latencies.isNotEmpty) {
      final idx = (0.95 * (latencies.length - 1)).round();
      p95 = latencies[idx];
      avg = (latencies.reduce((a, b) => a + b) / latencies.length).round();
    }

    return EnvironmentMetrics(
      totalChecks: total,
      successfulChecks: ups,
      uptimePct: ups / total * 100,
      p95Ms: p95,
      avgMs: avg,
    );
  }
}

final metricsServiceProvider = Provider<MetricsService>((ref) {
  return MetricsService(ref.watch(databaseProvider));
});

final envMetricsProvider = FutureProvider.family<EnvironmentMetrics,
    ({int envId, Duration window})>((ref, args) async {
  // Re-run when new checks arrive
  ref.watch(latestCheckProvider(args.envId));
  return ref
      .watch(metricsServiceProvider)
      .metricsFor(args.envId, args.window);
});

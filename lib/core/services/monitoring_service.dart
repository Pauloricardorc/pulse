import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../matchers/response_matcher.dart';
import '../../shared/theme/theme_provider.dart';
import 'notification_service.dart';
import 'webhook_service.dart';

class MonitoringService {
  final AppDatabase _db;
  final NotificationService _notif;
  final WebhookService _hooks;
  final Ref _ref;
  final Dio _dio;

  final Map<int, Timer> _timers = {};
  final Map<int, bool?> _lastKnown = {};

  MonitoringService(this._db, this._notif, this._hooks, this._ref)
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          followRedirects: true,
          validateStatus: (_) => true,
          responseType: ResponseType.plain,
        ));

  Future<void> start() async {
    for (final env in await _db.getAllActiveEnvironments()) {
      _scheduleCheck(env);
    }
  }

  void rescheduleEnvironment(Environment env) {
    _stop(env.id);
    if (env.isActive) _scheduleCheck(env);
  }

  void removeEnvironment(int id) {
    _stop(id);
    _lastKnown.remove(id);
  }

  Future<void> checkNow(Environment env) => _runCheck(env);

  Future<void> recheckAll() async {
    final envs = await _db.getAllActiveEnvironments();
    for (final env in envs) {
      // schedule a tiny stagger so we don't fire 50 requests at the same ms
      Future.delayed(Duration(milliseconds: envs.indexOf(env) * 30), () {
        _runCheck(env);
      });
    }
  }

  void _scheduleCheck(Environment env) {
    _runCheck(env);
    _timers[env.id] = Timer.periodic(
      Duration(seconds: env.checkIntervalSeconds),
      (_) => _runCheck(env),
    );
  }

  void _stop(int id) {
    _timers[id]?.cancel();
    _timers.remove(id);
  }

  Future<void> _runCheck(Environment env) async {
    final sw = Stopwatch()..start();
    int? statusCode;
    String body = '';
    String? errorMessage;
    bool isUp = false;

    try {
      Map<String, dynamic> headers = {};
      if (env.headersJson.isNotEmpty) {
        try {
          headers = (jsonDecode(env.headersJson) as Map).cast<String, dynamic>();
        } catch (_) {}
      }

      final response = await _dio.request(
        env.url,
        data: env.body.isEmpty ? null : env.body,
        options: Options(
          method: env.method,
          headers: headers,
          sendTimeout: Duration(milliseconds: env.timeoutMs),
          receiveTimeout: Duration(milliseconds: env.timeoutMs),
        ),
      );
      sw.stop();
      statusCode = response.statusCode;
      body = response.data?.toString() ?? '';

      final result = ResponseMatcher.evaluate(
        matchType: env.matchType,
        matchValue: env.matchValue,
        rangeFrom: env.statusRangeFrom,
        rangeTo: env.statusRangeTo,
        statusCode: statusCode,
        body: body,
      );
      isUp = result.$1;
      errorMessage = result.$2;
    } on DioException catch (e) {
      sw.stop();
      isUp = false;
      errorMessage = _formatDio(e);
    } catch (e) {
      sw.stop();
      isUp = false;
      errorMessage = e.toString();
    }

    final responseTime = sw.elapsedMilliseconds > 0 ? sw.elapsedMilliseconds : null;

    await _db.insertCheckResult(CheckResultsCompanion(
      environmentId: Value(env.id),
      statusCode: Value(statusCode),
      responseTimeMs: Value(responseTime),
      isUp: Value(isUp),
      errorMessage: Value(errorMessage),
    ));

    await _handleStatusChange(env, isUp, statusCode, errorMessage);
  }

  Future<void> _handleStatusChange(
    Environment env,
    bool isUp,
    int? statusCode,
    String? errorMessage,
  ) async {
    final previous = _lastKnown[env.id];
    _lastKnown[env.id] = isUp;

    // Maintain incident lifecycle
    final openIncident = await _db.getOpenIncident(env.id);
    if (!isUp && openIncident == null) {
      await _db.openIncident(env.id, DateTime.now(), errorMessage ?? '');
    } else if (isUp && openIncident != null) {
      await _db.closeIncident(openIncident.id, DateTime.now());
    }

    if (previous == isUp) return;

    final service = await _db.getServiceById(env.serviceId);
    if (service == null) return;

    // Webhook on transition
    await _hooks.notifyStatusChange(
      service: service,
      env: env,
      isUp: isUp,
      statusCode: statusCode,
      errorMessage: errorMessage,
    );

    // Native OS notification
    final prefs = _ref.read(userPrefsProvider);
    if (!prefs.notificacoesAtivas) return;

    if (isUp) {
      await _notif.showRecovery(
        title: '${service.name} · ${env.name} voltou',
        body: env.url,
      );
    } else {
      await _notif.showAlert(
        title: '${service.name} · ${env.name} caiu',
        body: errorMessage ?? env.url,
      );
    }
  }

  String _formatDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Timeout de conexão';
      case DioExceptionType.receiveTimeout:
        return 'Timeout ao receber resposta';
      case DioExceptionType.connectionError:
        return 'Erro de conexão';
      case DioExceptionType.badCertificate:
        return 'Certificado inválido';
      default:
        return e.message ?? 'Erro desconhecido';
    }
  }

  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
  }
}

final monitoringServiceProvider = Provider<MonitoringService>((ref) {
  final svc = MonitoringService(
    ref.watch(databaseProvider),
    ref.watch(notificationServiceProvider),
    ref.watch(webhookServiceProvider),
    ref,
  );
  ref.onDispose(svc.dispose);
  return svc;
});

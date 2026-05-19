import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

/// Fires Slack / Discord / generic JSON webhooks on status change.
class WebhookService {
  final AppDatabase _db;
  final Dio _dio;

  WebhookService(this._db)
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 6),
          sendTimeout: const Duration(seconds: 6),
          receiveTimeout: const Duration(seconds: 6),
        ));

  Future<void> notifyStatusChange({
    required Service service,
    required Environment env,
    required bool isUp,
    required int? statusCode,
    required String? errorMessage,
  }) async {
    final hooks = await _db.getActiveWebhooks();
    if (hooks.isEmpty) return;
    final trigger = isUp ? 'up' : 'down';

    for (final hook in hooks) {
      if (hook.triggerOn != 'any' && hook.triggerOn != trigger) continue;
      try {
        await _dispatch(hook, service, env, isUp, statusCode, errorMessage);
      } catch (_) {
        // webhooks fail silently — they shouldn't break monitoring
      }
    }
  }

  Future<Response> sendTest(Webhook hook) {
    return _dispatch(
      hook,
      Service(id: 0, name: 'Pulse', description: 'Test', createdAt: DateTime.now()),
      Environment(
        id: 0,
        serviceId: 0,
        name: 'test',
        url: 'https://example.com',
        role: '',
        method: 'GET',
        headersJson: '{}',
        body: '',
        matchType: 'status',
        matchValue: '200',
        statusRangeFrom: 200,
        statusRangeTo: 299,
        timeoutMs: 10000,
        checkIntervalSeconds: 60,
        isActive: true,
        createdAt: DateTime.now(),
      ),
      false,
      503,
      'Disparo de teste do Pulse',
    );
  }

  Future<Response<dynamic>> _dispatch(
    Webhook hook,
    Service service,
    Environment env,
    bool isUp,
    int? statusCode,
    String? errorMessage,
  ) {
    final emoji = isUp ? ':large_green_circle:' : ':red_circle:';
    final state = isUp ? 'UP' : 'DOWN';
    final detail = errorMessage ?? 'status ${statusCode ?? '?'}';
    final headline =
        'Pulse · ${service.name} / ${env.name} → $state ($detail)';

    final body = switch (hook.type) {
      'slack' => {
          'text': '$emoji $headline',
          'attachments': [
            {
              'color': isUp ? '#34F5B6' : '#FF4D6D',
              'fields': [
                {'title': 'URL', 'value': env.url, 'short': false},
              ],
            }
          ]
        },
      'discord' => {
          'username': 'Pulse',
          'embeds': [
            {
              'title': headline,
              'description': env.url,
              'color': isUp ? 3471286 : 16732013,
            }
          ]
        },
      _ => {
          'service': service.name,
          'environment': env.name,
          'url': env.url,
          'is_up': isUp,
          'status_code': statusCode,
          'error': errorMessage,
          'at': DateTime.now().toIso8601String(),
        }
    };

    return _dio.post(hook.url, data: body);
  }
}

final webhookServiceProvider = Provider<WebhookService>((ref) {
  return WebhookService(ref.watch(databaseProvider));
});

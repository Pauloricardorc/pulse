import 'dart:convert';

/// Decides whether a HTTP response counts as "up" given the environment's
/// configured matcher.
class ResponseMatcher {
  static const types = <String>['status', 'range', 'contains', 'regex', 'jsonpath'];

  /// Returns `(isUp, reason?)`. `reason` is set when the check failed and
  /// explains why so we can store a human-readable error.
  static (bool, String?) evaluate({
    required String matchType,
    required String matchValue,
    required int rangeFrom,
    required int rangeTo,
    required int? statusCode,
    required String body,
  }) {
    switch (matchType) {
      case 'status':
        final expected = int.tryParse(matchValue.trim()) ?? 200;
        if (statusCode == expected) return (true, null);
        return (false, 'Esperado status $expected, recebido ${statusCode ?? '?'}');

      case 'range':
        if (statusCode == null) return (false, 'Sem resposta HTTP');
        if (statusCode >= rangeFrom && statusCode <= rangeTo) return (true, null);
        return (
          false,
          'Status $statusCode fora do range $rangeFrom-$rangeTo',
        );

      case 'contains':
        if (body.contains(matchValue)) return (true, null);
        return (false, 'Body não contém "$matchValue"');

      case 'regex':
        try {
          final re = RegExp(matchValue);
          if (re.hasMatch(body)) return (true, null);
          return (false, 'Body não bate com regex /$matchValue/');
        } catch (_) {
          return (false, 'Regex inválida: $matchValue');
        }

      case 'jsonpath':
        // Minimal dotted-path support: `data.user.id` or `result[0].status`.
        try {
          final parsed = jsonDecode(body);
          final value = _resolveDotPath(parsed, matchValue);
          if (value == null) {
            return (false, 'Caminho $matchValue não encontrado');
          }
          return (true, null);
        } catch (e) {
          return (false, 'Resposta não é JSON válido');
        }

      default:
        return (false, 'Matcher desconhecido: $matchType');
    }
  }

  static dynamic _resolveDotPath(dynamic root, String path) {
    final segments = path.split('.');
    dynamic node = root;
    for (final raw in segments) {
      if (node == null) return null;
      final indexMatch = RegExp(r'^(.+?)\[(\d+)\]$').firstMatch(raw);
      if (indexMatch != null) {
        final key = indexMatch.group(1)!;
        final idx = int.parse(indexMatch.group(2)!);
        if (node is Map && node.containsKey(key)) node = node[key];
        if (node is List && idx < node.length) {
          node = node[idx];
        } else {
          return null;
        }
      } else {
        if (node is Map && node.containsKey(raw)) {
          node = node[raw];
        } else if (node is List) {
          final idx = int.tryParse(raw);
          if (idx == null || idx >= node.length) return null;
          node = node[idx];
        } else {
          return null;
        }
      }
    }
    return node;
  }
}

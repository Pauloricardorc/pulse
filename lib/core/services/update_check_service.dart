import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateInfo {
  final String version;
  final String title;
  final String htmlUrl;
  final String body;
  UpdateInfo({
    required this.version,
    required this.title,
    required this.htmlUrl,
    required this.body,
  });
}

/// Hit the GitHub Releases API once at startup. Returns null when current
/// is already the latest (or check failed) so the banner stays hidden.
///
/// On Windows and macOS the `auto_updater` package already shows a native
/// Sparkle/WinSparkle popup — we don't want to duplicate that with a banner,
/// so this returns null on those platforms.
Future<UpdateInfo?> _checkLatestRelease() async {
  if (!Platform.isLinux) return null;

  const owner = 'Pauloricardorc';
  const repo = 'pulse';
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 6),
    receiveTimeout: const Duration(seconds: 6),
  ));

  try {
    final r = await dio.get(
      'https://api.github.com/repos/$owner/$repo/releases/latest',
      options: Options(
        headers: {'Accept': 'application/vnd.github+json'},
        validateStatus: (_) => true,
      ),
    );
    if (r.statusCode != 200 || r.data is! Map) return null;
    final data = r.data as Map;

    final tag = (data['tag_name'] as String? ?? '').replaceFirst('v', '');
    if (tag.isEmpty) return null;

    final info = await PackageInfo.fromPlatform();
    if (_compareVersions(tag, info.version) <= 0) return null;

    return UpdateInfo(
      version: tag,
      title: (data['name'] as String? ?? '').isEmpty
          ? 'Nova versão disponível'
          : data['name'] as String,
      htmlUrl: data['html_url'] as String? ??
          'https://github.com/$owner/$repo/releases/latest',
      body: data['body'] as String? ?? '',
    );
  } catch (_) {
    return null;
  }
}

/// Compare semver-ish strings. Positive = a > b.
int _compareVersions(String a, String b) {
  final pa = a.split('.').map(int.tryParse).toList();
  final pb = b.split('.').map(int.tryParse).toList();
  for (var i = 0; i < pa.length || i < pb.length; i++) {
    final x = i < pa.length ? pa[i] ?? 0 : 0;
    final y = i < pb.length ? pb[i] ?? 0 : 0;
    if (x != y) return x.compareTo(y);
  }
  return 0;
}

final updateCheckProvider = FutureProvider<UpdateInfo?>((ref) async {
  return _checkLatestRelease();
});

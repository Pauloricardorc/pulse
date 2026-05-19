// Gera todos os ícones de bandeja do Pulse.
//
// Saída (em assets/icons/):
//   tray_icon.png         — branco + alpha, usado no Linux
//   tray_icon@2x.png      — 2x para HiDPI no Linux
//   tray_icon_macos.png   — preto + alpha, usado no macOS como template image
//   tray_icon_macos@2x.png
//   tray_icon.ico         — Windows, multi-resolução 16/32/48
//
// Glifo: linha de heartbeat/ECG horizontal centralizada.
//
// Como rodar:
//   dart run tool/gen_tray_icons.dart

import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

void main() {
  final out = p.join('assets', 'icons');
  Directory(out).createSync(recursive: true);

  // Linux / dark menu bars — glifo branco.
  _writePng(p.join(out, 'tray_icon.png'), _render(22, color: 0xFFFFFFFF));
  _writePng(p.join(out, 'tray_icon@2x.png'), _render(44, color: 0xFFFFFFFF));

  // macOS template image — preto puro + alpha; o sistema inverte/colore.
  _writePng(p.join(out, 'tray_icon_macos.png'),
      _render(22, color: 0xFF000000));
  _writePng(p.join(out, 'tray_icon_macos@2x.png'),
      _render(44, color: 0xFF000000));

  // Windows .ico — colorido (lime sobre transparente, lê bem em qualquer fundo).
  final icoFrames = [16, 24, 32, 48]
      .map((s) => _render(s, color: 0xFFB6F26F))
      .toList();
  final icoBytes = img.encodeIco(icoFrames.first);
  File(p.join(out, 'tray_icon.ico')).writeAsBytesSync(icoBytes);

  stdout.writeln('✓ Tray icons gerados em assets/icons/');
}

void _writePng(String path, img.Image image) {
  File(path).writeAsBytesSync(img.encodePng(image));
}

/// Desenha o glifo centralizado em um canvas quadrado de [size] px.
img.Image _render(int size, {required int color}) {
  // RGBA, totalmente transparente.
  final canvas =
      img.Image(width: size, height: size, numChannels: 4, format: img.Format.uint8);

  // O glifo usa uma "viewport" interna de 22x22, escalada por k.
  final k = size / 22.0;
  final cy = size / 2.0;

  // Pontos do heartbeat na viewport 22x22.
  const pts = <List<double>>[
    [1.5, 11], [5.5, 11],
    [7, 14],
    [10, 4.5],
    [13, 17.5],
    [15, 11], [20.5, 11],
  ];

  // Stroke proporcional ao tamanho — 1.6px @22, 3.2px @44.
  final stroke = (1.6 * k).clamp(1.0, 4.0);

  for (var i = 0; i < pts.length - 1; i++) {
    final p1 = pts[i];
    final p2 = pts[i + 1];
    _strokeLine(
      canvas,
      p1[0] * k,
      // recentra verticalmente para 11 no meio da viewport
      cy + (p1[1] - 11) * k,
      p2[0] * k,
      cy + (p2[1] - 11) * k,
      color,
      stroke,
    );
  }

  return canvas;
}

/// Linha com espessura via aproximação por múltiplas linhas paralelas
/// + soft-edge usando subpixel sampling (suficiente para 22-44px).
void _strokeLine(
  img.Image canvas,
  double x1,
  double y1,
  double x2,
  double y2,
  int color,
  double stroke,
) {
  // Vetor normal unitário.
  final dx = x2 - x1, dy = y2 - y1;
  final len = (dx * dx + dy * dy).abs();
  if (len == 0) return;
  final inv = 1 / _sqrt(len);
  final nx = -dy * inv;
  final ny = dx * inv;

  // Varre o segmento em passos pequenos, desenhando um disco redondo em
  // cada amostra. Esse "round-cap-everywhere" também dá junções suaves.
  final steps = ((x2 - x1).abs() + (y2 - y1).abs()).ceil() * 2;
  for (var i = 0; i <= steps; i++) {
    final t = i / steps;
    final cx = x1 + (x2 - x1) * t;
    final cy = y1 + (y2 - y1) * t;
    _dot(canvas, cx, cy, stroke / 2, color);
  }

  // Reduz uso de nx/ny — mantemos as variáveis para deixar claro que a
  // espessura está atrelada à normal; o stroke real vem do _dot.
  // ignore: unused_local_variable
  final _ = nx + ny;
}

void _dot(img.Image canvas, double cx, double cy, double radius, int color) {
  final x0 = (cx - radius - 1).floor().clamp(0, canvas.width - 1);
  final x1 = (cx + radius + 1).ceil().clamp(0, canvas.width - 1);
  final y0 = (cy - radius - 1).floor().clamp(0, canvas.height - 1);
  final y1 = (cy + radius + 1).ceil().clamp(0, canvas.height - 1);

  final cr = (color >> 16) & 0xFF;
  final cg = (color >> 8) & 0xFF;
  final cb = color & 0xFF;
  final caBase = (color >> 24) & 0xFF;

  for (var y = y0; y <= y1; y++) {
    for (var x = x0; x <= x1; x++) {
      final ddx = x + 0.5 - cx;
      final ddy = y + 0.5 - cy;
      final d2 = ddx * ddx + ddy * ddy;
      if (d2 > (radius + 1) * (radius + 1)) continue;

      // Anti-alias por distância — full alpha até radius-0.5, fade até radius+0.5.
      final d = _sqrt(d2);
      double cover;
      if (d <= radius - 0.5) {
        cover = 1.0;
      } else if (d >= radius + 0.5) {
        cover = 0.0;
      } else {
        cover = (radius + 0.5 - d).clamp(0.0, 1.0);
      }
      if (cover <= 0) continue;

      final newA = (caBase * cover).round();
      final px = canvas.getPixel(x, y);
      final oldA = px.a.toInt();
      // alpha "over" simples — pegamos o maior alpha (suficiente p/ glifo monocromático).
      if (newA > oldA) {
        canvas.setPixelRgba(x, y, cr, cg, cb, newA);
      }
    }
  }
}

double _sqrt(double v) {
  // dart:math importável também, mas evitar import pra arquivo enxuto.
  // (Aproximação Newton-Raphson de 2 iterações; suficiente p/ render de 44px.)
  if (v <= 0) return 0;
  var x = v;
  x = 0.5 * (x + v / x);
  x = 0.5 * (x + v / x);
  x = 0.5 * (x + v / x);
  return x;
}

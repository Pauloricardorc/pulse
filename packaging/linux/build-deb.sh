#!/usr/bin/env bash
# Gera o pacote .deb do Pulse a partir do bundle Linux do Flutter.
# Pressupõe que `flutter build linux --release` já foi executado.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BUNDLE="$ROOT/build/linux/x64/release/bundle"
DIST="$ROOT/packaging/linux/dist"
STAGE="$ROOT/packaging/linux/pulse-deb"

VERSION="$(grep -E '^version:' "$ROOT/pubspec.yaml" | awk '{print $2}' | cut -d+ -f1)"

rm -rf "$STAGE"
mkdir -p "$STAGE/DEBIAN" \
         "$STAGE/opt/pulse" \
         "$STAGE/usr/bin" \
         "$STAGE/usr/share/applications" \
         "$STAGE/usr/share/icons/hicolor/512x512/apps" \
         "$DIST"

cp -r "$BUNDLE"/* "$STAGE/opt/pulse/"

cat > "$STAGE/usr/bin/pulse" <<'EOF'
#!/usr/bin/env bash
exec /opt/pulse/pulse "$@"
EOF
chmod +x "$STAGE/usr/bin/pulse"

cp "$ROOT/assets/icons/app_icon.png" "$STAGE/usr/share/icons/hicolor/512x512/apps/pulse.png"

cat > "$STAGE/usr/share/applications/pulse.desktop" <<EOF
[Desktop Entry]
Name=Pulse
Comment=Monitoramento de serviços para desktop
Exec=pulse
Icon=pulse
Type=Application
Categories=Network;Monitor;Utility;
Terminal=false
EOF

cat > "$STAGE/DEBIAN/control" <<EOF
Package: pulse
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Paulo Ricardo <paulodev01@gmail.com>
Depends: libgtk-3-0, libnotify4, libsecret-1-0, libayatana-appindicator3-1
Description: Pulse — monitoramento de serviços para desktop.
 Pulse acompanha seus endpoints HTTP em tempo real: dashboards, histórico,
 incidentes, webhooks e workspaces exportáveis.
EOF

dpkg-deb --build "$STAGE" "$DIST/pulse_${VERSION}_amd64.deb"
echo "Gerado $DIST/pulse_${VERSION}_amd64.deb"

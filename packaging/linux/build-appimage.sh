#!/usr/bin/env bash
# Gera o AppImage do Pulse a partir do bundle Linux do Flutter.
# Pressupõe que `flutter build linux --release` já foi executado.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BUNDLE="$ROOT/build/linux/x64/release/bundle"
DIST="$ROOT/packaging/linux/dist"
APPDIR="$ROOT/packaging/linux/Pulse.AppDir"

VERSION="$(grep -E '^version:' "$ROOT/pubspec.yaml" | awk '{print $2}' | cut -d+ -f1)"

rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/bin" "$APPDIR/usr/share/applications" "$APPDIR/usr/share/icons/hicolor/512x512/apps" "$DIST"

cp -r "$BUNDLE"/* "$APPDIR/usr/bin/"

cp "$ROOT/assets/icons/app_icon.png" "$APPDIR/usr/share/icons/hicolor/512x512/apps/pulse.png"
cp "$ROOT/assets/icons/app_icon.png" "$APPDIR/pulse.png"

cat > "$APPDIR/pulse.desktop" <<EOF
[Desktop Entry]
Name=Pulse
Comment=Monitoramento de serviços para desktop
Exec=pulse
Icon=pulse
Type=Application
Categories=Network;Monitor;Utility;
Terminal=false
EOF

cp "$APPDIR/pulse.desktop" "$APPDIR/usr/share/applications/pulse.desktop"

cat > "$APPDIR/AppRun" <<'EOF'
#!/usr/bin/env bash
HERE="$(dirname "$(readlink -f "$0")")"
export LD_LIBRARY_PATH="$HERE/usr/bin/lib:${LD_LIBRARY_PATH:-}"
exec "$HERE/usr/bin/pulse" "$@"
EOF
chmod +x "$APPDIR/AppRun"

APPIMAGETOOL="$ROOT/packaging/linux/appimagetool"
if [ ! -x "$APPIMAGETOOL" ]; then
  curl -L --silent --show-error \
    "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" \
    -o "$APPIMAGETOOL"
  chmod +x "$APPIMAGETOOL"
fi

ARCH=x86_64 "$APPIMAGETOOL" "$APPDIR" "$DIST/Pulse-$VERSION-x86_64.AppImage"
echo "Gerado $DIST/Pulse-$VERSION-x86_64.AppImage"

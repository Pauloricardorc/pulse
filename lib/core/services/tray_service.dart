import 'dart:io';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class TrayService with TrayListener {
  Future<void> init() async {
    trayManager.addListener(this);
    final iconPath =
        Platform.isWindows ? 'assets/icons/tray_icon.ico' : 'assets/icons/tray_icon.png';
    try {
      await trayManager.setIcon(iconPath);
    } catch (_) {
      // tray icon may not be present on every platform — fail soft
    }
    await trayManager.setToolTip('Pulse — monitoring');
    await trayManager.setContextMenu(Menu(items: [
      MenuItem(key: 'show', label: 'Mostrar Pulse'),
      MenuItem.separator(),
      MenuItem(key: 'quit', label: 'Sair'),
    ]));
  }

  void dispose() => trayManager.removeListener(this);

  @override
  void onTrayIconMouseDown() async {
    await windowManager.show();
    await windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() => trayManager.popUpContextMenu();

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'show':
        await windowManager.show();
        await windowManager.focus();
        break;
      case 'quit':
        await trayManager.destroy();
        exit(0);
    }
  }
}

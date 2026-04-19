import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/constants/auth_constants.dart';
import '../di/service_locator.dart';

class AppInitializer {
  const AppInitializer._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(AuthConstants.authHiveBoxName);
    await _configureDesktopWindow();
    await initServiceLocator();
  }

  static Future<void> _configureDesktopWindow() async {
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
      return;
    }

    await windowManager.ensureInitialized();
    final screenSize = await windowManager.getSize();
    final initialWidth = (screenSize.width * 0.7).clamp(1280.0, 1920.0);
    final initialHeight = (screenSize.height * 0.7).clamp(720.0, 1080.0);

    final windowOptions = WindowOptions(
      size: Size(initialWidth, initialHeight),
      minimumSize: const Size(1280, 720),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'BAZAAR Pro',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:musily/core/data/database/database.dart';
import 'package:musily/core/data/repositories/musily_repository_impl.dart';
import 'package:musily/core/data/services/library_migration.dart';
import 'package:musily/core/data/services/tray_service.dart';
import 'package:musily/core/data/services/window_service.dart';
import 'package:musily/features/player/data/services/musily_service.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/presenter/widgets/app_material.dart';
import 'package:musily/core/core_module.dart';

final mediaStorePlugin = MediaStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database().init();

  if (Platform.isAndroid) {
    await MediaStore.ensureInitialized();
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await WindowService.init();
    await TrayService.init();
  }

  final userService = UserService();
  final libraryMigrationService = LibraryMigrationService();
  final musilyRepository = MusilyRepositoryImpl();

  await libraryMigrationService.migrateLibrary();
  await musilyRepository.initialize();
  await userService.initialize();

  await MusilyService.init(
    config: MusilyServiceConfig(
      androidNotificationChannelId: 'app.musily.music.dev',
      androidNotificationChannelName: 'Musily',
      androidNotificationIcon: 'drawable/ic_launcher_foreground',
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: false,
    ),
  );
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.002),
        systemNavigationBarColor: Colors.black.withOpacity(0.002),
      ),
    );
  }
  runApp(
    ModularApp(
      module: CoreModule(),
      child: const AppMaterial(),
    ),
  );
}

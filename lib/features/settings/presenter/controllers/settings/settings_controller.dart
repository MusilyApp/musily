import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musily/core/data/services/tray_service.dart';
import 'package:musily/core/data/services/window_service.dart';
import 'package:musily/core/domain/adapters/http_adapter.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/settings/domain/enums/accent_color_preference.dart';
import 'package:musily/features/settings/domain/enums/close_preference.dart';
import 'package:musily/features/settings/domain/entities/supporter_entity.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_data.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_methods.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class SettingsController extends BaseController<SettingsData, SettingsMethods> {
  static const _remoteSupportersUrl =
      'https://raw.githubusercontent.com/MusilyApp/musily/refs/heads/main/assets/supporters.json';
  static const _localSupportersAssetPath = 'assets/supporters.json';

  late final HttpAdapter _httpAdapter;

  SettingsController({
    required HttpAdapter httpAdapter,
  }) {
    _httpAdapter = httpAdapter;
    methods.loadLanguage();
    methods.loadThemeMode();
    methods.loadClosePreference();
    methods.loadAccentColorPreference();
    methods.loadSupporters();
    showSyncSection = httpAdapter.baseUrl.isNotEmpty;
  }

  bool showSyncSection = false;

  @override
  SettingsData defineData() {
    return SettingsData();
  }

  @override
  SettingsMethods defineMethods() {
    return SettingsMethods(
      loadClosePreference: () async {
        final prefs = await SharedPreferences.getInstance();
        final closePreference = ClosePreference.values.byName(
          prefs.getString('settings.app.close') ?? 'hide',
        );
        WindowService.setPreventClose(closePreference);
        updateData(
          data.copyWith(
            closePreference: closePreference,
          ),
        );
        while (data.context == null) {
          await Future.delayed(
            const Duration(
              seconds: 1,
            ),
          );
        }
        TrayService.initContextMenu(data.context!);
      },
      setClosePreference: (preference) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('settings.app.close', preference.name);
        await WindowService.setPreventClose(preference);
        updateData(
          data.copyWith(closePreference: preference),
        );
      },
      setBrightness: () async {
        if (!Platform.isAndroid) {
          return;
        }
        while (data.context == null) {
          await Future.delayed(
            const Duration(
              seconds: 1,
            ),
          );
        }
        if (data.context!.themeMode == ThemeMode.dark) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarColor: Colors.black.withValues(alpha: 0.002),
              systemNavigationBarColor: Colors.black,
            ),
          );
        } else {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.black.withValues(alpha: 0.002),
              systemNavigationBarColor: Colors.black,
            ),
          );
        }
      },
      loadThemeMode: () async {
        final prefs = await SharedPreferences.getInstance();
        final savedThemeMode = prefs.getString('themeMode');
        data.themeMode = ThemeMode.values.byName(
          savedThemeMode ?? 'system',
        );
        methods.setBrightness();
      },
      changeLanguage: (locale) async {
        if (locale == null) {
          return;
        }
        data.locale = Locale(locale);
        updateData(data);
        TrayService.initContextMenu(
          data.context!,
          locale: Locale(locale),
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('locale', locale);
      },
      changeTheme: (mode) async {
        data.themeMode = mode;
        updateData(data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'themeMode',
          mode?.name ?? 'system',
        );
        methods.setBrightness();
      },
      loadLanguage: () async {
        final prefs = await SharedPreferences.getInstance();
        final savedLocale = prefs.getString('locale');
        if (savedLocale != null) {
          data.locale = Locale(savedLocale);
          updateData(data);
        } else {
          while (data.context == null) {
            await Future.delayed(
              const Duration(
                seconds: 1,
              ),
            );
          }
          data.locale = Locale(
            data.context!.localization.localeName,
          );
          updateData(data);
          methods.changeLanguage(data.locale.toString());
        }
      },
      setAccentColorPreference: (preference) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accentColorPreference', preference.name);
        updateData(data.copyWith(accentColorPreference: preference));
      },
      loadAccentColorPreference: () async {
        final prefs = await SharedPreferences.getInstance();
        final savedAccentColorPreference =
            prefs.getString('accentColorPreference');
        data.accentColorPreference = AccentColorPreference.values.byName(
          savedAccentColorPreference ?? 'playingNow',
        );
        updateData(data);
      },
      updatePlayerAccentColor: (imageUrl) async {
        final colorScheme = await ColorScheme.fromImageProvider(
          provider: NetworkImage(imageUrl),
        );
        final primaryColor = colorScheme.primary;
        updateData(data.copyWith(playerAccentColor: primaryColor));
      },
      loadSupporters: ({bool forceRefresh = false}) async {
        if (data.loadingSupporters) {
          return;
        }
        if (!forceRefresh && data.supporters.isNotEmpty) {
          return;
        }
        updateData(
          data.copyWith(
            loadingSupporters: true,
          ),
        );
        List<SupporterEntity> supporters = const [];
        try {
          supporters = await _fetchRemoteSupporters();
        } catch (_) {
          // Ignore errors, fallback handled below.
        }
        if (supporters.isEmpty) {
          supporters = await _loadLocalSupporters();
        }
        updateData(
          data.copyWith(
            supporters: supporters,
            loadingSupporters: false,
          ),
        );
      },
      uninstallApp: () async {
        if (!Platform.isLinux) {
          return;
        }

        final homeDir = Platform.environment['HOME'];
        if (homeDir == null) {
          throw Exception('HOME environment variable not found');
        }

        final uninstallerDir = path.join(
          homeDir,
          '.musily',
          'data',
          'flutter_assets',
          'assets',
          'uninstaller',
        );

        final tarGzPath = path.join(uninstallerDir, 'musily_installer.tar.gz');
        final extractedDir = path.join(uninstallerDir, 'musily_installer');
        final binaryPath = path.join(extractedDir, 'musily_installer');

        String executablePath;

        final tarGzFile = File(tarGzPath);
        final extractedBinary = File(binaryPath);

        if (await extractedBinary.exists()) {
          executablePath = binaryPath;
        } else if (await tarGzFile.exists()) {
          final bytes = await tarGzFile.readAsBytes();
          final archive = TarDecoder().decodeBytes(
            GZipDecoder().decodeBytes(bytes),
          );

          final extractDir = Directory(extractedDir);
          if (!await extractDir.exists()) {
            await extractDir.create(recursive: true);
          }

          String? foundBinaryPath;

          for (final file in archive) {
            if (file.isFile) {
              final filePath = path.join(extractedDir, file.name);
              final outFile = File(filePath);
              await outFile.parent.create(recursive: true);
              await outFile.writeAsBytes(file.content as List<int>);

              if (file.name == 'musily_installer') {
                foundBinaryPath = filePath;
              }
            }
          }

          if (foundBinaryPath != null) {
            await Process.run('chmod', ['+x', foundBinaryPath]);
            executablePath = foundBinaryPath;
          } else if (await extractedBinary.exists()) {
            await Process.run('chmod', ['+x', binaryPath]);
            executablePath = binaryPath;
          } else {
            throw Exception('Uninstaller binary not found after extraction');
          }
        } else {
          throw Exception('Uninstaller not found');
        }

        await Process.run(executablePath, []);
      },
    );
  }

  Future<List<SupporterEntity>> _fetchRemoteSupporters() async {
    try {
      final response = await _httpAdapter.get(_remoteSupportersUrl);
      if (response.statusCode == 200) {
        return _sortSupporters(
          SupporterEntity.listFromDynamic(response.data),
        );
      }
    } catch (_) {
      rethrow;
    }
    return const [];
  }

  Future<List<SupporterEntity>> _loadLocalSupporters() async {
    try {
      final content = await rootBundle.loadString(_localSupportersAssetPath);
      return _sortSupporters(
        SupporterEntity.listFromDynamic(content),
      );
    } catch (_) {
      return const [];
    }
  }

  List<SupporterEntity> _sortSupporters(List<SupporterEntity> supporters) {
    final sorted = List<SupporterEntity>.from(supporters);
    sorted.sort((a, b) => b.amount.compareTo(a.amount));
    return sorted;
  }
}

import 'dart:io';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/data/services/musily_android_handler.dart';
import 'package:musily/features/player/data/services/musily_audio_handler.dart';
import 'package:musily/features/player/data/services/musily_desktop_handler.dart';
import 'package:musily/features/player/data/services/musily_player.dart';

class MusilyServiceConfig {
  bool androidResumeOnClick;
  String? androidNotificationChannelId;
  String androidNotificationChannelName;
  String? androidNotificationChannelDescription;
  Color? notificationColor;
  String androidNotificationIcon;
  bool androidShowNotificationBadge;
  bool androidNotificationClickStartsActivity;
  bool androidNotificationOngoing;
  bool androidStopForegroundOnPause;
  int? artDownscaleWidth;
  int? artDownscaleHeight;
  Duration fastForwardInterval = const Duration(seconds: 10);
  Duration rewindInterval = const Duration(seconds: 10);
  bool preloadArtwork;
  Map<String, dynamic>? androidBrowsableRootExtras;

  MusilyServiceConfig({
    this.androidResumeOnClick = true,
    this.androidNotificationChannelId,
    this.androidNotificationChannelName = 'Notifications',
    this.androidNotificationChannelDescription,
    this.notificationColor,
    this.androidNotificationIcon = 'mipmap/ic_launcher',
    this.androidShowNotificationBadge = false,
    this.androidNotificationClickStartsActivity = true,
    this.androidNotificationOngoing = false,
    this.androidStopForegroundOnPause = true,
    this.artDownscaleWidth,
    this.artDownscaleHeight,
    this.preloadArtwork = false,
    this.androidBrowsableRootExtras,
  });

  AudioServiceConfig toAudioServiceConfig() {
    return AudioServiceConfig(
      androidResumeOnClick: androidResumeOnClick,
      androidNotificationChannelId: androidNotificationChannelId,
      androidNotificationChannelName: androidNotificationChannelName,
      androidNotificationChannelDescription:
          androidNotificationChannelDescription,
      notificationColor: notificationColor,
      androidNotificationIcon: androidNotificationIcon,
      androidShowNotificationBadge: androidShowNotificationBadge,
      androidNotificationClickStartsActivity:
          androidNotificationClickStartsActivity,
      androidNotificationOngoing: androidNotificationOngoing,
      androidStopForegroundOnPause: androidStopForegroundOnPause,
      artDownscaleWidth: artDownscaleWidth,
      artDownscaleHeight: artDownscaleHeight,
      fastForwardInterval: fastForwardInterval,
      rewindInterval: rewindInterval,
      preloadArtwork: preloadArtwork,
      androidBrowsableRootExtras: androidBrowsableRootExtras,
    );
  }
}

class MusilyService {
  static Future<void> init({
    required MusilyServiceConfig config,
  }) async {
    JustAudioMediaKit.ensureInitialized(
      android: true,
      linux: true,
      windows: true,
    );
    late final BaseAudioHandler platformAudioHandler;
    if (Platform.isAndroid) {
      platformAudioHandler = MusilyAndroidHandler();
    }
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      platformAudioHandler = MusilyDesktopHandler();
    }
    final audioHandler = await AudioService.init<BaseAudioHandler>(
      builder: () => platformAudioHandler,
      config: config.toAudioServiceConfig(),
    );
    MusilyPlayer().setAudioHandler(audioHandler as MusilyAudioHandler);
    final downloaderController = DownloaderController();
    await downloaderController.init();
  }
}

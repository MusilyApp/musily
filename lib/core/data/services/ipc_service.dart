// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dart_ipc/dart_ipc.dart' as ipc;
import 'package:musily/core/data/services/window_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class IPCService {
  static Future<String> getIpcPath() async {
    if (Platform.isWindows) {
      return r'\\.\pipe\musily_ipc';
    } else {
      final dir = await getApplicationSupportDirectory();
      return path.join(dir.path, 'musily.sock');
    }
  }

  static Future<void> cleanupSocket() async {
    try {
      final socketPath = await getIpcPath();
      if (!Platform.isWindows) {
        final socketFile = File(socketPath);
        if (await socketFile.exists()) {
          await socketFile.delete();
        }
      }
    } catch (e) {
      print('Error cleaning up socket: $e');
    }
  }

  static Future<bool> initializeIpcServer() async {
    final socketPath = await getIpcPath();

    try {
      if (await _tryConnectExisting(socketPath)) {
        return false;
      }

      final server = await ipc.bind(socketPath);

      _setupSignalHandlers();

      server.listen((socket) {
        socket.listen(
          (data) {
            if (utf8.decode(data) == 'show_window') {
              WindowService.showWindow();
            }
          },
          onError: (e) => print('Server socket error: $e'),
          onDone: () => print('Client disconnected'),
        );
      });

      print('IPC server started successfully');
      return true;
    } catch (e) {
      print('Failed to initialize IPC server: $e');
      return false;
    }
  }

  static Future<bool> _tryConnectExisting(String socketPath) async {
    try {
      print('Trying to connect to existing instance at $socketPath');
      final socket = await ipc.connect(socketPath).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );

      print('Connected to existing instance, sending show_window command');
      socket.add(utf8.encode('show_window'));
      await socket.flush();

      await Future.delayed(const Duration(milliseconds: 300));

      await socket.close();
      print('Successfully notified existing instance');
      return true;
    } catch (e) {
      print('Failed to connect to existing instance: $e');

      if (Platform.isWindows) {
        await Future.delayed(const Duration(milliseconds: 200));
      } else {
        await cleanupSocket();
      }

      return false;
    }
  }

  static void _setupSignalHandlers() {
    if (!Platform.isWindows) {
      ProcessSignal.sigint.watch().listen((_) async {
        await cleanupSocket();
        exit(0);
      });
      ProcessSignal.sigterm.watch().listen((_) async {
        await cleanupSocket();
        exit(0);
      });
    } else {
      ProcessSignal.sigint.watch().listen((_) => exit(0));
    }
  }

  static Future<bool> isAnotherInstanceRunning() async {
    final socketPath = await getIpcPath();
    try {
      final socket = await ipc.connect(socketPath).timeout(
            const Duration(milliseconds: 500),
          );
      await socket.close();
      return true;
    } catch (e) {
      return false;
    }
  }
}

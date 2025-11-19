// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dart_ipc/dart_ipc.dart' as ipc;
import 'package:musily/core/data/services/ipc_service.dart';
import 'package:musily/core/data/services/window_service.dart';

class IPCServiceWindows implements IPCService {
  Future<String> getIpcPath() async {
    return r'\\.\pipe\musily_ipc';
  }

  Future<void> cleanupSocket() async {
    try {
      await getIpcPath();
    } catch (e) {
      print('Error cleaning up socket: $e');
    }
  }

  @override
  Future<bool> initializeIpcServer() async {
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

  Future<bool> _tryConnectExisting(String socketPath) async {
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

      await Future.delayed(const Duration(milliseconds: 200));

      return false;
    }
  }

  void _setupSignalHandlers() {
    ProcessSignal.sigint.watch().listen((_) async {
      await cleanupSocket();
      exit(0);
    });
    ProcessSignal.sigterm.watch().listen((_) async {
      await cleanupSocket();
      exit(0);
    });
  }

  Future<bool> isAnotherInstanceRunning() async {
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

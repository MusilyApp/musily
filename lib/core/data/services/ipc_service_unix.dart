// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dart_ipc/dart_ipc.dart' as ipc;
import 'package:musily/core/data/services/ipc_service.dart';
import 'package:musily/core/data/services/window_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class IPCServiceUnix implements IPCService {
  Future<String> getIpcPath() async {
    final dir = await getApplicationSupportDirectory();
    return path.join(dir.path, 'musily.sock');
  }

  Future<void> cleanupSocket() async {
    try {
      final socketPath = await getIpcPath();
      final socketFile = File(socketPath);
      if (await socketFile.exists()) {
        await socketFile.delete();
      }
    } catch (e) {
      print('Error cleaning up socket: $e');
    }
  }

  @override
  Future<bool> initializeIpcServer() async {
    final socketPath = await getIpcPath();

    try {
      final server = await ipc.bind(socketPath);

      ProcessSignal.sigint.watch().listen((_) async {
        await cleanupSocket();
        exit(0);
      });
      ProcessSignal.sigterm.watch().listen((_) async {
        await cleanupSocket();
        exit(0);
      });

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
      return true;
    } catch (e) {
      try {
        final socket = await ipc.connect(socketPath);
        socket.add(utf8.encode('show_window'));
        await socket.close();
        return false;
      } catch (e) {
        print(
          'Failed to connect to existing instance, cleaning up stale socket',
        );
        await cleanupSocket();
        try {
          final server = await ipc.bind(socketPath);
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
          return true;
        } catch (e) {
          print('Failed to create server after cleanup: $e');
          return false;
        }
      }
    }
  }
}

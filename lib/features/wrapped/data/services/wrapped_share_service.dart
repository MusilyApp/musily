import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class WrappedShareService {
  static Future<void> captureAndShare({
    required ScreenshotController controller,
    required BuildContext context,
    String? fileName,
  }) async {
    try {
      final subject = context.localization.wrappedShareSubject;
      final text = context.localization.wrappedShareText;

      _showLoadingDialog(context);

      final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final Uint8List? imageBytes = await controller.capture(
        delay: const Duration(milliseconds: 100),
        pixelRatio: pixelRatio.clamp(2.0, 3.0),
      );

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (imageBytes == null) {
        if (context.mounted) {
          _showErrorSnackBar(context, context.localization.wrappedCaptureError);
        }
        return;
      }

      final directory = await getTemporaryDirectory();
      final String name =
          fileName ?? 'musily_wrapped_${DateTime.now().millisecondsSinceEpoch}';
      final String filePath = '${directory.path}/$name.png';
      final File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(filePath)],
        subject: subject,
        text: text,
      );

      Future.delayed(const Duration(seconds: 30), () {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        _showErrorSnackBar(
          context,
          context.localization.wrappedShareError(e.toString()),
        );
      }
    }
  }

  static Future<void> captureWidgetAndShare({
    required Widget widget,
    required BuildContext context,
    String? fileName,
    double? targetWidth,
    double? targetHeight,
  }) async {
    try {
      final subject = context.localization.wrappedShareSubject;
      final text = context.localization.wrappedShareText;

      _showLoadingDialog(context);

      final controller = ScreenshotController();
      final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

      final imageBytes = await controller.captureFromWidget(
        InheritedTheme.captureAll(
          context,
          MediaQuery(
            data: MediaQuery.of(context),
            child: Material(
              color: Colors.transparent,
              child: widget,
            ),
          ),
        ),
        delay: const Duration(milliseconds: 100),
        pixelRatio: pixelRatio.clamp(2.0, 3.0),
        targetSize: targetWidth != null && targetHeight != null
            ? Size(targetWidth, targetHeight)
            : null,
        context: context,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      final directory = await getTemporaryDirectory();
      final String name =
          fileName ?? 'musily_wrapped_${DateTime.now().millisecondsSinceEpoch}';
      final String filePath = '${directory.path}/$name.png';
      final File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(filePath)],
        subject: subject,
        text: text,
      );

      Future.delayed(const Duration(seconds: 30), () {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        _showErrorSnackBar(
          context,
          context.localization.wrappedShareError(e.toString()),
        );
      }
    }
  }

  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(dialogContext).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(context.localization.wrappedPreparingImage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
}

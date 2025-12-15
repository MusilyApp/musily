import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/features/wrapped/presenter/controllers/wrapped/wrapped_controller.dart';
import 'package:musily/features/wrapped/presenter/pages/wrapped_viewer_page.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class WrappedMainPage extends StatefulWidget {
  final int? year;

  const WrappedMainPage({
    super.key,
    this.year,
  });

  @override
  State<WrappedMainPage> createState() => _WrappedMainPageState();
}

class _WrappedMainPageState extends State<WrappedMainPage> {
  late final WrappedController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WrappedController();
    _loadWrapped();
  }

  Future<void> _loadWrapped() async {
    await _controller.methods.loadOrGenerateWrapped(year: widget.year);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'WrappedPage',
      child: _controller.builder(
        builder: (context, data) {
          if (data.loading) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.localization.wrappedGenerating,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (data.error != null) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 64,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        context.localization.wrappedLoadError,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data.error!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Text(context.localization.back),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (data.wrapped == null) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.music_off,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.localization.wrappedNoData,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.localization.wrappedNoDataDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        context.localization.back,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return WrappedViewerPage(
            wrapped: data.wrapped!,
            theme: data.theme!,
          );
        },
      ),
    );
  }
}

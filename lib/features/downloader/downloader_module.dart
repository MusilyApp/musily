import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/pages/downloader_page.dart';

class DownloaderModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => DownloaderPage(
        downloaderController: Modular.get<DownloaderController>(),
        coreController: Modular.get<CoreController>(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';

enum NavigatorPages {
  sectionsPage,
  libraryPage,
  searchPage,
  searchResultsPage,
  downloaderPage,
  blankPage;

  static getRoute(NavigatorPages page) {
    switch (page) {
      case NavigatorPages.sectionsPage:
        return '/sections/';
      case NavigatorPages.libraryPage:
        return '/library/';
      case NavigatorPages.searchPage:
        return '/search/';
      case NavigatorPages.searchResultsPage:
        return '/searcher/results_page/';
      case NavigatorPages.downloaderPage:
        return '/downloader/';
      case NavigatorPages.blankPage:
        return '/blank/';
    }
  }
}

class AppNavigator {
  static navigateTo(
    NavigatorPages page, {
    dynamic arguments,
  }) {
    final route = NavigatorPages.getRoute(page);
    Modular.to.navigate(
      route,
      arguments: arguments,
    );
  }

  static push(
    BuildContext context,
    Widget widget,
  ) {
    Navigator.of(context).push(
      DownupRouter(
        builder: (context) => widget,
      ),
    );
  }
}

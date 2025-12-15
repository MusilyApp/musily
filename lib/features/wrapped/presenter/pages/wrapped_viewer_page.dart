import 'package:flutter/material.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_page_view.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/welcome_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_minutes_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_tracks_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/top_tracks_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/most_listened_track_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_albums_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/top_albums_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/most_listened_album_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_artists_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/top_artists_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/most_listened_artist_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/thank_you_wrapped_widget.dart';

class WrappedViewerPage extends StatelessWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const WrappedViewerPage({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return WrappedPageView(
      wrapped: wrapped,
      theme: theme,
      pageBuilders: _buildPageList(),
      onPageChanged: (index) {},
      onComplete: () {},
    );
  }

  List<WrappedPageBuilder> _buildPageList() {
    final List<WrappedPageBuilder> pages = [];

    pages.add((context, pageContext) => WelcomeWrappedWidget(
          wrapped: pageContext.wrapped,
          theme: pageContext.theme,
        ));

    pages.add((context, pageContext) => TotalMinutesWrappedWidget(
          wrapped: pageContext.wrapped,
          theme: pageContext.theme,
        ));

    pages.add((context, pageContext) => TotalTracksWrappedWidget(
          wrapped: pageContext.wrapped,
          theme: pageContext.theme,
        ));

    if (wrapped.topTracks.isNotEmpty) {
      pages.add((context, pageContext) => TopTracksWrappedWidget(
            wrapped: pageContext.wrapped,
            theme: pageContext.theme,
          ));
    }

    if (wrapped.mostListenedTrack != null) {
      pages.add((context, pageContext) => MostListenedTrackWrappedWidget(
            wrapped: pageContext.wrapped,
            theme: pageContext.theme,
          ));
    }

    pages.add((context, pageContext) => TotalAlbumsWrappedWidget(
          wrapped: pageContext.wrapped,
          theme: pageContext.theme,
        ));

    if (wrapped.topAlbums.isNotEmpty) {
      pages.add((context, pageContext) => TopAlbumsWrappedWidget(
            wrapped: pageContext.wrapped,
            theme: pageContext.theme,
          ));
    }

    if (wrapped.mostListenedAlbum != null) {
      pages.add((context, pageContext) => MostListenedAlbumWrappedWidget(
            wrapped: pageContext.wrapped,
            theme: pageContext.theme,
          ));
    }

    pages.add((context, pageContext) => TotalArtistsWrappedWidget(
          wrapped: pageContext.wrapped,
          theme: pageContext.theme,
        ));

    if (wrapped.topArtists.isNotEmpty) {
      pages.add((context, pageContext) => TopArtistsWrappedWidget(
            wrapped: pageContext.wrapped,
            theme: pageContext.theme,
          ));
    }

    if (wrapped.mostListenedArtist != null) {
      pages.add((context, pageContext) => MostListenedArtistWrappedWidget(
            wrapped: pageContext.wrapped,
            theme: pageContext.theme,
          ));
    }

    pages.add((context, pageContext) => ThankYouWrappedWidget(
          wrapped: pageContext.wrapped,
          theme: pageContext.theme,
        ));

    return pages;
  }
}

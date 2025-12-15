import 'package:flutter/material.dart';
import 'package:musily/core/presenter/widgets/story_page_view.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/most_listened_album_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/most_listened_artist_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/most_listened_track_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/thank_you_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/top_albums_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/top_artists_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/top_tracks_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_albums_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_artists_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_minutes_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_tracks_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/welcome_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';

class WrappedStoriesPage extends StatelessWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const WrappedStoriesPage({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final pages = [
      WelcomeWrappedWidget(wrapped: wrapped, theme: theme),
      TotalMinutesWrappedWidget(wrapped: wrapped, theme: theme),
      TotalTracksWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.topTracks.isNotEmpty)
        TopTracksWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.mostListenedTrack != null)
        MostListenedTrackWrappedWidget(wrapped: wrapped, theme: theme),
      TotalAlbumsWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.topAlbums.isNotEmpty)
        TopAlbumsWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.mostListenedAlbum != null)
        MostListenedAlbumWrappedWidget(wrapped: wrapped, theme: theme),
      TotalArtistsWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.topArtists.isNotEmpty)
        TopArtistsWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.mostListenedArtist != null)
        MostListenedArtistWrappedWidget(wrapped: wrapped, theme: theme),
      ThankYouWrappedWidget(wrapped: wrapped, theme: theme),
    ];

    return StoryPageView(
      pages: pages,
      duration: const Duration(seconds: 5),
      autoSkip: false,
      onComplete: () {
        Navigator.of(context).pop();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';

class PlaylistTileThumb extends StatelessWidget {
  final List<String> urls;
  const PlaylistTileThumb({
    required this.urls,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.outline.withOpacity(.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Builder(
            builder: (context) {
              if (urls.length >= 4) {
                return Column(
                  children: [
                    Row(
                      children: [
                        AppImage(
                          urls[0],
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                        AppImage(
                          urls[1],
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppImage(
                          urls[2],
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                        AppImage(
                          urls[3],
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ],
                );
              } else if (urls.isNotEmpty) {
                return AppImage(
                  urls[0],
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                );
              }
              return SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.playlist_play_rounded,
                  color: Theme.of(context).iconTheme.color?.withOpacity(.7),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

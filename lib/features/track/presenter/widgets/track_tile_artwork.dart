import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class TrackTileArtwork extends StatelessWidget {
  final TrackEntity track;
  const TrackTileArtwork({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          width: 1,
          color: context.themeData.colorScheme.outline.withValues(alpha: .2),
        ),
      ),
      child: Builder(
        builder: (context) {
          if (track.lowResImg != null && track.highResImg!.isNotEmpty) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                track.lowResImg!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            );
          }
          return SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              LucideIcons.music2,
              color: context.themeData.iconTheme.color?.withValues(alpha: .7),
            ),
          );
        },
      ),
    );
  }
}

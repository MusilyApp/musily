import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';

class TrackTileStatic extends StatefulWidget {
  final TrackEntity track;
  final Widget? trailing;
  const TrackTileStatic({
    required this.track,
    this.trailing,
    super.key,
  });

  @override
  State<TrackTileStatic> createState() => _TrackTileStaticState();
}

class _TrackTileStaticState extends State<TrackTileStatic> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LyListTile(
      title: InfinityMarquee(
        child: Text(
          widget.track.title,
        ),
      ),
      leading: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            width: 1,
            color: context.themeData.colorScheme.outline.withValues(alpha: .2),
          ),
        ),
        child: Builder(
          builder: (context) {
            if (widget.track.lowResImg != null &&
                widget.track.highResImg!.isNotEmpty) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppImage(
                  widget.track.lowResImg!,
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
                Icons.music_note,
                color: context.themeData.iconTheme.color?.withValues(alpha: .7),
              ),
            );
          },
        ),
      ),
      subtitle: InfinityMarquee(
        child: Text(
          widget.track.artist.name,
        ),
      ),
      trailing: widget.trailing,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/boxes/ly_card.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';

class AlbumStaticTile extends StatelessWidget {
  final AlbumEntity album;
  const AlbumStaticTile({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return LyListTile(
      leading: LyCard(
        width: 40,
        borderRadius: BorderRadius.circular(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            width: 1,
            color: context.themeData.colorScheme.outline.withValues(alpha: .2),
          ),
        ),
        padding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AppImage(
            album.lowResImg ?? '',
            width: 40,
          ),
        ),
      ),
      title: InfinityMarquee(
        child: Text(album.title),
      ),
      subtitle: InfinityMarquee(
        child: Text(album.artist.name),
      ),
    );
  }
}

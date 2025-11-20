import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';

class ArtistItem extends StatefulWidget {
  final ArtistEntity artist;
  final VoidCallback? onTap;
  final double imageSize;
  final double labelWidth;

  const ArtistItem({
    super.key,
    required this.artist,
    this.onTap,
    this.imageSize = 100,
    this.labelWidth = 100,
  });

  @override
  State<ArtistItem> createState() => _ArtistItemState();
}

class _ArtistItemState extends State<ArtistItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor:
            context.themeData.colorScheme.primary.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: Container(
                  width: widget.imageSize,
                  height: widget.imageSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.themeData.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: widget.artist.highResImg != null &&
                                  widget.artist.highResImg!.isNotEmpty
                              ? AppImage(
                                  widget.artist.highResImg!,
                                  fit: BoxFit.cover,
                                  width: widget.imageSize,
                                  height: widget.imageSize,
                                )
                              : _placeholder(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: widget.labelWidth,
                child: Text(
                  widget.artist.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            _isHovered ? FontWeight.w600 : FontWeight.w500,
                        height: 1.3,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.themeData.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.8),
            context.themeData.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          LucideIcons.micVocal,
          color: context.themeData.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.5),
          size: widget.imageSize * 0.4,
        ),
      ),
    );
  }
}

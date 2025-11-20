import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class PlaylistItem extends StatefulWidget {
  final PlaylistEntity playlist;
  final VoidCallback? onTap;
  final double size;
  final double radius;

  const PlaylistItem({
    super.key,
    required this.playlist,
    this.onTap,
    this.size = 160,
    this.radius = 16,
  });

  @override
  State<PlaylistItem> createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(widget.radius),
        splashColor:
            context.themeData.colorScheme.primary.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Playlist Artwork
              AnimatedScale(
                scale: _isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(widget.radius),
                        child: SizedBox(
                          width: widget.size,
                          height: widget.size,
                          child: widget.playlist.highResImg != null &&
                                  widget.playlist.highResImg!.isNotEmpty
                              ? AppImage(
                                  widget.playlist.highResImg!,
                                  fit: BoxFit.cover,
                                )
                              : _placeholder(context),
                        ),
                      ),
                      // Enhanced Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.radius),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.7),
                                Colors.black.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: const [0.0, 0.5, 0.9],
                            ),
                          ),
                        ),
                      ),
                      // Text Overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.playlist.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color:
                                          Colors.black.withValues(alpha: 0.8),
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.playlist.trackCount > 0) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.playlist.trackCount} ${context.localization.songs}',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 6,
                                        color:
                                            Colors.black.withValues(alpha: 0.6),
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
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
          LucideIcons.listMusic,
          color: context.themeData.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.5),
          size: widget.size * 0.4,
        ),
      ),
    );
  }
}

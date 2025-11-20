import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class TrackTileStatic extends StatefulWidget {
  final TrackEntity track;
  final Widget? trailing;
  final Widget? leading;
  const TrackTileStatic(
      {required this.track, this.trailing, this.leading, super.key});

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Track Artwork
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 12),
              ] else ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: widget.track.lowResImg != null &&
                            widget.track.lowResImg!.isNotEmpty
                        ? AppImage(
                            widget.track.lowResImg!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  context.themeData.colorScheme.primary
                                      .withValues(alpha: 0.6),
                                  context.themeData.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Icon(
                              LucideIcons.music,
                              color: context.themeData.colorScheme.onPrimary
                                  .withValues(alpha: 0.7),
                              size: 22,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              // Track Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfinityMarquee(
                      child: Text(
                        widget.track.title,
                        style: context.themeData.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.micVocal,
                          size: 12,
                          color: context.themeData.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: InfinityMarquee(
                            child: Text(
                              widget.track.artist.name,
                              style: context.themeData.textTheme.bodySmall
                                  ?.copyWith(
                                color: context
                                    .themeData.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Trailing Widget
              if (widget.trailing != null) ...[
                const SizedBox(width: 8),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

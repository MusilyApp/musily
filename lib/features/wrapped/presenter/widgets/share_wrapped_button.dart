import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';

class ShareWrappedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final WrappedPalette palette;
  final String? label;
  final bool compact;

  const ShareWrappedButton({
    super.key,
    this.onTap,
    required this.palette,
    this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactShareButton(onTap: onTap, palette: palette);
    }
    return _FullShareButton(
      onTap: onTap,
      palette: palette,
      label: label ?? context.localization.share,
    );
  }
}

class _FullShareButton extends StatelessWidget {
  final VoidCallback? onTap;
  final WrappedPalette palette;
  final String label;

  const _FullShareButton({
    required this.onTap,
    required this.palette,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.text,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.share2,
                color: palette.background,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: palette.background,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactShareButton extends StatelessWidget {
  final VoidCallback? onTap;
  final WrappedPalette palette;

  const _CompactShareButton({
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.text.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            LucideIcons.share2,
            color: palette.text,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class CloseWrappedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final WrappedPalette palette;

  const CloseWrappedButton({
    super.key,
    this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.text.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap ?? () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            LucideIcons.x,
            color: palette.text,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class WrappedActionBar extends StatelessWidget {
  final WrappedPalette palette;
  final VoidCallback? onClose;
  final VoidCallback? onShare;
  final bool showShare;

  const WrappedActionBar({
    super.key,
    required this.palette,
    this.onClose,
    this.onShare,
    this.showShare = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CloseWrappedButton(
            palette: palette,
            onTap: onClose,
          ),
          if (showShare)
            ShareWrappedButton(
              palette: palette,
              onTap: onShare,
              compact: true,
            ),
        ],
      ),
    );
  }
}

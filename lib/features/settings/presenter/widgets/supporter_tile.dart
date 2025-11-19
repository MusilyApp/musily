import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/settings/domain/entities/supporter_entity.dart';

class SupporterTile extends StatelessWidget {
  final SupporterEntity supporter;

  const SupporterTile({
    super.key,
    required this.supporter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.themeData.colorScheme.outline.withValues(alpha: 0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _SupporterAvatar(
                  name: supporter.name,
                  masterSupporter: supporter.masterSupporter),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      supporter.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.themeData.textTheme.titleMedium?.copyWith(
                        fontWeight: supporter.masterSupporter
                            ? FontWeight.w900
                            : FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          supporter.masterSupporter
                              ? LucideIcons.heart
                              : LucideIcons.coins,
                          size: 14,
                          color: context.themeData.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          supporter.formattedAmount,
                          style:
                              context.themeData.textTheme.bodyMedium?.copyWith(
                            color: context
                                .themeData.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupporterAvatar extends StatelessWidget {
  final String name;
  final bool masterSupporter;

  const _SupporterAvatar({
    required this.name,
    required this.masterSupporter,
  });

  @override
  Widget build(BuildContext context) {
    final String trimmed = name.trim();
    final String initial =
        trimmed.isNotEmpty ? trimmed.characters.first.toUpperCase() : '?';

    return Container(
      width: masterSupporter ? 48 : 40,
      height: masterSupporter ? 48 : 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(masterSupporter ? 16 : 12),
        gradient: LinearGradient(
          colors: [
            context.themeData.colorScheme.primary
                .withValues(alpha: masterSupporter ? 1 : 0.7),
            context.themeData.colorScheme.primary.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Builder(builder: (context) {
        if (masterSupporter) {
          return Icon(
            LucideIcons.heart,
            size: 24,
            color: context.themeData.colorScheme.onPrimary,
          );
        }
        return Text(
          initial,
          style: context.themeData.textTheme.titleMedium?.copyWith(
            color: context.themeData.colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        );
      }),
    );
  }
}

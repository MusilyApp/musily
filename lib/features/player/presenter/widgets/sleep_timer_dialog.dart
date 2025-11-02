import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/duration.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';

class SleepTimerDialog {
  static void show(
    BuildContext context, {
    required Function(Duration) onTimerSet,
  }) {
    LyNavigator.showLyCardDialog(
      context: context,
      width: 300,
      builder: (context) => _SleepTimerDialogContent(
        onTimerSet: onTimerSet,
      ),
      actions: (context) => [
        LyFilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            _CustomTimePickerDialog.show(context, onTimerSet: onTimerSet);
          },
          child: Text(context.localization.customTime),
        ),
      ],
    );
  }

  static void showActiveTimer(
    BuildContext context, {
    required DateTime endTime,
    required VoidCallback onCancel,
    required Function(Duration) onAddTime,
  }) {
    LyNavigator.showLyCardDialog(
      context: context,
      width: 260,
      padding: EdgeInsets.zero,
      builder: (context) => _ActiveTimerContent(
        endTime: endTime,
        onCancel: onCancel,
        onAddTime: onAddTime,
      ),
      actionsPadding: const EdgeInsets.only(right: 12, bottom: 12),
      actions: (context) => [
        LyFilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            _CustomTimePickerDialog.show(
              context,
              onTimerSet: (addedDuration) {
                final newEndTime = endTime.add(addedDuration);
                final now = DateTime.now();
                final totalDuration = newEndTime.difference(now);
                onAddTime(totalDuration);
              },
              isAddTime: true,
            );
          },
          child: Text(context.localization.addTime),
        ),
        LyFilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel();
          },
          child: Text(context.localization.cancelTimer),
        ),
      ],
    );
  }
}

class _SleepTimerDialogContent extends StatefulWidget {
  final Function(Duration) onTimerSet;

  const _SleepTimerDialogContent({
    required this.onTimerSet,
  });

  @override
  State<_SleepTimerDialogContent> createState() =>
      _SleepTimerDialogContentState();
}

class _SleepTimerDialogContentState extends State<_SleepTimerDialogContent> {
  @override
  Widget build(BuildContext context) {
    final durations = [
      const Duration(minutes: 5),
      const Duration(minutes: 10),
      const Duration(minutes: 15),
      const Duration(minutes: 30),
      const Duration(minutes: 45),
      const Duration(hours: 1),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        _buildPresetGrid(context, durations),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                context.themeData.colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            LucideIcons.timer,
            color: context.themeData.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localization.sleepTimer,
                style: context.themeData.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.localization.sleepTimerDescription,
                style: context.themeData.textTheme.bodySmall?.copyWith(
                  color: context.themeData.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetGrid(BuildContext context, List<Duration> durations) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: durations.length,
      itemBuilder: (context, index) {
        return _DurationPresetTile(
          duration: durations[index],
          onTap: (duration) {
            widget.onTimerSet(duration);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _DurationPresetTile extends StatelessWidget {
  final Duration duration;
  final Function(Duration) onTap;

  const _DurationPresetTile({
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(duration),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: context.themeData.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.clock,
                  size: 18,
                  color: context.themeData.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _getDurationLabel(context, duration),
                  style: context.themeData.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDurationLabel(BuildContext context, Duration duration) {
    if (duration.inMinutes < 60) {
      return context.localization.minutes(duration.inMinutes);
    } else {
      final hours = duration.inHours;
      return hours == 1
          ? context.localization.hour
          : context.localization.hours(hours);
    }
  }
}

class _ActiveTimerContent extends StatefulWidget {
  final DateTime endTime;
  final VoidCallback onCancel;
  final Function(Duration) onAddTime;

  const _ActiveTimerContent({
    required this.endTime,
    required this.onCancel,
    required this.onAddTime,
  });

  @override
  State<_ActiveTimerContent> createState() => _ActiveTimerContentState();
}

class _ActiveTimerContentState extends State<_ActiveTimerContent> {
  Timer? _updateTimer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final remaining = widget.endTime.difference(now);

    if (remaining.isNegative) {
      setState(() {
        _remaining = Duration.zero;
      });
      return;
    }

    if (mounted) {
      setState(() {
        _remaining = remaining;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: 280,
      ),
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.themeData.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.timer,
                    size: 20,
                    color: context.themeData.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.localization.sleepTimer,
                  style: context.themeData.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Timer Display
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.themeData.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.timer,
                      size: 48,
                      color: context.themeData.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _remaining.formatDuration,
                      style:
                          context.themeData.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.localization.timerInfo(_remaining.formatDuration),
                      style: context.themeData.textTheme.bodySmall?.copyWith(
                        color: context.themeData.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomTimePickerDialog {
  static void show(BuildContext context,
      {required Function(Duration) onTimerSet, bool isAddTime = false}) {
    final contentKey = GlobalKey<_CustomTimePickerContentState>();

    LyNavigator.showLyCardDialog(
      context: context,
      width: 270,
      padding: EdgeInsets.zero,
      builder: (context) => _CustomTimePickerContent(
        key: contentKey,
        onTimerSet: onTimerSet,
        isAddTime: isAddTime,
      ),
      actionsPadding: const EdgeInsets.only(right: 12, bottom: 12),
      actions: (context) => [
        LyOutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.localization.cancel),
        ),
        LyFilledButton(
          onPressed: () {
            final state = contentKey.currentState;
            if (state != null) {
              final duration = Duration(
                hours: state.selectedHours,
                minutes: state.selectedMinutes,
              );
              onTimerSet(duration);
              Navigator.of(context).pop();
            }
          },
          child: Text(context.localization.confirm),
        ),
      ],
    );
  }
}

class _CustomTimePickerContent extends StatefulWidget {
  final Function(Duration) onTimerSet;
  final bool isAddTime;

  const _CustomTimePickerContent({
    super.key,
    required this.onTimerSet,
    this.isAddTime = false,
  });

  @override
  State<_CustomTimePickerContent> createState() =>
      _CustomTimePickerContentState();
}

class _CustomTimePickerContentState extends State<_CustomTimePickerContent> {
  int _selectedHours = 0;
  int _selectedMinutes = 15;

  int get selectedHours => _selectedHours;
  int get selectedMinutes => _selectedMinutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: 320,
      ),
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.themeData.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.clock,
                    size: 20,
                    color: context.themeData.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.localization.customTime,
                  style: context.themeData.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Time Pickers
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 225,
                decoration: BoxDecoration(
                  color: context.themeData.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: context.themeData.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Hours picker
                    _buildWheelPicker(
                      context,
                      label: context.localization.hoursLabel,
                      min: 0,
                      max: 23,
                      initialValue: _selectedHours,
                      onChanged: (value) {
                        setState(() {
                          _selectedHours = value;
                        });
                      },
                    ),
                    Text(
                      ':',
                      style:
                          context.themeData.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.themeData.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    // Minutes picker
                    _buildWheelPicker(
                      context,
                      label: context.localization.minutesLabel,
                      min: 0,
                      max: 59,
                      initialValue: _selectedMinutes,
                      onChanged: (value) {
                        setState(() {
                          _selectedMinutes = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheelPicker(
    BuildContext context, {
    required String label,
    required int min,
    required int max,
    required int initialValue,
    required Function(int) onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: context.themeData.textTheme.bodySmall?.copyWith(
            color:
                context.themeData.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          height: 150,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: 1.2,
            controller:
                FixedExtentScrollController(initialItem: initialValue - min),
            onSelectedItemChanged: (index) {
              onChanged(min + index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index > max - min) return null;
                final value = min + index;
                return Center(
                  child: Text(
                    value.toString().padLeft(2, '0'),
                    style: context.themeData.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                );
              },
              childCount: max - min + 1,
            ),
          ),
        ),
      ],
    );
  }
}

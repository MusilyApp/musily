import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class SleepTimerIndicator extends StatefulWidget {
  final DateTime endTime;
  final VoidCallback onCancel;

  const SleepTimerIndicator({
    super.key,
    required this.endTime,
    required this.onCancel,
  });

  @override
  State<SleepTimerIndicator> createState() => _SleepTimerIndicatorState();
}

class _SleepTimerIndicatorState extends State<SleepTimerIndicator> {
  Timer? _updateTimer;
  String _remainingTime = '';

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingTime();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final remaining = widget.endTime.difference(now);

    if (remaining.isNegative || remaining.inSeconds == 0) {
      setState(() {
        _remainingTime = '0:00';
      });
      return;
    }

    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;

    setState(() {
      _remainingTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.clock,
            size: 14,
            color: context.themeData.colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            _remainingTime,
            style: context.themeData.textTheme.bodySmall?.copyWith(
              color: context.themeData.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

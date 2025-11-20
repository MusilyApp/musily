import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension MusilyDuration on Duration {
  String get formatDuration {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  String toLocalizedString(BuildContext context, {bool showSeconds = false}) {
    final totalSeconds = inSeconds < 0 ? 0 : inSeconds;

    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    String hLabel(int n) => Intl.message(
      'h',
      name: 'duration_hour_label',
      args: [],
      desc: 'Abbreviation for hours',
    );

    String mLabel(int n) => Intl.message(
      'm',
      name: 'duration_minute_label',
      args: [],
      desc: 'Abbreviation for minutes',
    );

    String sLabel(int n) => Intl.message(
      's',
      name: 'duration_second_label',
      args: [],
      desc: 'Abbreviation for seconds',
    );

    final parts = <String>[];
    if (hours > 0) parts.add('$hours${hLabel(hours)}');
    if (minutes > 0) parts.add('$minutes${mLabel(minutes)}');
    if (showSeconds && seconds > 0) parts.add('$seconds${sLabel(seconds)}');

    if (parts.isEmpty) {
      return '0${mLabel(0)}';
    }

    return parts.join(' ');
  }
}

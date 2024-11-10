extension LyDateTime on DateTime {
  String toHourMinuteSecond() {
    String hours = hour.toString().padLeft(2, '0');
    String minutes = minute.toString().padLeft(2, '0');
    String seconds = second.toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }
}

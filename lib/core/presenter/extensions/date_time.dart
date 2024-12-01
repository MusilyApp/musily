extension LyDateTime on DateTime {
  String toHourMinuteSecond() {
    String hours = hour.toString().padLeft(2, '0');
    String minutes = minute.toString().padLeft(2, '0');
    String seconds = second.toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  String toFormattedDate() {
    String year = this.year.toString();
    String month = this.month.toString().padLeft(2, '0');
    String day = this.day.toString().padLeft(2, '0');
    String hour = this.hour.toString().padLeft(2, '0');
    String minutes = minute.toString().padLeft(2, '0');
    String seconds = second.toString().padLeft(2, '0');

    return '$year-$month-$day-$hour:$minutes:$seconds';
  }
}

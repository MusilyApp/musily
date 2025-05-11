import 'package:smtc_windows/smtc_windows.dart';

enum MusilyRepeatMode {
  repeat,
  noRepeat,
  repeatOne;

  RepeatMode toSMTC() {
    switch (this) {
      case MusilyRepeatMode.noRepeat:
        return RepeatMode.none;
      case MusilyRepeatMode.repeat:
        return RepeatMode.list;
      case MusilyRepeatMode.repeatOne:
        return RepeatMode.track;
    }
  }
}

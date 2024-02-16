import 'package:flutter/material.dart';

class Validator {
  String creatingDataDay(DateTime dateTime) {
    switch (dateTime.month) {
      case 1:
        return '${dateTime.day} янв.';

      case 2:
        return '${dateTime.day} фев.';
      case 3:
        return '${dateTime.day} мар.';
      case 4:
        return '${dateTime.day} апр.';
      case 5:
        return '${dateTime.day} май.';
      case 6:
        return '${dateTime.day} июн.';
      case 7:
        return '${dateTime.day} июл.';
      case 8:
        return '${dateTime.day} авг.';
      case 9:
        return '${dateTime.day} сен.';
      case 10:
        return '${dateTime.day} окт.';
      case 11:
        return '${dateTime.day} ноя.';
      case 12:
        return '${dateTime.day} ноя.';

      default:
        return 'Error';
    }
  }

  String formatTheTime(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
  }

  String formatTheTimeOfDay(TimeOfDay timeOfDay) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(timeOfDay.hour)}:${twoDigits(timeOfDay.minute)}';
  }

  String formatTheDateTime(DateTime dateTime) {
    return '${creatingDataDay(dateTime)} - ${formatTheTime(dateTime)}';
  }

  String printDuration(Duration duration) {
    final negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return '$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  bool dateTimeAsSameTimeWithNow(
      {required DateTime firstTime, required DateTime now}) {
    final timeDifference = now.difference(firstTime).abs();
    const maxAllowedDifference = Duration(seconds: 10);

    return timeDifference <= maxAllowedDifference;
  }
}

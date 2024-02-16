import 'package:equatable/equatable.dart';

enum TimerStateStatus { resetTimer, continueTimer ,errorTimer}

class TimerStateModel extends Equatable {
  final DateTime sleepStartDateTime;
  final DateTime awokenDateTime;
  final TimerStateStatus timeStateStatus;

  const TimerStateModel(
      {required this.sleepStartDateTime,
      required this.awokenDateTime,
      required this.timeStateStatus});

  @override
  List<Object?> get props =>
      [sleepStartDateTime, awokenDateTime, timeStateStatus];
}

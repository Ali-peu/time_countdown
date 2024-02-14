import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';

class CustomText extends StatefulWidget {
  const CustomText({super.key});

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state.timerStatus == TimerStatus.initial) {
          return const Text('Малыш не спит');
        } else if (state.timerStatus == TimerStatus.play) {
          return Text(
              'Малыш уснул ${getRightTime(context.read<TimerBloc>().unredactedStartTime)}');
        } else {
          return Column(
            children: [
              Text(
                  'Малыш уснул ${getRightTime(context.read<TimerBloc>().unredactedStartTime)}'),
              Text(
                  'Малыш проснулся : ${getRightTime(context.read<TimerBloc>().unredactedStopTime)} ')
            ],
          );
        }
      },
    );
  }

  String getRightTime(DateTime? dateTime) {
    DateTime showDateTime = DateTime.now();
    if (dateTime == null) {
      return 'Не уснул';
    } else {
      showDateTime = dateTime;
      return Validator().formatTheDateTime(showDateTime);
    }
  }
}

String dateFormat(DateTime dateTime) {
  String twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }

  return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} - ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}';
}

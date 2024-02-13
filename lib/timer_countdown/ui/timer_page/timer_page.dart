import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/circular_timer.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
   Duration duration = const Duration(seconds: 7);
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          var timerBloc = context.read<TimerBloc>();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.timerStatus == TimerStatus.play)
                  Center(
                      child: BlocProvider.value(
                    value: timerBloc,
                    child: CircularTimer(
                      onTimerPause: (value) {
                        duration = value;
                      },
                    ),
                  )),
                if (state.timerStatus != TimerStatus.play)
                  const Text(
                      'state.timerStatus != TimerStatus.play => 00 : 00 : 00'),
                if (state.timerStatus == TimerStatus.pause)
                  Text(_printDuration(state.timer)),
                if (state.timerStatus == TimerStatus.play)
                  TextButton(
                    child: const Text('NOT PLAY'),
                    onPressed: () {
                      log(duration.toString());
                      context
                          .read<TimerBloc>()
                          .add(TimerPause(duration: duration));
                    },
                  ),
                if (state.timerStatus == TimerStatus.pause ||
                    state.timerStatus == TimerStatus.initial)
                  TextButton(
                    child: const Text('Play'),
                    onPressed: () {
                      context.read<TimerBloc>().add(
                          TimerStart(duration: duration));
                      log("Timer is start");
                    },
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "state.timerStatus == TimerStatus.pause => $negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  DateTime dateTime(TimerState state) {
    log('IS it logged');
    if (state.timerStatus == TimerStatus.play) {
      log('IS it logged if ');

      return now.add(const Duration(minutes: 1));
    } else {
      log('IS it logged else');

      return DateTime.now();
    }
  }
}

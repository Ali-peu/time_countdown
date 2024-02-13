import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';

class SecondTimer extends StatefulWidget {
  const SecondTimer({super.key});

  @override
  State<SecondTimer> createState() => _SecondTimerState();
}

class _SecondTimerState extends State<SecondTimer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        var timerBloc = context.read<TimerBloc>();
        return StreamBuilder(
            stream: timerBloc.timerService.timerStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Duration duration = snapshot.data!;
                return Text(_printDuration(duration));
              } else {
                return const Text(' 00:00:00');
              }
            });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    context.read<TimerBloc>().timerService.dispose();
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

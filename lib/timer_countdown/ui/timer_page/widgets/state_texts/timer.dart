import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';

class Timer extends StatefulWidget {
  final TimerBloc timerBloc;
  const Timer({required this.timerBloc, super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   subscription = context.read<TimerBloc>().stream.listen((state) {
  //     // обработка состояния
  //     log('state on listen ');
  //   });
  // }

  // late final StreamSubscription<TimerState> subscription;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.timerBloc.timerService.timerStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final duration = snapshot.data!;
            return Text(Validator().printDuration(duration));
          } else {
            return const Text(' 00:00:00');
          }
        });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   subscription.cancel();
  //   context.read<TimerBloc>().close();
  // }
}

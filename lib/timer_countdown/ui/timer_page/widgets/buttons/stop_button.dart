import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/buttons/edit_icon.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/main_dialog.dart';

class StopButton extends StatefulWidget {
  const StopButton({super.key});

  @override
  State<StopButton> createState() => _StopButtonState();
}

class _StopButtonState extends State<StopButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: showDialogIfWasPressedCancel,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Завершить сон'),
            BlocProvider.value(
              value: context.read<TimerBloc>(),
              child: const EditIcon(),
            )
          ],
        ));
  }

  Future<dynamic> showDialogIfWasPressedCancel() async {
    if (Validator().dateTimeAsSameTimeWithNow(
        firstTime: context.read<TimerBloc>().state.babyWakeUpTime,
        now: DateTime.now())) {
      log('Valiidator dateTimeAsSameTimeWithNow is true');
      context
          .read<TimerBloc>()
          .add(UpdateDefautlState(stopTime: DateTime.now()));
    }
    await showDialog(
        context: context,
        builder: (_) => BlocProvider.value(
            value: context.read<TimerBloc>(),
            child: MainDialog(timerBloc: context.read<TimerBloc>())));
  }
}

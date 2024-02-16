import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
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
    final timerBloc = context.read<TimerBloc>();

    await showDialog(
            context: context,
            builder: (_) =>
                BlocProvider.value(value: timerBloc, child: const MainDialog()))
        .then((value) {
      if (value == null) {
        log(value.runtimeType.toString(), name: 'Value type');
        log('When show dialog then == null');
        log('это выполняеться в любом варианте закрытие диалога');
      }
    });
  }
}

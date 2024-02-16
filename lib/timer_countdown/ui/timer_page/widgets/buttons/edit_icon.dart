import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/alert_dialog.dart';

class EditIcon extends StatefulWidget {
  const EditIcon({super.key});

  @override
  State<EditIcon> createState() => _EditIconState();
}

class _EditIconState extends State<EditIcon> {
  @override
  Widget build(BuildContext context) {
    final timerBloc = context.read<TimerBloc>();
    return IconButton(
        onPressed: () async {
          await alertDialogWithDateAndTimeForStartSleep(timerBloc, context);
        },
        icon: const Icon(Icons.edit));
  }

  Future<dynamic> alertDialogWithDateAndTimeForStartSleep(
    TimerBloc timerBloc,
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return BlocProvider.value(
                  value: timerBloc, child: const CustomAlertDialog());
            }));
  }
}

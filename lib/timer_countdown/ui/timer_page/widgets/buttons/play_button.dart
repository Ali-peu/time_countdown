import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/buttons/edit_icon.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                context
                    .read<TimerBloc>()
                    .add(TimerStart(startDateTime: DateTime.now()));
              },
              child: const Text('Начать сон')),
          BlocProvider.value(
            value: context.read<TimerBloc>(),
            child: const EditIcon(),
          )
        ],
      );
    });
  }
}

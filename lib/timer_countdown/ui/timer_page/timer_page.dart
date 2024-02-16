import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_model.dart';
import 'package:time_countdown/timer_countdown/domain/repository/children_repository.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/buttons/button_to_edit_timer.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/buttons/children_dropdown.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/buttons/play_button.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/state_texts/second_timer.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/state_texts/stats_listview.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  DateTime? newPickedDate;
  TimeOfDay? newPickedTime;

  late DateTime newPickedDateAndTime;
  ChildModel? chooseChildModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TimerBloc, TimerState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.timerStatus.toString())));
        },
        child: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocProvider.value(
                    value: context.read<TimerBloc>(),
                    child: const StatsListview(),
                  ),
                  BlocProvider.value(
                    value: context.read<TimerBloc>(),
                    child: const ChildrenDropdown(),
                  ),
                  Text(
                      'Системное время: ${Validator().formatTheDateTime(DateTime.now())}'),
                  if (state.timerStatus == TimerStatus.initial)
                    const Text('Малыш не спит'),
                  if (state.timerStatus == TimerStatus.play)
                    Text(
                        'Малыш уснул ${Validator().formatTheDateTime(context.read<TimerBloc>().state.babySleepTime)}'),
                  if (state.timerStatus == TimerStatus.stop)
                    Column(
                      children: [
                        Text(
                            'Малыш уснул ${Validator().formatTheDateTime(context.read<TimerBloc>().state.babySleepTime)}'),
                        Text(
                            'Малыш проснулся : ${Validator().formatTheDateTime(context.read<TimerBloc>().state.babyWakeUpTime)} ')
                      ],
                    ),
                  BlocProvider.value(
                      value: context.read<TimerBloc>(),
                      child: const SecondTimer()),
                  if (state.timerStatus != TimerStatus.play)
                    BlocProvider.value(
                      value: context.read<TimerBloc>(),
                      child: const PlayButton(),
                    ),
                  if (state.timerStatus == TimerStatus.play)
                    BlocProvider.value(
                      value: context.read<TimerBloc>(),
                      child: const StopButton(),
                    ),
                  IconButton(
                      onPressed: () {
                        ChildrenRepository().testCreateChild();
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  BlocProvider<TimerBloc> timerInState() {
    return BlocProvider.value(
        value: context.read<TimerBloc>(), child: const SecondTimer());
  }
}

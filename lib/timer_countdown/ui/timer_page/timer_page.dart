import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_model.dart';
import 'package:time_countdown/timer_countdown/domain/repository/children_repository.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/buttons/children_dropdown.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/buttons/play_button.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/buttons/stop_button.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/state_texts/stats_listview.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/state_texts/timer.dart';

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
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          return Center(
            child: BlocProvider.value(
              value: context.read<TimerBloc>(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const StatsListview(),
                  const ChildrenDropdown(),
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
                  Timer(timerBloc: context.read<TimerBloc>()),
                  if (state.timerStatus != TimerStatus.play) const PlayButton(),
                  if (state.timerStatus == TimerStatus.play) const StopButton(),
                  IconButton(
                      onPressed: () {
                        ChildrenRepository().testCreateChild();
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

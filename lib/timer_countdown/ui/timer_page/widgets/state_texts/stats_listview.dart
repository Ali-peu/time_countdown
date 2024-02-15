import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_sleep_time_stat_model.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';

class StatsListview extends StatelessWidget {
  const StatsListview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return FutureBuilder<List<ChildSleepTimeStatModel>>(
            future: Future.value(
                context.read<TimerBloc>().state.listChildSleepTimeStats),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Text('snapthot.data == null');
              }
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  final stats = snapshot.data!;
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(Validator().formatTheDateTime(
                              stats[index].babySleepDateTime)),
                          subtitle: Text(Validator().formatTheDateTime(
                              stats[index].babyWakeUpDateTime)),
                          trailing: Text(
                              Validator().printDuration(stats[index].duration)),
                          leading: Text(stats[index].babyId.toString()),
                        );
                      },
                      itemCount: stats.length,
                    ),
                  );
                } else {
                  return const Text('snapshot.data!.isEmpty');
                }
              } else {
                return const Text('!snapshot.hasData');
              }
            });
      },
    );
  }
}

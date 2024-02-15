import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';

import 'package:time_countdown/timer_countdown/domain/models/child_sleep_time_stat_model.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Scaffold(
            body: FutureBuilder<List<ChildSleepTimeStatModel>>(
                future: Future.value(
                    context.read<TimerBloc>().state.listChildSleepTimeStats),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Text('snapthot.data == null');
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      final stats = snapshot.data!;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(Validator().formatTheDateTime(
                                stats[index].babySleepDateTime)),
                            subtitle: Text(Validator().formatTheDateTime(
                                stats[index].babyWakeUpDateTime)),
                            trailing: Text(Validator()
                                .printDuration(stats[index].duration)),
                            leading: Text(stats[index].babyId.toString()),
                          );
                        },
                        itemCount: stats.length,
                      );
                    } else {
                      return const Text('snapshot.data!.isEmpty');
                    }
                  } else {
                    return const Text('!snapshot.hasData');
                  }
                }));
      },
    );
  }
}

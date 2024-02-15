import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/simple_bloc_observer.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';

import 'package:time_countdown/timer_countdown/domain/repository/child_sleep_time_stat_repository.dart';
import 'package:time_countdown/timer_countdown/domain/repository/children_repository.dart';

import 'package:time_countdown/timer_countdown/ui/timer_page/timer_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = DetailedBlocObserver();

  log('Main after getChilderan');
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final childrenRepository = ChildrenRepository();
    final childSleepTimeStatRepository = ChildSleepTimeStatRepository();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: BlocProvider(
        create: (context) => TimerBloc(
            childrenRepository: childrenRepository,
            childSleepTimeStatRepository: childSleepTimeStatRepository)
          ..add(FetchedChildrens())
          ..add(FetchedListChildSleepTimeStats()),
        child: const TimerPage(),
      ),
    );
  }
}

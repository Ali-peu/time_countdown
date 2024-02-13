import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/simple_bloc_observer.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/timer_page.dart';

void main() {
  Bloc.observer = DetailedBlocObserver();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: BlocProvider(
        create: (context) => TimerBloc(),
        child: const TimerPage(),
      ),
    );
  }
}

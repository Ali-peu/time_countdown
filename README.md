# time_countdown

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Все еще ошибка с тем что я теряю? контекст после откыртие StatefullBuilder логи ошибки 
E/flutter (14081): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: Bad state: Cannot add event after closing
E/flutter (14081): #0      _StreamController.add (dart:async/stream_controller.dart:605:24)
E/flutter (14081): #1      TimerService.startTimer.<anonymous closure> (package:time_countdown/timer_countdown/data/custom_timer.dart:25:26)
E/flutter (14081): #2      _Timer._runTimers (dart:isolate-patch/timer_impl.dart:398:19)
E/flutter (14081): #3      _Timer._handleMessage (dart:isolate-patch/timer_impl.dart:429:5)
E/flutter (14081): #4      _RawReceivePort._handleMessage (dart:isolate-patch/isolate_patch.dart:184:12)
E/flutter (14081): 
E/flutter (14081): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: Bad state: Cannot add event after closing
E/flutter (14081): #0      _StreamController.add (dart:async/stream_controller.dart:605:24)
E/flutter (14081): #1      TimerService.startTimer.<anonymous closure> (package:time_countdown/timer_countdown/data/custom_timer.dart:25:26)
E/flutter (14081): #2      _Timer._runTimers (dart:isolate-patch/timer_impl.dart:398:19)
E/flutter (14081): #3      _Timer._handleMessage (dart:isolate-patch/timer_impl.dart:429:5)
E/flutter (14081): #4      _RawReceivePort._handleMessage (dart:isolate-patch/isolate_patch.dart:184:12)
E/flutter (14081): 

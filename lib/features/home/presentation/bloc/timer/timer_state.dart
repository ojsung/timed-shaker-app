import 'package:timed_shaker/core/utilities/data_macro.dart';

@Data()
sealed class TimerState {
  final int duration;
  final int initialDuration;
  static bool isTimerStateChanged(TimerState previous, TimerState current) => switch (previous) {
        TimerInitial() => current is TimerInitial,
        TimerRunPause() => current is TimerRunPause,
        TimerRunInProgress() => current is TimerRunInProgress,
        TimerRunComplete() => current is TimerRunComplete,
      };
}

@Data()
final class TimerInitial extends TimerState {}

@Data()
final class TimerRunPause extends TimerState {}

@Data()
final class TimerRunInProgress extends TimerState {}

@Data(superDefaults: {'duration': 0})
final class TimerRunComplete extends TimerState {}

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

final class TimerInitial extends TimerState {
  const TimerInitial({required super.duration, required super.initialDuration});
}

final class TimerRunPause extends TimerState {
  const TimerRunPause({required super.duration, required super.initialDuration});
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress({required super.duration, required super.initialDuration});
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete({required super.initialDuration}) : super(duration: 0);
}

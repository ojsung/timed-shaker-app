import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_bloc.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_event.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_state.dart';

class TimerActions extends StatelessWidget {
  final int _duration;
  const TimerActions({super.key, required int duration}) : _duration = duration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (previous, current) => TimerState.isTimerStateChanged(previous, current),
        builder: (context, state) {
          return switch (state) {
            TimerInitial() => IconButton(
                onPressed: () => context.read<TimerBloc>().add(TimerStarted(duration: _duration)),
                icon: Icon(Icons.play_arrow),
              ),
            TimerRunInProgress() => IconButton(
                onPressed: () => context.read<TimerBloc>().add(TimerPaused()),
                icon: Icon(Icons.pause),
              ),
            TimerRunComplete() => IconButton(
                onPressed: () => context.read<TimerBloc>().add(TimerStarted(duration: _duration)),
                icon: Icon(Icons.play_arrow),
              ),
            TimerRunPause() => IconButton(
                onPressed: () => context.read<TimerBloc>().add(TimerResumed()),
                icon: Icon(Icons.not_started_outlined),
              ),
          };
        });
  }
}

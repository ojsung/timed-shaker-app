import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_shaker/core/utilities/ticker.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_state.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;
  TimerBloc({
    required ticker,
  })  : 
        _ticker = ticker,
        super(TimerInitial(initialDuration: 0, duration: 0)) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
  }
  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(duration: event.duration, initialDuration: state.initialDuration));
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick(ticks: event.duration).listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0 ? TimerRunInProgress(duration: event.duration, initialDuration: state.initialDuration) : TimerRunComplete(initialDuration: state.initialDuration),
    );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(duration: state.duration, initialDuration: state.initialDuration));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(duration: state.duration, initialDuration: state.initialDuration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(initialDuration: state.initialDuration, duration: state.initialDuration));
  }
}

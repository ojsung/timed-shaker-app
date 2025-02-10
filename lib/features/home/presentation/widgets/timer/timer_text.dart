import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_bloc.dart';

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final timeAsDuration = Duration(seconds: duration);
    final timeAsString = "${timeAsDuration.inHours}:${timeAsDuration.inMinutes}";
    return Text(timeAsString, style: Theme.of(context).textTheme.headlineMedium);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_shaker/core/utilities/ticker.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_bloc.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_state.dart';
import 'package:timed_shaker/features/home/presentation/widgets/timer/timer_text.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(ticker: Ticker()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Center(
          child: BlocBuilder<TimerBloc, TimerState>(
            buildWhen:(previous, current) => TimerState.isTimerStateChanged(previous, current) || previous.duration != current.duration,
            builder: (context, state) {
              return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        switch(state) {
                          TimerInitial() => Placeholder(),
                          TimerRunComplete() => Placeholder(),
                          TimerRunInProgress() => Placeholder(),
                          TimerRunPause() => Placeholder(),
                        },
                        TimerText(),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

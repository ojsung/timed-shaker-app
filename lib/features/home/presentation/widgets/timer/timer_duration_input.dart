import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_bloc.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_event.dart';
import 'package:timed_shaker/features/home/presentation/bloc/timer/timer_state.dart';

class TimerDurationInput extends StatelessWidget {
  const TimerDurationInput({super.key});

  @override
  Widget build(BuildContext context) {
    final int initialDuration = context.read<TimerBloc>().state.duration;
    Duration duration = Duration(seconds: initialDuration);

    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (previous, current) => previous.duration != current.duration,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: duration.inHours.toString(),
              keyboardType: TextInputType.numberWithOptions(),
              validator: (value) {
                int? parsedHours = int.tryParse(value ?? '');
                if (parsedHours == null) {
                  return 'Hours must be a valid integer number';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => TimerDurationChanged(duration: _hoursChanged(initialDuration, value)),
            ),
            Text('H '),
            TextFormField(
              initialValue: (duration.inMinutes % 60).toString(),
              keyboardType: TextInputType.numberWithOptions(),
              validator: (value) {
                int? parsedMinutes = int.tryParse(value ?? '');
                if (parsedMinutes == null) {
                  return 'Minutes must be a valid integer number';
                }
                if (parsedMinutes > 59) {
                  return 'Minutes must be less than 60';
                }
                if (parsedMinutes < 0) {
                  return 'Minutes must be a positive integer';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => TimerDurationChanged(duration: _minutesChanged(initialDuration, value)),
            ),
            Text('M'),
          ],
        );
      },
    );
  }

  int _hoursChanged(int initialDuration, String hours) {
    final Duration parsedInitialDuration = Duration(seconds: initialDuration);
    final int parsedHours = int.tryParse(hours) ?? 0;
    final Duration duration = Duration(hours: parsedHours, minutes: parsedInitialDuration.inMinutes % 60);
    return duration.inSeconds;
  }

  int _minutesChanged(int initialDuration, String minutes) {
    final Duration parsedInitialDuration = Duration(seconds: initialDuration);
    final int parsedMinutes = int.tryParse(minutes) ?? 0;
    final Duration duration = Duration(hours: parsedInitialDuration.inHours, minutes: parsedMinutes);
    return duration.inSeconds;
  }
}

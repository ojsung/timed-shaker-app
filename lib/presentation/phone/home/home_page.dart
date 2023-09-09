import 'package:flutter/material.dart';
import 'package:timed_shaker/configuration/navigator/navigator_route_enum.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Start Routine', style: textTheme.displaySmall),
          Center(
              child: IconButton(
            onPressed: () => print('Go'),
            icon: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(75),
                    border: Border.all(color: colorScheme.onBackground, width: 5)),
                child: const Icon(
                  Icons.play_arrow_outlined,
                  size: 75,
                )),
          )),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed(NavigatorRoute.editSleepType.name),
              icon: const Icon(Icons.bedtime_outlined)),
          const SizedBox(width: 10),
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed(NavigatorRoute.newRoutine.name),
              icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}

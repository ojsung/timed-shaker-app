import 'package:flutter/material.dart';
import 'package:timed_shaker/configuration/navigator/navigator_route_enum.dart';
import 'package:timed_shaker/presentation/phone/edit_sleep_type/edit_sleep_type_page.dart';
import 'package:timed_shaker/presentation/phone/home/home_page.dart';
import 'package:timed_shaker/presentation/phone/new_routine/new_routine_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: Navigator(
        initialRoute: NavigatorRoute.home.name,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    String? routeName = settings.name;
    if (routeName == null) {
      return MaterialPageRoute(settings: settings, builder: (context) => const HomePage());
    }
    switch (NavigatorRoute.matchRoute(routeName)) {
      case NavigatorRoute.newRoutine:
        return MaterialPageRoute(settings: settings, builder: (context) => const NewRoutinePage());
      case NavigatorRoute.editSleepType:
        return MaterialPageRoute(settings: settings, builder: (context) => const EditSleepTypePage());
      case NavigatorRoute.home:
      default:
        return MaterialPageRoute(settings: settings, builder: (context) => const HomePage());
    }
  }
}

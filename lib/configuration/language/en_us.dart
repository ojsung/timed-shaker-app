import 'package:timed_shaker/configuration/language/language.dart';

enum LanguageEnUS implements Language {
  homeTitle('Home'),
  editSleepTypeTitle('Edit sleep type'),
  addANewRoutineTitle('Add a new routine'),
  startRoutineCTA('Start Routine'),
  lightSleepLabel('Light Sleep'),
  dreamingSleepLabel('Dreaming Sleep'),
  deepSleepLabel('Deep Sleep'),
  vibrationTypeLabel('Vibration Type'),
  softOption('Soft'),
  mediumOption('Medium'),
  strongOption('Strong'),
  mediumHapticFeedbackWarning('Medium vibrations may not be supported on older operating systems'),
  ;

  @override
  final String text;
  const LanguageEnUS(this.text);
}

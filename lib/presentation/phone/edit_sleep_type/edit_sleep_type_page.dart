import 'package:flutter/material.dart';
import 'package:timed_shaker/configuration/language/en_us.dart';

class EditSleepTypePage extends StatelessWidget {
  const EditSleepTypePage({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: Text(LanguageEnUS.editSleepTypeTitle.text),
      ),
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text(LanguageEnUS.lightSleepLabel.text),
          DropdownButtonFormField(items: [DropdownMenuItem(child: Text(''))], onChanged: (_) {}),
        ])
      ]),
    );
  }
}

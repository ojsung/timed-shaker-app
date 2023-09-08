import 'package:flutter/material.dart';

class NewRoutinePage extends StatelessWidget {
  const NewRoutinePage({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new routine'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration.collapsed(hintText: 'Routine name'),
            keyboardType: TextInputType.text,
          ),
          TextFormField(
            decoration: InputDecoration.collapsed(hintText: 'Total Duration'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            decoration: InputDecoration.collapsed(hintText: 'Light sleep duration'),
          ),
          TextFormField(
            decoration: InputDecoration.collapsed(hintText: 'Dreaming sleep duration'),
          ),
          TextFormField(
            decoration: InputDecoration.collapsed(hintText: 'Deep sleep duration'),
          )
        ],
      ),
    );
  }
}

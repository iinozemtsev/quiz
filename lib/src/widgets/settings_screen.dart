import 'package:flutter/material.dart';
import 'package:playground/src/model/game_settings.dart';

class SettingsScreen extends StatefulWidget {
  final GameSettings initialSettings;

  const SettingsScreen({
    super.key,
    required this.initialSettings,
  });

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  late GameSettings settings;
  final _countController = TextEditingController();
  final _maxController = TextEditingController();
  _SettingsState();

  @override
  void dispose() {
    _countController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    settings = widget.initialSettings;
    _countController.text = (settings.limit as MaxQuestions).value.toString();
    _maxController.text = settings.maxNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Question Count', style: textStyle),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: _countController,
              ),
            ),
            Text('Max Number', style: textStyle),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: _maxController,
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(GameSettings(
                  maxNumber:
                      int.tryParse(_maxController.text) ?? settings.maxNumber,
                  limit: MaxQuestions(int.tryParse(_countController.text) ??
                      (settings.limit as MaxQuestions).value))),
              child: const Text('Back'),
            )
          ],
        ),
      ),
    );
  }
}

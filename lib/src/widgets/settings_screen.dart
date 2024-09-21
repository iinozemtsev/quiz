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
  late final GameSettings initialSettings;
  late GameLimitType limitType;
  final _countController = TextEditingController();
  final _maxController = TextEditingController();
  final _minutesController = TextEditingController();
  String? questionCountErrorText;
  String? minutesErrorText;
  _SettingsState();

  @override
  void dispose() {
    _countController.dispose();
    _maxController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialSettings = widget.initialSettings;
    limitType = initialSettings.limit.limitType;
    _countController.text = (initialSettings.limit is MaxQuestions
            ? initialSettings.limit as MaxQuestions
            : MaxQuestions.defaultValue)
        .value
        .toString();
    _minutesController.text = (initialSettings.limit is Timeout
            ? initialSettings.limit as Timeout
            : Timeout.defaultValue)
        .value
        .inMinutes
        .toString();
    _maxController.text = initialSettings.maxNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu<GameLimitType>(
              dropdownMenuEntries: [
                for (final value in GameLimitType.values)
                  DropdownMenuEntry<GameLimitType>(
                    value: value,
                    label: limitTypeLabel(value),
                  )
              ],
              initialSelection: limitType,
              requestFocusOnTap: false,
              expandedInsets: const EdgeInsets.all(16),
              label: const Text('Тип игры'),
              onSelected: (type) {
                if (type == null || type == limitType) {
                  return;
                }
                setState(() => limitType = type);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                    labelText: 'Максимальное число',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: _maxController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                enabled: limitType == GameLimitType.maxQuestions,
                decoration: InputDecoration(
                  labelText: 'Количество вопросов',
                  border: const OutlineInputBorder(),
                  errorText: questionCountErrorText,
                ),
                keyboardType: TextInputType.number,
                controller: _countController,
                onChanged: (text) {
                  final newErr = validateNum(text, 1, 100);
                  if (newErr != questionCountErrorText) {
                    setState(() => questionCountErrorText = newErr);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                enabled: limitType == GameLimitType.timeout,
                decoration: InputDecoration(
                  labelText: 'Количество минут',
                  border: const OutlineInputBorder(),
                  errorText: minutesErrorText,
                ),
                keyboardType: TextInputType.number,
                controller: _minutesController,
                onChanged: (text) {
                  final newErr = validateNum(text, 1, 10);
                  if (newErr != minutesErrorText) {
                    setState(() => minutesErrorText = newErr);
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(GameSettings(
                      maxNumber: int.tryParse(_maxController.text) ??
                          initialSettings.maxNumber,
                      limit: switch (limitType) {
                        GameLimitType.maxQuestions => MaxQuestions(
                            int.tryParse(_countController.text) ??
                                MaxQuestions.defaultValue.value),
                        GameLimitType.timeout => Timeout(Duration(
                            minutes: int.tryParse(_minutesController.text) ??
                                Timeout.defaultValue.value.inMinutes)),
                      })),
                  child: const Text('Готово'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(initialSettings),
                  child: const Text('Отмена'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

String? validateNum(String text, int minAllowed, int maxAllowed) {
  final value = int.tryParse(text);
  if (value == null) {
    return 'Это не число!';
  }
  if (value < minAllowed || value > maxAllowed) {
    return 'Введи число между $minAllowed и $maxAllowed';
  }

  return null;
}

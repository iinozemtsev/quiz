/// Immutable game settings.
class GameSettings {
  final int maxNumber;
  final GameLimit limit;

  const GameSettings({required this.limit, required this.maxNumber});

  static const defaultSettings = GameSettings(
    maxNumber: 10,
    limit: MaxQuestions.defaultValue,
  );
}

sealed class GameLimit {}

class MaxQuestions implements GameLimit {
  final int value;

  const MaxQuestions(this.value);

  static const defaultValue = MaxQuestions(10);
}

class Timeout implements GameLimit {
  final Duration value;

  const Timeout(this.value);

  static const defaultValue = Timeout(Duration(minutes: 2));
}

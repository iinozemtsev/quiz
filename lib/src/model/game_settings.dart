/// Immutable game settings.
class GameSettings {
  final int maxNumber;
  final GameLimit limit;

  const GameSettings({required this.limit, required this.maxNumber});

  GameSettings update({GameLimit? limit, int? maxNumber}) => GameSettings(
      limit: limit ?? this.limit, maxNumber: maxNumber ?? this.maxNumber);

  static const defaultSettings = GameSettings(
    maxNumber: 10,
    limit: MaxQuestions.defaultValue,
  );
}

sealed class GameLimit {
  GameLimitType get limitType;
}

class MaxQuestions implements GameLimit {
  @override
  final limitType = GameLimitType.maxQuestions;

  final int value;

  const MaxQuestions(this.value);

  static const defaultValue = MaxQuestions(10);
}

class Timeout implements GameLimit {
  @override
  final limitType = GameLimitType.timeout;

  final Duration value;

  const Timeout(this.value);

  static const defaultValue = Timeout(Duration(minutes: 2));
}

enum GameLimitType { maxQuestions, timeout }

String limitTypeLabel(GameLimitType value) => switch (value) {
      GameLimitType.maxQuestions => 'Количество вопросов',
      GameLimitType.timeout => 'Время'
    };

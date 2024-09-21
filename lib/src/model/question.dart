import 'dart:math';
import 'package:playground/src/model/game_settings.dart';

class Question {
  final String text;
  final List<String> answers;
  final String rightAnswer;

  Question(
      {required this.text, required this.answers, required this.rightAnswer});

  static Question randomQuestion(
      {required GameSettings settings, Random? random}) {
    random ??= Random();
    final (a, b) = (
      random.nextInt(settings.maxNumber + 1),
      random.nextInt(settings.maxNumber + 1)
    );
    final correctAnswer = a * b;
    final answers = <int>{correctAnswer};

    while (answers.length != 3) {
      answers.add(random.nextInt(settings.maxNumber * settings.maxNumber + 1));
    }

    return Question(
        text: '$a x $b = ?',
        answers: (answers.toList()..shuffle(random))
            .map((x) => x.toString())
            .toList(),
        rightAnswer: correctAnswer.toString());
  }
}

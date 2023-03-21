import 'dart:collection';

class Game {
  final UnmodifiableListView<Question> questions;
  final int currentQuestion;
  final int score;

  Game(
      {required Iterable<Question> questions,
      required this.currentQuestion,
      required this.score})
      : questions = UnmodifiableListView(questions);

  bool get isOver => currentQuestion >= questions.length;

  Game answer(int index) {
    if (isOver) throw GameException('The game is over');
    final answers = questions[currentQuestion].answers;
    if (index >= answers.length || index < 0) {
      throw GameException('Invalid answer index');
    }
    var nextScore = score;
    if (answers[index].isCorrect) {
      nextScore++;
    }
    return Game(
        questions: questions,
        score: nextScore,
        currentQuestion: currentQuestion + 1);
  }
}

class Question {
  final String title;
  final UnmodifiableListView<Answer> answers;

  Question({required this.title, required Iterable<Answer> answers})
      : answers = UnmodifiableListView(answers);
}

class Answer {
  final String title;
  final bool isCorrect;

  Answer({required this.title, required this.isCorrect});
}

class GameException implements Exception {
  final String message;
  final Object? cause;

  GameException(this.message, [this.cause]);
}

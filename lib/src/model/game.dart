import 'dart:math';

import 'package:playground/src/model/game_settings.dart';
import 'package:playground/src/model/question.dart';

/// Immutable current game state.
class Game {
  final GameSettings settings;
  final Question question;
  final int score;
  final int answers;
  final DateTime started;
  final DateTime? finished;

  bool get isOver => finished != null;

  Game(
      {required this.settings,
      required this.question,
      required this.score,
      required this.answers,
      required this.started,
      required this.finished});

  Game update(
          {Question? question, int? score, int? answers, DateTime? finished}) =>
      Game(
          settings: settings,
          question: question ?? this.question,
          score: score ?? this.score,
          answers: answers ?? this.answers,
          started: started,
          finished: finished ?? this.finished);

  static Game create({required GameSettings settings, Random? random}) => Game(
      settings: settings,
      question: Question.randomQuestion(settings: settings, random: random),
      score: 0,
      answers: 0,
      started: DateTime.now(),
      finished: null);

  Game nextQuestionOrFinish(String answer, {Random? random}) {
    final answered = update(
        answers: answers + 1,
        score: answer == question.rightAnswer ? score + 1 : score);
    final now = DateTime.now();
    final isFinished = switch (settings.limit) {
      MaxQuestions(value: final maxQuestions) =>
        answered.answers >= maxQuestions,
      Timeout(value: final timeout) => now.difference(started) >= timeout
    };
    if (isFinished) {
      return answered.finish(finished: now);
    }
    return answered.update(
      question: Question.randomQuestion(settings: settings, random: random),
    );
  }

  Game finish({DateTime? finished}) =>
      update(finished: finished ?? DateTime.now());
}

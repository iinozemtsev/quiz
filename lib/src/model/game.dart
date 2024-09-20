import 'dart:math';
import 'package:playground/menu_screen.dart';
import 'package:playground/src/model/game_settings.dart';

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

  Game nextQuestion(String answer, {Random? random}) => update(
        question: Question.randomQuestion(settings: settings, random: random),
        score: answer == question.rightAnswer ? score + 1 : 0,
        answers: answers + 1,
      );

  Game finish() => update(finished: DateTime.now());
}

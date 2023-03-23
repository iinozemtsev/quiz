import 'dart:collection';
import 'dart:math';

import 'game.dart';

enum Op { plus, minus }

extension _OpExtenion on Op {
  String get symbol {
    switch (this) {
      case Op.minus:
        return '-';
      case Op.plus:
        return '+';
    }
  }

  int eval(int left, int right) {
    switch (this) {
      case Op.plus:
        return left + right;
      case Op.minus:
        return left - right;
    }
  }
}

Game create(MathGameOptions options) => _MathGameGenerator(options).game();

class _MathGameGenerator {
  final MathGameOptions options;
  final Random random;
  _MathGameGenerator(this.options) : random = Random(options.randomSeed);

  Game game() => Game(
      currentQuestion: 0,
      score: 0,
      questions: List.generate(options.questionCount, (_) => question()));

  Question question() {
    var left = operand();
    var right = operand();
    final op = options.ops[random.nextInt(options.ops.length)];

    var rightAnswer = op.eval(left, right);
    if (rightAnswer < 0 && !options.negativeNumbers) {
      left = right;
      right = left;
      rightAnswer = op.eval(left, right);
    }

    final offByOneAnswer = rightAnswer + (random.nextBool() ? 1 : (-1));
    final randomAnswers = List.generate(
        options.answerCount - 2,
        (_) => rand(
            options.negativeNumbers ? -(options.max * 2) : 0, options.max * 2));

    final answers = ([rightAnswer, offByOneAnswer, ...randomAnswers]
          ..shuffle(random))
        .map((value) =>
            Answer(title: value.toString(), isCorrect: value == rightAnswer));

    return Question(
        answers: answers.toList(), title: '$left ${op.symbol} $right');
  }

  int rand(int from, int to) => random.nextInt(to - from) + from;

  int operand() => rand(options.min, options.max);
}

class MathGameOptions {
  final int questionCount;
  final int answerCount;
  final UnmodifiableListView<Op> ops;
  final int min;
  final int max;
  final int? randomSeed;
  final bool negativeNumbers;

  MathGameOptions(
      {this.questionCount = 10,
      this.answerCount = 3,
      Iterable<Op> ops = const {Op.plus},
      this.min = 1,
      this.max = 10,
      this.randomSeed,
      this.negativeNumbers = false})
      : ops = UnmodifiableListView(ops.toSet());
}

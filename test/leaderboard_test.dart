import 'package:collection/collection.dart';
import 'package:playground/src/model/game.dart';
import 'package:playground/src/model/game_settings.dart';
import 'package:playground/src/model/leaderboard.dart';
import 'package:playground/src/model/question.dart';
import 'package:test/test.dart' hide Timeout;

const oneMin = Duration(minutes: 1);
const tenSec = Duration(seconds: 10);
const t1 = Timeout(oneMin);
const mq1 = MaxQuestions(15);
const oneMinSettings = GameSettings(limit: t1, maxNumber: 4);

void main() {
  group('Entry', () {
    test('compare max questions', () {
      final a = Entry(name: 'aa', duration: oneMin, limit: mq1, score: 10);
      final b = Entry(name: 'bb', duration: tenSec, limit: mq1, score: 12);

      expect(a.compareTo(b), greaterThan(0));
      expect(b.compareTo(a), lessThan(0));
      expect(b.compareTo(b), 0);
    });

    test('compare timeouts', () {
      final a = Entry(name: 'aa', duration: oneMin, limit: t1, score: 10);
      final b = Entry(name: 'bb', duration: tenSec, limit: t1, score: 12);

      expect(a.compareTo(b), greaterThan(0));
      expect(b.compareTo(a), lessThan(0));
      expect(b.compareTo(b), 0);
    });

    test('lower bound', () {
      final lb = Leaderboard([
        Entry(name: '2', duration: oneMin, limit: t1, score: 10),
        Entry(name: '1', duration: tenSec, limit: t1, score: 20)
      ]);

      final g = Game(
          settings: oneMinSettings,
          question: Question.randomQuestion(settings: oneMinSettings),
          score: 10,
          answers: 50,
          started: DateTime.now(),
          finished: DateTime.now());
      expect(lb.findPosition(g), 2);
    });
  });
}

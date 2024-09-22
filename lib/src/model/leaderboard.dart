import 'package:collection/collection.dart';

import 'game.dart';
import 'game_settings.dart';

const leaderboardLength = 10;

/// Immutable model for leaderboard.
///
/// Kind of a database snapshot without persistence layer.
class Leaderboard {
  final Map<GameLimit, List<Entry>> entries;

  Leaderboard(Iterable<Entry> entries)
      : entries = entries.groupListsBy((entry) => entry.limit).map(
            (k, v) => MapEntry(k, v.sorted().take(leaderboardLength).toList()));

  List<Entry> operator [](GameLimit limit) => entries[limit] ?? <Entry>[];

  /// Index of a game, if it is added to a leaderboard.
  int findPosition(Game game) {
    final dummyEntry = Entry.fromGame('dummy', game);
    final entries = this[game.settings.limit];
    var start = entries.lowerBound(dummyEntry);
    while (
        start < entries.length && entries[start].compareTo(dummyEntry) == 0) {
      start++;
    }
    return start;
  }
}

class Entry implements Comparable<Entry> {
  /// User name.
  final String name;

  /// The game limit, e.g. timeout or question count.
  final GameLimit limit;

  /// The game score.
  final int score;

  /// The game duration;
  final Duration duration;

  Entry(
      {required this.name,
      required this.limit,
      required this.score,
      required this.duration});

  @override

  /// Less is 'higher' in leaderboard.
  int compareTo(Entry other) {
    if (other.limit != limit) {
      throw StateError('Cannot compare entries with different limits');
    }
    return switch (limit.limitType) {
      // Better score is better. Same score: faster is better.
      GameLimitType.maxQuestions => other.score != score
          ? other.score.compareTo(score)
          : duration.compareTo(other.duration),
      GameLimitType.timeout => other.score.compareTo(score)
    };
  }

  /// How to change this to not to ask name?
  static Entry fromGame(String name, Game game) => Entry(
      name: name,
      duration: game.finished!.difference(game.started),
      limit: game.settings.limit,
      score: game.score);
}

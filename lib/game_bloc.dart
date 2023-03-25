import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/math.dart';

import 'game.dart';

abstract class GameEvent {}

class GameAnswer implements GameEvent {
  final int index;

  GameAnswer(this.index);
}

class NewGame implements GameEvent {}

class GameBloc extends Bloc<GameEvent, Game> {
  GameBloc({required Game game}) : super(game) {
    on<GameAnswer>(_onGameAnswer);
    on<NewGame>(_onNewGame);
  }

  FutureOr<void> _onGameAnswer(GameAnswer event, Emitter<Game> emit) {
    emit(state.answer(event.index));
  }

  FutureOr<void> _onNewGame(NewGame event, Emitter<Game> emit) {
    emit(create(MathGameOptions()));
  }
}

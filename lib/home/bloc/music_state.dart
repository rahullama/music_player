import 'package:equatable/equatable.dart';

import 'package:music_player/home/model/music_model.dart';

abstract class MusicState extends Equatable {}

class MusicInitialState extends MusicState {
  @override
  List<Object> get props => [];
}

class MusicLoadingState extends MusicState {
  @override
  List<Object> get props => [];
}

class MusicSuccessState extends MusicState {

  final MusicModel musicModel;

  MusicSuccessState({required this.musicModel});
  @override
  List<Object> get props => [musicModel];
}

class MusicFailureState extends MusicState {

  final String? message;
  MusicFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
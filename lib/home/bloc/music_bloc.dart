import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:music_player/home/bloc/music_event.dart';
import 'package:music_player/home/bloc/music_state.dart';
import 'package:music_player/home/model/music_model.dart';
import 'package:music_player/home/repo/music_repo.dart';


class MusicBloc extends Bloc<MusicEvent, MusicState> {

  MusicRepository musicRepository;

  MusicBloc({
    required this.musicRepository
  }) : super(MusicInitialState()){
    on<FetchMusicEvent>((event,emit) async {
        emit(MusicLoadingState());
        try {
          MusicModel musicModel = await musicRepository.musicList(data: event.emailId);
          if (musicModel.status == 500) {
            emit(MusicFailureState(message: musicModel.error));
          } else {
            emit(MusicSuccessState(musicModel: musicModel));
          }
        } catch (e) {
          emit(MusicFailureState(message: e.toString()));
        }
    });
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/utils/theme/theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode>{
  ThemeBloc() : super(ThemeMode.light){
    on<ThemeEvent>((event, emit){
      emit(event.isDark?ThemeMode.dark:ThemeMode.light);
    });
  }
}
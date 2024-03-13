import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {}

class FetchMusicEvent extends MusicEvent {
  final String emailId;

  FetchMusicEvent({required this.emailId});

  @override

  List<Object> get props => [];
}
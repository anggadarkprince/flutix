import 'package:equatable/equatable.dart';
import 'package:flutix/models/movie.dart';

class Favorite extends Equatable {
  final String id;
  final Movie movie;
  final String userID;
  final DateTime time;

  Favorite(this.id, this.movie, this.userID, this.time);

  @override
  List<Object> get props => [id, movie, userID, time];
}
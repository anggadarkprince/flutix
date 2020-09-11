import 'package:equatable/equatable.dart';
import 'package:flutix/models/movie.dart';
import 'package:flutix/models/movie_detail.dart';

class Favorite extends Equatable {
  final String id;
  final Movie movie;
  final MovieDetail movieDetail;
  final String userID;
  final DateTime time;

  Favorite(this.id, this.movieDetail, this.userID, this.time, {this.movie});

  @override
  List<Object> get props => [id, movieDetail, userID, time];
}
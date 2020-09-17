import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final int id;
  final String genre;

  Genre(this.id, this.genre);

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
    json['id'],
    json['name'],
  );

  @override
  List<Object> get props => [id, genre];
}
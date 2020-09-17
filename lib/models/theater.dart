import 'package:equatable/equatable.dart';

class Theater extends Equatable {
  final String name;
  final String location;

  Theater(this.name, this.location);

  @override
  List<Object> get props => [name, location];
}
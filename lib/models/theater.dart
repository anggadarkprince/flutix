import 'package:equatable/equatable.dart';

class Theater extends Equatable {
  final String name;
  final String location;
  final double lat;
  final double lng;

  Theater(this.name, this.location, {this.lat, this.lng});

  @override
  List<Object> get props => [name, location, lat, lng];
}
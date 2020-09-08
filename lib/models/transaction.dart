import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Transaction extends Equatable {
  final String userID;
  final String title;
  final String theater;
  final int amount;
  final DateTime time;
  final String picture;

  Transaction({@required this.userID, @required this.title, @required this.theater, this.amount = 0, @required this.time, this.picture});

  @override
  List<Object> get props => [userID, title, theater, amount, time, picture];
}

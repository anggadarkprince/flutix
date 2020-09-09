import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Transaction extends Equatable {
  final String userID;
  final String type;
  final String category;
  final String title;
  final String subtitle;
  final int amount;
  final DateTime time;
  final String picture;

  Transaction({
    @required this.userID, 
    @required this.type, 
    @required this.category, 
    @required this.title, 
    @required this.subtitle, 
    this.amount = 0, 
    @required this.time, 
    this.picture
  });

  @override
  List<Object> get props => [userID, title, subtitle, amount, time, picture];
}

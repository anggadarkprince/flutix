import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Promo extends Equatable {
  final String title;
  final String description;
  final int discount;
  final Timestamp effectiveDate;
  final Timestamp expiredDate;

  Promo({@required this.title, @required this.description, @required this.discount, this.effectiveDate, this.expiredDate});

  @override
  List<Object> get props => [title, description, discount];
}
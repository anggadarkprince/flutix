import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Voucher extends Equatable {
  final String id;
  final String userID;
  final String couponCode;
  final String title;
  final String description;
  final int discount;
  final Timestamp expiredDate;

  Voucher(this.id, this.userID, this.couponCode, this.title, this.description, this.discount, this.expiredDate);

  @override
  List<Object> get props => [userID, couponCode, title, description, discount, expiredDate];
}
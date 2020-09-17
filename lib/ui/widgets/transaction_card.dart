import 'package:flutix/models/transaction.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final double width;

  TransactionCard(this.transaction, this.width);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 90,
          width: 70,
          margin: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: (transaction.picture != null)
                ? NetworkImage(imageBaseURL + 'w500' + transaction.picture)
                : AssetImage('assets/bg_topup.png'),
              fit: BoxFit.cover
            )
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              width: width - 86,
              child: Text(
                transaction.title,
                style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.clip,
              )
            ),
            SizedBox(height: 5),
            SizedBox(
              width: width - 86,
              child: Text(
                NumberFormat.currency(locale: 'id_ID', symbol: 'IDR ', decimalDigits: 0).format(transaction.amount < 0 ? -transaction.amount : transaction.amount),
                style: whiteNumberFont.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: transaction.amount < 0 ? Color(0xFFFF5C83) : Color(0xFF3E9D9D)
                ),
              )
            ),
            SizedBox(height: 5),
            SizedBox(
              width: width - 85,
              child: Text(
                transaction.subtitle,
                style: greyTextFont.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
              )
            ),
          ],
        )
      ],
    );
  }
}

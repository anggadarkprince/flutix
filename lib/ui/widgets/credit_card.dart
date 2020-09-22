import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutix/models/credit.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';

class CreditCard extends StatelessWidget {
  final Credit credit;

  CreditCard(this.credit);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(8),
            image: (credit.profilePath == null) ? null : DecorationImage(
              image: CachedNetworkImageProvider(imageBaseURL + "w185" + credit.profilePath),
              fit: BoxFit.cover
            )
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          width: 70,
          child: Text(
            credit.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: darkTextFont.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
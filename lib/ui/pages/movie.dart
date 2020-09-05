import 'package:flutix/models/models.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class MoviePage extends StatelessWidget {
  
  final User user;

  MoviePage(this.user);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // note: HEADER
        Container(
          decoration: BoxDecoration(
            color: accentColor1,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)
            )
          ),
          padding: EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 30),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF5F558B), width: 1)
                ),
                child: Stack(
                  children: <Widget>[
                    SpinKitFadingCircle(
                      color: accentColor2,
                      size: 50,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: user.profilePicture == "" || user.profilePicture == null 
                            ? AssetImage("assets/user_pic.png") 
                            : NetworkImage(user.profilePicture),
                          fit: BoxFit.cover
                        )
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 2 * defaultMargin - 78,
                    child: Text(
                      user.name ?? 'User',
                      style: whiteTextFont.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(locale: "id_ID", decimalDigits: 0, symbol: "IDR ").format(user.balance ?? 0),
                    style: yellowNumberFont.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
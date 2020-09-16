import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/transaction.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/services/transaction_service.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/topup.dart';
import 'package:flutix/ui/widgets/shimmer_list.dart';
import 'package:flutix/ui/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class WalletScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: accentColor1),
          SafeArea(child: Container(color: Colors.white)),
          Container(
            margin: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 0),
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    _buildTitle(context),
                    FutureBuilder(
                      future: UserService.getUser(auth.FirebaseAuth.instance.currentUser.uid),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return _buildWallet(snapshot.data, context);
                        } else {
                          return Container(
                            margin: EdgeInsets.only(top: 70),
                            child: ShimmerList(ShimmerListTemplate.Wallet, itemCount: 1)
                          );
                        }
                      }
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, 1),
                  end: Alignment(0, 0),
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0)
                  ]
                )
              ),
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 250,
              height: 50,
              margin: EdgeInsets.only(bottom: 30),
              child: RaisedButton(
                elevation: 15,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                color: mainColor,
                child: Text(
                  MyLocalization.of(context).topUpMyWallet,
                  style: whiteTextFont.copyWith(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TopUpScreen()));
                }
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              child: Icon(Icons.arrow_back, color: darkColor),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  MyLocalization.of(context).myWallet,
                  style: darkTextFont.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w600
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWallet(User user, BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 50),
        Container(
          height: 180,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFF382A74),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, 5)
              )
            ]
          ),
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: CardReflectionClipper(),
                child: Container(
                  height: 185,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0)
                        ]
                      )
                    ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 18,
                          height: 18,
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFF2CB)
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor2
                          ),
                        )
                      ],
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id_ID', symbol: 'IDR ', decimalDigits: 0).format(user.balance),
                      style: whiteNumberFont.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(MyLocalization.of(context).cardHolder, style: whiteTextFont.copyWith(fontSize: 10, fontWeight: FontWeight.w300)),
                            SizedBox(height: 2),
                            Row(
                              children: <Widget>[
                                Text(user.name, style: whiteTextFont.copyWith(fontSize: 12)),
                                SizedBox(width: 5),
                                SizedBox(height: 14, width: 14, child: Image.asset('assets/ic_check.png'))
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(MyLocalization.of(context).cardId, style: whiteTextFont.copyWith(fontSize: 10, fontWeight: FontWeight.w300)),
                            SizedBox(height: 2),
                            Row(
                              children: <Widget>[
                                Text(user.id.substring(0, 10).toUpperCase(), style: whiteNumberFont.copyWith(fontSize: 12)),
                                SizedBox(width: 5),
                                SizedBox(height: 14, width: 14, child: Image.asset('assets/ic_check.png'))
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(MyLocalization.of(context).recentTransaction, style: darkTextFont.copyWith(fontWeight: FontWeight.w600))
        ),
        SizedBox(height: 15),
        FutureBuilder(
          future: TransactionService.getTransaction(user.id),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return _buildTransactionList(snapshot.data, MediaQuery.of(context).size.width - 2 * defaultMargin);
            } else {
              return ShimmerList(ShimmerListTemplate.Ticket, itemCount: 3);
            }
          }
        ),
        SizedBox(height: 75)
      ],
    );
  }

  Column _buildTransactionList(List<Transaction> transactions, double width) {
    transactions.sort((transaction1, transaction2) => transaction2.time.compareTo(transaction1.time));

    return Column(
      children: transactions.map((transaction) => Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: TransactionCard(transaction, width),
        )).toList(),
    );
  }
}

class CardReflectionClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 15);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

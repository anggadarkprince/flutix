import 'package:flutix/extensions/extensions.dart';
import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/transaction.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/checkout_process.dart';
import 'package:flutix/ui/widgets/money_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class TopUpScreen extends StatefulWidget {

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  TextEditingController amountController = TextEditingController(text: 'IDR 0');
  int selectedAmount = 0;

  @override
  Widget build(BuildContext context) {
    double cardWidth = (MediaQuery.of(context).size.width - 2 * defaultMargin - 40) / 3;

    return Scaffold(
      body: ListView(
        children: <Widget>[
          _buildTitle(context),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (text) {
                    String temp = '';

                    for (int i = 0; i < text.length; i++) {
                      temp += text.isDigit(i) ? text[i] : '';
                    }

                    setState(() {
                      selectedAmount = int.tryParse(temp) ?? 0;
                    });

                    amountController.text = NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'IDR ',
                      decimalDigits: 0
                    ).format(selectedAmount);

                    amountController.selection = TextSelection.fromPosition(TextPosition(offset: amountController.text.length));
                  },
                  controller: amountController,
                  decoration: InputDecoration(
                    labelStyle: greyTextFont,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: MyLocalization.of(context).amount,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 14),
                    child: Text(MyLocalization.of(context).chooseByTemplate, style: darkTextFont),
                  ),
                ),
                Wrap(
                  spacing: 20,
                  runSpacing: 14,
                  children: <Widget>[
                    makeMoneyCard(amount: 50000, width: cardWidth),
                    makeMoneyCard(amount: 100000, width: cardWidth),
                    makeMoneyCard(amount: 150000, width: cardWidth),
                    makeMoneyCard(amount: 200000, width: cardWidth),
                    makeMoneyCard(amount: 250000, width: cardWidth),
                    makeMoneyCard(amount: 500000, width: cardWidth),
                    makeMoneyCard(amount: 1000000, width: cardWidth),
                    makeMoneyCard(amount: 2500000, width: cardWidth),
                    makeMoneyCard(amount: 5000000, width: cardWidth)
                  ],
                ),
                SizedBox(height: 100),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: FutureBuilder(
                    future: UserService.getUser(auth.FirebaseAuth.instance.currentUser.uid),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        User user = snapshot.data;
                        return RaisedButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            MyLocalization.of(context).topUpMyWallet,
                            style: whiteTextFont.copyWith(
                              fontSize: 16,
                              color: (selectedAmount > 0) ? Colors.white : Color(0xFFBEBEBE)
                            ),
                          ),
                          disabledColor: Color(0xFFE4E4E4),
                          color: Color(0xFF3E9D9D),
                          onPressed: (selectedAmount > 0)
                            ? () {
                                Transaction transaction = Transaction(
                                  userID: user.id,
                                  type: 'DEBIT',
                                  category: 'TOP UP',
                                  title: "Top Up Wallet",
                                  amount: selectedAmount,
                                  subtitle: "${DateTime.now().dayName}, ${DateTime.now().day} ${DateTime.now().monthName} ${DateTime.now().year}",
                                  time: DateTime.now()
                                );
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutProcessScreen(user, transaction, null)));
                              }
                            : null
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.only(top: 70),
                          child: SpinKitFadingCircle(
                            size: 50,
                            color: mainColor,
                          )
                        );
                      }
                    }
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          )
        ],
      ),
    );
  }
  
  Widget _buildTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: defaultMargin, bottom: 25, right: defaultMargin),
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
                  MyLocalization.of(context).topUp,
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

  MoneyCard makeMoneyCard({int amount, double width}) {
    return MoneyCard(
      amount: amount,
      width: width,
      isSelected: amount == selectedAmount,
      onTap: () {
        setState(() {
          if (selectedAmount != amount) {
            selectedAmount = amount;
          } else {
            selectedAmount = 0;
          }

          amountController.text = NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'IDR ').format(selectedAmount);
          amountController.selection = TextSelection.fromPosition(TextPosition(offset: amountController.text.length));
        });
      },
    );
  }
}

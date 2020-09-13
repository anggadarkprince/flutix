import 'package:flushbar/flushbar.dart';
import 'package:flutix/models/promo.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/models/voucher.dart';
import 'package:flutix/services/promo_service.dart';
import 'package:flutix/services/voucher_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PromoCodeScreen extends StatefulWidget {
  final User user;

  PromoCodeScreen(this.user);

  @override
  _PromoCodeScreenState createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  TextEditingController promoCodeController;
  bool isDataEdited = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    promoCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text('Enter Promo Code'),
        backgroundColor: mainColor,
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: defaultMargin),
        child: Column(
          children: <Widget>[
            TextField(
              controller: promoCodeController,
              textCapitalization: TextCapitalization.characters,
              onChanged: (text) {
                setState(() {
                  isDataEdited = (text.trim().length > 0) ? true : false;
                });
              },
              style: blackTextFont,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: "Promo Code",
                hintText: "Enter promo code"
              ),
            ),
            SizedBox(height: 15),
            (isSubmitting)
              ? SizedBox(
                  width: 50,
                  height: 50,
                  child: SpinKitPulse(
                    color: Color(0xFF3E9D9D),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      "Get Voucher",
                      style: whiteTextFont.copyWith(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                    disabledColor: Color(0xFFE4E4E4),
                    color: mainColor,
                    onPressed: (isDataEdited)
                      ? () async {
                          setState(() {
                            isSubmitting = true;
                          });

                          Promo promotion = await PromoService.getPromoByCode(promoCodeController.text);
                          if (promotion == null) {
                            Flushbar(
                              duration: Duration(milliseconds: 2000),
                              flushbarPosition: FlushbarPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              message: "Voucher not found, try another",
                            )..show(context);
                          } else {
                            Voucher voucher = await VoucherService.saveVoucher(widget.user.id, promotion);
                            Flushbar(
                              duration: Duration(milliseconds: 2000),
                              flushbarPosition: FlushbarPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              message: "Voucher code ${voucher.couponCode} succesfully acquired",
                            )..show(context);
                            promoCodeController.text = '';
                          }

                          setState(() {
                            isSubmitting = false;
                          });
                        }
                      : null
                  ),
                ),
            SizedBox(height: 30),
          ],
        ),
      )
    );
  }

}

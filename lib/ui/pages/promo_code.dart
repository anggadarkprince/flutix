import 'package:flushbar/flushbar.dart';
import 'package:flutix/models/promo.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/models/voucher.dart';
import 'package:flutix/services/promo_service.dart';
import 'package:flutix/services/voucher_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/widgets/promo_card.dart';
import 'package:flutix/ui/widgets/shimmer_list.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: promoCodeController,
              textCapitalization: TextCapitalization.characters,
              onChanged: (text) {
                setState(() {
                  isDataEdited = (text.trim().length > 0) ? true : false;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: "Promo Code",
                hintText: "Enter promo code"
              ),
            ),
            SizedBox(height: 15),
            (isSubmitting)
              ? Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: SpinKitPulse(
                      color: Color(0xFF3E9D9D),
                    ),
                  )
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
                        color: isDataEdited ? Colors.white : Colors.grey[500]
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
                            var expires = promotion.expiredDate.toDate().toUtc();
                            var currentDate = DateTime.now().toUtc();
                            if (expires.compareTo(currentDate) > 0) {
                              bool isAcquired = await VoucherService.isAcquired(widget.user.id, promoCodeController.text);
                              if (isAcquired) {
                                Flushbar(
                                  duration: Duration(milliseconds: 2000),
                                  flushbarPosition: FlushbarPosition.BOTTOM,
                                  backgroundColor: Colors.orange,
                                  message: "Voucher code ${promotion.couponCode} is already acquired",
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
                            } else {                              
                              Flushbar(
                                duration: Duration(milliseconds: 2000),
                                flushbarPosition: FlushbarPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                message: "Voucher code ${promoCodeController.text} is expired to be acquired",
                              )..show(context);
                            }
                          }

                          setState(() {
                            isSubmitting = false;
                          });
                        }
                      : null
                  ),
                ),
            SizedBox(height: 30),
            Text('Active Promo', style: darkTextFont.copyWith(fontSize: 16)),
            SizedBox(height: 20),
            FutureBuilder(
              future: PromoService.getPromotions(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map<Widget>((Promo promoItem) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: PromoCard(promoItem, onTap: () {
                          promoCodeController.text = promoItem.couponCode;
                          setState(() {
                            isDataEdited = true;
                          });
                        })
                      );
                    }).toList(),
                  );
                } else {
                  return ShimmerList(ShimmerListTemplate.Promo);
                }
              }
            )
          ],
        ),
      )
    );
  }

}

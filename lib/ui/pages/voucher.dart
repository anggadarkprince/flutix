import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/models/voucher.dart';
import 'package:flutix/services/voucher_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VoucherScreen extends StatefulWidget {
  final User user;

  VoucherScreen(this.user);

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text(MyLocalization.of(context).menuMyVoucher),
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
      body: FutureBuilder(
        future: VoucherService.getVouchers(widget.user.id),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            List<Voucher> vouchers = snapshot.data;
            if (vouchers.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 85,
                      width: 85,
                      child: Image(image: AssetImage('assets/ic_tickets_grey.png'))
                    ),
                    SizedBox(height: 5),
                    Text(
                      'No voucher available', 
                      style: greyTextFont.copyWith(fontSize: 16)
                    )
                  ]
                ),
              );
            }

            return _buildVoucherList(vouchers, context);
          } else if (snapshot.hasError) {
            return Container(
              padding: EdgeInsets.all(defaultMargin),
              child: Center(child: Text("${snapshot.error}")),
            );
          } else {
            return Container(
              margin: EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 0),
              child: ShimmerList(ShimmerListTemplate.Ticket)
            );
          }
        }
      )
    );
  }

  Widget _buildVoucherList(List<Voucher> vouchers, context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        itemCount: vouchers.length,
        itemBuilder: (_, index) {
          String expiredFormat = DateFormat('dd MMM yyyy H:mm').format(vouchers[index].expiredDate.toDate());
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 90,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blueGrey[100],
                        image: DecorationImage(
                          image: AssetImage('assets/bg_topup.png'),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            vouchers[index].couponCode.toUpperCase() + " - Disc ${vouchers[index].discount}%",
                            style: GoogleFonts.openSans().copyWith(color: darkColor, fontWeight: FontWeight.w600, fontSize: 22),
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Expired at $expiredFormat",
                            style: darkTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          Text(
                            vouchers[index].title,
                            style: greyTextFont.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      
                    },
                  )
                )
              ),
            ]
          );
        }
      )
    );
  }
}

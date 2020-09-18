import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/ticket.dart';
import 'package:flutix/models/transaction.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/services/ticket_service.dart';
import 'package:flutix/services/transaction_service.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/home.dart';
import 'package:flutix/ui/pages/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CheckoutProcessScreen extends StatelessWidget {
  final User user;
  final Ticket ticket;
  final Transaction transaction;

  CheckoutProcessScreen(this.user, this.transaction, this.ticket);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: ticket != null ? processingTicketOrder(context) : processingTopUp(),
        builder: (_, snapshot) => (snapshot.connectionState == ConnectionState.done)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  margin: EdgeInsets.only(bottom: 70),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ticket == null ? "assets/top_up_done.png" : "assets/ticket_done.png")
                    )
                  ),
                ),
                Text(
                  (ticket == null) ? MyLocalization.of(context).readyToExplore : MyLocalization.of(context).happyWatching,
                  style: blackTextFont.copyWith(fontSize: 20),
                ),
                SizedBox(height: 16),
                Text(
                  (ticket == null) ? MyLocalization.of(context).successTopUpMessage : MyLocalization.of(context).successBoughtTicketMessage,
                  textAlign: TextAlign.center,
                  style: blackTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Container(
                  height: 45,
                  width: 250,
                  margin: EdgeInsets.only(top: 70, bottom: 20),
                  child: RaisedButton(
                    elevation: 4,
                    color: mainColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      (ticket == null) ? MyLocalization.of(context).myWallet : MyLocalization.of(context).myTickets,
                      style: whiteTextFont.copyWith(fontSize: 16),
                    ),
                    onPressed: () {
                      if (ticket == null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => WalletScreen()),
                          (Route<dynamic> route) => route.isFirst,
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen(tabIndex: 2)),
                          (Route<dynamic> route) => false,
                        );
                      }
                    }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      MyLocalization.of(context).discoverNewMovie,
                      style: greyTextFont.copyWith( fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(MyLocalization.of(context).backToHome, style: purpleTextFont),
                    )
                  ],
                )
              ],
            )
          : Center(
              child: SpinKitPulse(
                color: mainColor,
                size: 50,
              ),
            )),
    );
  }

  Future<void> processingTicketOrder(BuildContext context) async {
    await UserService.purchaseTicket(this.user, ticket.totalPrice);
    await TicketService.saveTicket(transaction.userID, ticket);
    await TransactionService.saveTransaction(transaction);
  }

  Future<void> processingTopUp() async {
    await UserService.depositTicket(this.user, transaction.amount);
    await TransactionService.saveTransaction(transaction);
  }
}

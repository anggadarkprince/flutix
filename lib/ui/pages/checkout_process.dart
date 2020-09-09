import 'package:flutix/models/models.dart';
import 'package:flutix/models/ticket.dart';
import 'package:flutix/models/transaction.dart';
import 'package:flutix/services/ticket_service.dart';
import 'package:flutix/services/transaction_service.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/home.dart';
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
                  (ticket == null) ? "Emmm Yummy!" : "Happy Watching!",
                  style: blackTextFont.copyWith(fontSize: 20),
                ),
                SizedBox(height: 16),
                Text(
                  (ticket == null) ? "You have successfully\ntop up the wallet" : "You have successfully\nbought the ticket",
                  textAlign: TextAlign.center,
                  style: blackTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Container(
                  height: 45,
                  width: 250,
                  margin: EdgeInsets.only(top: 70, bottom: 20),
                  child: RaisedButton(
                    elevation: 0,
                    color: mainColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      (ticket == null) ? "My Wallet" : "My Tickets",
                      style: whiteTextFont.copyWith(fontSize: 16),
                    ),
                    onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(tabIndex: 1)));
                    }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Discover new movie? ",
                      style: greyTextFont.copyWith( fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                      child: Text("Back to Home", style: purpleTextFont),
                    )
                  ],
                )
              ],
            )
          : Center(
              child: SpinKitFadingCircle(
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

  Future<void> processingTopUp() async {}
}

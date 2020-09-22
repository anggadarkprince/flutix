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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class CheckoutProcessScreen extends StatefulWidget {
  final User user;
  final Ticket ticket;
  final Transaction transaction;

  CheckoutProcessScreen(this.user, this.transaction, this.ticket);

  @override
  _CheckoutProcessScreenState createState() => _CheckoutProcessScreenState();
}

class _CheckoutProcessScreenState extends State<CheckoutProcessScreen> {
  User user;
  Ticket ticket;
  Transaction transaction;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initState() {
    super.initState();
    user = widget.user;
    ticket = widget.ticket;
    transaction = widget.transaction;

    var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

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
                          MaterialPageRoute(builder: (context) => HomeScreen(tabIndex: 3)),
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

    var android = AndroidNotificationDetails('100', 'ticket ', 'Bought Ticket Message', priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
      100, 
      'Flutix Ticket', 
      MyLocalization.of(context).successBoughtTicketMessage + ' ' + ticket.movieDetail.title, platform,
      payload: 'ticket'
    ); 
  }
  

  Future<void> processingTopUp() async {
    await UserService.depositTicket(this.user, transaction.amount);
    await TransactionService.saveTransaction(transaction);
    String totalTopUp = NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'IDR ').format(transaction.amount);

    var android = AndroidNotificationDetails('100', 'ticket ', 'Top Up Message', priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
      100, 
      'Flutix Top Up', 
      MyLocalization.of(context).successTopUpMessage + ' ' + totalTopUp, platform,
      payload: 'wallet'
    ); 
  }
}

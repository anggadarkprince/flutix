import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/movie_detail.dart';
import 'package:flutix/models/ticket.dart';
import 'package:flutix/models/transaction.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/checkout_process.dart';
import 'package:flutix/ui/pages/topup.dart';
import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class CheckoutScreen extends StatefulWidget {
  final Ticket ticket;

  CheckoutScreen(this.ticket);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int total = 0;

  @override
  Widget build(BuildContext context) {
    User user;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: accentColor1),
          SafeArea(child: Container(color: Colors.white)),
          FutureBuilder(
            future: UserService.getUser(auth.FirebaseAuth.instance.currentUser.uid),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                user = snapshot.data;
              } else if (snapshot.hasError) {
                return Container(
                  padding: EdgeInsets.all(defaultMargin),
                  child: Center(child: Text("${snapshot.error}")),
                );
              }

              return Column(
                children: <Widget>[
                  _buildTitle(),
                  _buildMovieDescription(widget.ticket.movieDetail),
                  _buildBookingSummary(widget.ticket, user),
                  Spacer(),
                  _buildSubmitButton(user),
                ],
              );
            }
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50, left: defaultMargin, right: defaultMargin),
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
            child: Text(
              MyLocalization.of(context).checkout,
              style: darkTextFont.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600
              )
            )
          )
        ],
      ),
    );
  }

  Widget _buildMovieDescription(MovieDetail movieDetail) {
    return Container(
      margin: EdgeInsets.only(left: defaultMargin, top: 30, right: defaultMargin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 90,
            height: 90,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageBaseURL + 'w342' + movieDetail.posterPath),
                fit: BoxFit.cover
              )
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  movieDetail.title,
                  style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  movieDetail.genresAndLanguage,
                  maxLines: 2,
                  style: greyTextFont.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 5),
                RatingStars(
                  voteAverage: movieDetail.voteAverage,
                  color: accentColor3,
                )
              ],
            )
          )
        ],
      )
    );
  }

  Widget _buildBookingSummary(Ticket ticket, User user) {
    int totalTicket = ticket.seats.length;
    int adminFee = 1500;
    int ticketPrice = 25000;
    total = (ticketPrice + adminFee) * totalTicket;

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: defaultMargin),
          child: Divider(color: Color(0xFFE4E4E4), thickness: 1)
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(MyLocalization.of(context).orderId, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              Text(
                ticket.bookingCode,
                style: whiteNumberFont.copyWith(
                  color: darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(MyLocalization.of(context).cinema, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              Text(
                ticket.theater.name,
                style: whiteNumberFont.copyWith(
                  color: darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(MyLocalization.of(context).date, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              Text(
                DateFormat('EEE, dd MMM yyyy').format(ticket.time).toUpperCase(),
                style: whiteNumberFont.copyWith(
                  color: darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(MyLocalization.of(context).time, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              Text(
                DateFormat('H:mm').format(ticket.time).toUpperCase(),
                style: whiteNumberFont.copyWith(
                  color: darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(MyLocalization.of(context).seatNumbers, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              Text(
                ticket.seatsInString,
                style: whiteNumberFont.copyWith(
                  color: darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(MyLocalization.of(context).price, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              Text(
                NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'IDR ').format(ticketPrice) + " x $totalTicket",
                style: whiteNumberFont.copyWith(
                  color: darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(MyLocalization.of(context).fee, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              Text(
                "IDR 1.500 x $totalTicket",
                style: whiteNumberFont.copyWith(
                  color: darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(MyLocalization.of(context).total, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              Text(
                NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'IDR ').format(total),
                style: whiteNumberFont.copyWith(
                  color: darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 15),
          child: Divider(color: Color(0xFFE4E4E4), thickness: 1)
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(MyLocalization.of(context).yourWallet, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              (user != null) 
                ? Text(NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'IDR ').format(user.balance),
                    style: whiteNumberFont.copyWith(
                      color: user.balance >= total ? Colors.green : Color(0xFFFF5C83),
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    )
                  )
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: SpinKitPulse(
                      color: accentColor3,
                    ),
                  )
            ],
          )
        )
      ],
    );
  }

  Widget _buildSubmitButton(User user) {
    return (user != null)
      ? Container(
          width: 250,
          height: 50,
          margin: EdgeInsets.only(top: 30, bottom: 30),
          child: RaisedButton(
            elevation: 4,
            color: user.balance >= total ? mainColor : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Text(
              user.balance >= total ? MyLocalization.of(context).checkoutNow : MyLocalization.of(context).topUpMyWallet,
              style: whiteTextFont.copyWith(fontSize: 16),
            ),
            onPressed: () {
              if (user.balance >= total) {
                Transaction transaction = Transaction(
                  userID: user.id,
                  type: 'CREDIT',
                  category: 'TICKET',
                  title: widget.ticket.movieDetail.title,
                  subtitle: widget.ticket.theater.name,
                  time: DateTime.now(),
                  amount: -total,
                  picture: widget.ticket.movieDetail.posterPath
                );
                Ticket ticket = widget.ticket.copyWith(totalPrice: total);

                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutProcessScreen(user, transaction, ticket)));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TopUpScreen()));
              }
            }
          ),
        )
      : Container(
          margin: EdgeInsets.only(top: 30, bottom: 30),
          child: SizedBox(
            height: 50,
            width: 50,
            child: SpinKitFadingCircle(
              color: accentColor1,
            ),
          )
        );
  }
}
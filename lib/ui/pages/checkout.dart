import 'package:flutix/models/models.dart';
import 'package:flutix/models/movie_detail.dart';
import 'package:flutix/models/ticket.dart';
import 'package:flutix/models/transaction.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/checkout_process.dart';
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
      margin: EdgeInsets.only(top: 40, left: defaultMargin, right: defaultMargin),
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
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Checkout",
                  style: darkTextFont.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieDescription(MovieDetail movieDetail) {
    return Row(
      children: <Widget>[
        Container(
          width: 90,
          height: 90,
          margin: EdgeInsets.only(left: defaultMargin, right: 20, top: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageBaseURL + 'w342' + movieDetail.posterPath),
              fit: BoxFit.cover
            )
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width - 2 * defaultMargin - 70 - 20,
              child: Text(
                movieDetail.title,
                style: blackTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.clip,
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width - 2 * defaultMargin - 70 - 20,
              margin: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                movieDetail.genresAndLanguage,
                style: greyTextFont.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
            RatingStars(
              voteAverage: movieDetail.voteAverage,
              color: accentColor3,
            )
          ],
        )
      ],
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
            children: <Widget>[
              Text("Order ID", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Cinema", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Date & Time", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              Text(
                DateFormat('EEE, dd MMM yyyy H:mm').format(ticket.time).toUpperCase(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Seat Numbers", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
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
              Text("Price", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
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
              Text("Fee", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
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
              Text("Total", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
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
          margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 20),
          child: Divider(color: Color(0xFFE4E4E4), thickness: 1)
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Your Wallet", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              (user != null) 
                ? Text(NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'IDR ').format(user.balance),
                    style: whiteNumberFont.copyWith(
                      color: user.balance >= total ? Color(0xFF3E9D9D) : Color(0xFFFF5C83),
                      fontSize: 16,
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
          height: 46,
          margin: EdgeInsets.only(top: 30, bottom: 30),
          child: RaisedButton(
            elevation: 4,
            color: user.balance >= total ? Color(0xFF3E9D9D) : mainColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Text(
              user.balance >= total ? "Checkout Now" : "Top Up My Wallet",
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
                // # Uang tidak cukup
              }
            }
          ),
        )
      : SizedBox(
          height: 50,
          width: 50,
          child: SpinKitFadingCircle(
            color: accentColor3,
          ),
        );
  }
}
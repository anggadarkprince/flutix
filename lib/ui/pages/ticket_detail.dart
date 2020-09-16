import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/ticket.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/widgets/dashed_line.dart';
import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailScreen extends StatelessWidget {
  final Ticket ticket;

  TicketDetailScreen(this.ticket);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Color(0xFFF6F7F9),
      body: Container(
        padding: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildTitle(mediaQuery, context),
                _buildMovieCover(ticket),
                _buildTicketSummary(mediaQuery, context, ticket),
                _buildTicketBarcode(context, ticket),
                SizedBox(height: 40)
              ],
            )
          ],
        ),
      )
    );
  }

  Widget _buildTitle(MediaQueryData mediaQuery, BuildContext context) {
    final double statusBarHeight = mediaQuery.padding.top;

    return Column(
      children: [
        SizedBox(height: statusBarHeight - 5),
        Container(
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
                      MyLocalization.of(context).ticketDetail,
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
        ),
      ],
    );
  }
  
  Widget _buildMovieCover(Ticket ticket) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      height: 170,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageBaseURL + "w500" + ticket.movieDetail.backdropPath),
          fit: BoxFit.cover
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25)
        )
      ),
    );
  }

  Widget _buildTicketSummary(MediaQueryData mediaQuery, BuildContext context, Ticket ticket) {
    return ClipPath(
      clipper: TicketTopClipper(),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              ticket.movieDetail.title,
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Text(
              ticket.movieDetail.genresAndLanguage,
              style: greyTextFont.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 5),
            RatingStars(voteAverage: ticket.movieDetail.voteAverage),
            SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(MyLocalization.of(context).cinema, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
                Text(
                  ticket.theater.name,
                  textAlign: TextAlign.end,
                  style: whiteNumberFont.copyWith(
                    color: darkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(MyLocalization.of(context).date, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
                Text(
                  DateFormat('EEE, dd MMM yyyy').format(ticket.time),
                  textAlign: TextAlign.end,
                  style: whiteNumberFont.copyWith(
                    color: darkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(MyLocalization.of(context).time, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
                Text(
                  DateFormat('H:mm').format(ticket.time),
                  textAlign: TextAlign.end,
                  style: whiteNumberFont.copyWith(
                    color: darkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(MyLocalization.of(context).seatNumbers, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
                Text(
                  ticket.seatsInString,
                  textAlign: TextAlign.end,
                  style: whiteNumberFont.copyWith(
                    color: darkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(MyLocalization.of(context).orderId, style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
                Text(
                  ticket.bookingCode,
                  textAlign: TextAlign.end,
                  style: whiteNumberFont.copyWith(
                    color: darkColor, 
                    fontSize: 16, 
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            DashedLine(mediaQuery.size.width - 2 * defaultMargin - 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketBarcode(BuildContext context, Ticket ticket) {
    return ClipPath(
      clipper: TicketBottomClipper(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${MyLocalization.of(context).name}: ", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
                Text(ticket.name, style: whiteNumberFont.copyWith(color: darkColor, fontSize: 16, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Text("${MyLocalization.of(context).paid}: ", style: greyTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
                Text(
                  NumberFormat.currency(locale: "id_ID", decimalDigits: 0, symbol: "IDR ").format(ticket.totalPrice),
                  style: whiteNumberFont.copyWith(color: darkColor, fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            QrImage(
              foregroundColor: Colors.black,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              padding: EdgeInsets.all(0),
              size: 100,
              data: ticket.bookingCode,
            )
          ],
        ),
      ),
    );
  }
}

class TicketTopClipper extends CustomClipper<Path> {
  double radius = 15;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - radius);
    path.quadraticBezierTo(radius, size.height - radius, radius, size.height);
    path.lineTo(size.width - radius, size.height);
    path.quadraticBezierTo(size.width - radius, size.height - radius, size.width, size.height - radius);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketBottomClipper extends CustomClipper<Path> {
  double radius = 15;
  
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, radius);
    path.quadraticBezierTo(size.width - radius, radius, size.width - radius, 0);
    path.lineTo(radius, 0);
    path.quadraticBezierTo(radius, radius, 0, radius);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

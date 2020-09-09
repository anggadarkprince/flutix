import 'package:flutix/models/ticket.dart';
import 'package:flutix/services/ticket_service.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/ticket_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TicketScreen extends StatefulWidget {
  final bool isExpiredTicket;

  TicketScreen({this.isExpiredTicket = false});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  bool isExpiredTickets;

  @override
  void initState() {
    super.initState();

    isExpiredTickets = widget.isExpiredTicket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // note: CONTENT
          Container(
            margin: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: FutureBuilder(
              future: TicketService.getTickets(auth.FirebaseAuth.instance.currentUser.uid),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  List<Ticket> tickets = snapshot.data;
                  return TicketViewer(isExpiredTickets
                    ? tickets.where((ticket) => ticket.time.isBefore(DateTime.now())).toList()
                    : tickets.where((ticket) => !ticket.time.isBefore(DateTime.now())).toList()
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    padding: EdgeInsets.all(defaultMargin),
                    child: Center(child: Text("${snapshot.error}")),
                  );
                } else {
                  return SpinKitFadingCircle(
                    color: mainColor,
                    size: 50,
                  );
                }
              }
            )
          ),
          // note: HEADER
          Container(height: 72, color: accentColor1),
          SafeArea(
            child: ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                height: 70,
                color: accentColor1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpiredTickets = !isExpiredTickets;
                                });
                              },
                              child: Text(
                                "Active",
                                style: whiteTextFont.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: !isExpiredTickets ? Colors.white : Color(0x55FFFFFF)
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 4,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: !isExpiredTickets ? accentColor2 : Colors.transparent,
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpiredTickets = !isExpiredTickets;
                                });
                              },
                              child: Text(
                                "Oldest",
                                style: whiteTextFont.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isExpiredTickets ? Colors.white : Color(0x55FFFFFF)
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 4,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: isExpiredTickets ? accentColor2 : Colors.transparent,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketViewer extends StatelessWidget {
  final List<Ticket> tickets;

  TicketViewer(this.tickets);

  @override
  Widget build(BuildContext context) {
    var sortedTickets = tickets;
    sortedTickets.sort((ticket1, ticket2) => ticket1.time.compareTo(ticket2.time));

    return ListView.builder(
      itemCount: sortedTickets.length,
      itemBuilder: (_, index) => GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TicketDetailScreen(sortedTickets[index])));
        },
        child: Container(
          margin: EdgeInsets.only(top: index == 0 ? 100 : 20),
          child: Row(
            children: <Widget>[
              Container(
                width: 70,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageBaseURL + 'w500' + sortedTickets[index].movieDetail.posterPath),
                    fit: BoxFit.cover
                  )
                ),
              ),
              SizedBox(width: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width - 2 * defaultMargin - 70 - 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      sortedTickets[index].movieDetail.title,
                      style: blackTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                    SizedBox(height: 5),
                    Text(
                      sortedTickets[index].movieDetail.genresAndLanguage,
                      style: greyTextFont.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      sortedTickets[index].theater.name,
                      style: greyTextFont.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }
}

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
    List<Ticket> tickets;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: FutureBuilder(
              future: TicketService.getTickets(auth.FirebaseAuth.instance.currentUser.uid),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  tickets = snapshot.data;
                } else if (snapshot.hasError) {
                  return Container(
                    padding: EdgeInsets.all(defaultMargin),
                    child: Center(child: Text("${snapshot.error}")),
                  );
                }
                return TicketViewer(tickets, isExpiredTickets);
              }
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 300,
              height: 55,
              margin: EdgeInsets.only(bottom: 110),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: accentColor1,
                boxShadow: [
                  BoxShadow(color: Color(0x55000000), spreadRadius: 3, blurRadius: 12, offset: Offset(0, 5)),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          isExpiredTickets = !isExpiredTickets;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                          color: !isExpiredTickets ? Color(0xFF1D1347) : Colors.transparent,
                        ),
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Active",
                              style: whiteTextFont.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: !isExpiredTickets ? Colors.white : Color(0x44FFFFFF)
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 4,
                              width: 80,
                              color: !isExpiredTickets ? accentColor2 : Colors.transparent,
                            )
                          ],
                        )
                      ),
                    )
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          isExpiredTickets = !isExpiredTickets;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                          color: isExpiredTickets ? Color(0xFF1D1347) : Colors.transparent,
                        ),
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Histories",
                              style: whiteTextFont.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isExpiredTickets ? Colors.white : Color(0x44FFFFFF)
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 4,
                              width: 80,
                              color: isExpiredTickets ? accentColor2 : Colors.transparent,
                            )
                          ],
                        )
                      )
                    )
                  ),
                ],
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
  final bool isExpiredTickets;

  TicketViewer(this.tickets, this.isExpiredTickets);

  @override
  Widget build(BuildContext context) {
    if (tickets == null) {
      return SpinKitPulse(
        color: mainColor,
        size: 50,
      );
    }
    
    var sortedTickets = isExpiredTickets
        ? tickets.where((ticket) => ticket.time.isBefore(DateTime.now())).toList()
        : tickets.where((ticket) => !ticket.time.isBefore(DateTime.now())).toList();
    sortedTickets.sort((ticket1, ticket2) => ticket1.time.compareTo(ticket2.time));

    if (sortedTickets.length == 0) {
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
              'No ticket available', 
              style: greyTextFont.copyWith(fontSize: 16)
            )
          ]
        ),
      );
    }

    return Container(
      child:ListView.builder(
        itemCount: sortedTickets.length,
        itemBuilder: (_, index) => Container(
          margin: EdgeInsets.only(
            top: index == 0 ? 20 : 0,
            bottom: index == sortedTickets.length - 1 ? 200 : 15
          ),
          child: Stack(
            children: <Widget>[
              Container(
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
                    SizedBox(width: 15),
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
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TicketDetailScreen(sortedTickets[index])));
                    },
                  )
                )
              )
            ]
          ) 
        )
      )
    );
  }
}
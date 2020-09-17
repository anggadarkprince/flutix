import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/ticket.dart';
import 'package:flutix/services/ticket_service.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/ticket_detail.dart';
import 'package:flutix/ui/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';

class TicketScreen extends StatefulWidget {
  final bool isExpiredTicket;

  TicketScreen({this.isExpiredTicket = false});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  bool isExpiredTickets;
  List<Ticket> tickets;

  @override
  void initState() {
    super.initState();

    isExpiredTickets = widget.isExpiredTicket;
    refreshData();
  }

  Future refreshData() {
    return TicketService.getTickets(auth.FirebaseAuth.instance.currentUser.uid)
      .then((value) {
        setState(() {
          tickets = value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        color: Colors.white,
        backgroundColor: mainColor,
        child: Stack(
          children: <Widget>[
            TicketViewer(tickets, isExpiredTickets),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 300,
                height: 55,
                margin: EdgeInsets.only(bottom: 110),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: mainColor,
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
                            color: !isExpiredTickets ? accentColor1 : Colors.transparent,
                          ),
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                MyLocalization.of(context).active,
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
                            color: isExpiredTickets ? accentColor1 : Colors.transparent,
                          ),
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                MyLocalization.of(context).history,
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
        )
      ),
    );
  }
}

class TicketViewer extends StatelessWidget {
  final List<Ticket> tickets;
  final bool isExpiredTickets;

  TicketViewer(this.tickets, this.isExpiredTickets);

  @override
  Widget build(BuildContext context) {
    if (tickets == null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 20),
        child: ShimmerList(ShimmerListTemplate.Ticket)
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
              MyLocalization.of(context).noTicketMessage, 
              style: greyTextFont.copyWith(fontSize: 16)
            )
          ]
        ),
      );
    }

    return Container(
      child:ListView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: sortedTickets.length,
        itemBuilder: (_, index) => Container(
          margin: EdgeInsets.only(
            top: index == 0 ? 20 : 0,
            bottom: index == sortedTickets.length - 1 ? 200 : 0
          ),
          padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 8),
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
                        color: Colors.blueGrey[100],
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
                            style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(height: 5),
                          Text(
                            sortedTickets[index].movieDetail.genresAndLanguage,
                            style: darkTextFont.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Text(
                                sortedTickets[index].theater.name,
                                style: greyTextFont.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                DateFormat('EEE, dd MMM yyyy').format(sortedTickets[index].time),
                                style: greyTextFont.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                              ),                              
                            ],
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

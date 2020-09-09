import 'package:flutix/models/movie_detail.dart';
import 'package:flutix/models/theater.dart';
import 'package:flutix/models/ticket.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/select_seat.dart';
import 'package:flutix/ui/widgets/date_card.dart';
import 'package:flutix/ui/widgets/selectable_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ScheduleScreen extends StatefulWidget {
  final MovieDetail movieDetail;

  ScheduleScreen(this.movieDetail);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<DateTime> dates;
  DateTime selectedDate;
  int selectedTime;
  Theater selectedTheater;
  bool isValid = false;
  bool isNext = false;

  @override
  void initState() {
    super.initState();

    dates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
    selectedDate = dates[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: accentColor1),
          SafeArea(child: Container(color: Colors.white)),
          ListView(
            children: <Widget>[
              _buildTitle(),
              _buildChooseDate(),
              _buildTimeTable(),
              _buildNextButton(),
            ],
          )
        ],
      ),
    );
  }

  Container _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: defaultMargin),
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
                  "Select Schedule",
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
    );
  }

  Column _buildChooseDate() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 16),
          child: Text("Choose Date", style: blackTextFont.copyWith(fontSize: 20)),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 24),
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (_, index) => Container(
              margin: EdgeInsets.only(
                left: (index == 0) ? defaultMargin : 0,
                right: (index < dates.length - 1) ? 16 : defaultMargin
              ),
              child: DateCard(
                dates[index],
                isSelected: selectedDate == dates[index],
                onTap: () {
                  setState(() {
                    selectedDate = dates[index];
                    selectedTime = null;
                    isValid = (selectedTime != null && selectedDate != null);
                  });
                },
              ),
            )
          ),
        ),
      ],
    );
  }

  Column _buildTimeTable() {
    List<int> schedule = List.generate(7, (index) => 10 + index * 2);
    List<Widget> widgets = [];

    for (var theater in dummyTheaters) {
      widgets.add(
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 5),
          child: Text('Theater', style: greyTextFont.copyWith(fontSize: 14, fontWeight: FontWeight.w300))
        )
      );
      widgets.add(
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 16),
          child: Text(theater.name, style: darkTextFont.copyWith(fontSize: 20, fontWeight: FontWeight.w600))
        )
      );

      widgets.add(
        Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 20),
          child: ListView.builder(
            itemCount: schedule.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => Container(
              margin: EdgeInsets.only(
                left: (index == 0) ? defaultMargin : 0,
                right: (index < schedule.length - 1) ? 16 : defaultMargin
              ),
              child: SelectableBox(
                "${schedule[index]}:00",
                height: 50,
                width: 90,
                isSelected: selectedTheater == theater && selectedTime == schedule[index],
                isEnabled: schedule[index] > DateTime.now().hour || selectedDate.day != DateTime.now().day,
                onTap: (input) {
                  if (schedule[index] > DateTime.now().hour || selectedDate.day != DateTime.now().day) {
                    setState(() {
                      selectedTheater = theater;
                      selectedTime = schedule[index];
                      isValid = (selectedTime != null && selectedDate != null);
                    });
                  }
                },
              ),
            ),
          ),
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildNextButton() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 40),
      child: (isNext)
        ? SpinKitFadingCircle(
            color: mainColor,
            size: 45,
          )
        : Align(
          alignment: Alignment.topCenter,
          child: FloatingActionButton(
            elevation: 4,
            backgroundColor: (isValid) ? mainColor : Color(0xFFE4E4E4),
            child: Icon(
              Icons.arrow_forward,
              color: isValid ? Colors.white : Color(0xFFBEBEBE),
            ),
            onPressed: () {
              if (isValid) {
                setState(() {
                  isNext = true;
                });
                auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
                UserService.getUser(_auth.currentUser.uid).then((user) {
                  setState(() {
                    isNext = false;
                  });
                  DateTime ticketDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime);
                  String bookingCode = randomAlphaNumeric(12).toUpperCase();
                  Ticket ticket = Ticket(widget.movieDetail, selectedTheater, ticketDate, bookingCode, null, user.name, 0);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectSeatScreen(ticket)));
                });
              }
            }
          ),
        ),
    );
  }

}

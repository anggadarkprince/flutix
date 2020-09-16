import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/ticket.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/checkout.dart';
import 'package:flutix/ui/widgets/selectable_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectSeatScreen extends StatefulWidget {
  final Ticket ticket;

  SelectSeatScreen(this.ticket);

  @override
  _SelectSeatScreenState createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  List<String> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: accentColor1),
          SafeArea(child: Container(color: Colors.white)),
          ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _buildTitle(),
                  _buildCinemaScreen(),
                  _buildSeats(),
                  _buildNextButton(),
                ],
              )
            ]
          )
        ],
      )
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 25, left: defaultMargin, right: defaultMargin),
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
              MyLocalization.of(context).takeSeat,
              style: darkTextFont.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600
              )
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageBaseURL + 'w154' + widget.ticket.movieDetail.posterPath),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaScreen() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 280,
      height: 85,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/screen.png"))
      ),
    );
  }

  Column _buildSeats() {
    List<int> numberofSeats = [3, 5, 5, 5, 5, 0, 5];
    List<Widget> widgets = [];

    int seatOrder = 0;
    for (int i = 0; i < numberofSeats.length; i++) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            numberofSeats[i] == 0 ? 1 : numberofSeats[i],
            (index) => Padding(
              padding: EdgeInsets.only(right: index < numberofSeats[i] - 1 ? 16 : 0, bottom: 16),
              child: SelectableBox(
                numberofSeats[i] == 0 ? '' : "${String.fromCharCode(seatOrder + 65)}${index + 1}",
                width: numberofSeats[i] == 0 ? 270 : 40,
                height: numberofSeats[i] == 0 ? 30 : 40,
                textStyle: whiteNumberFont.copyWith(color: darkColor),
                isSelected: numberofSeats[i] == 0 ? false : selectedSeats.contains("${String.fromCharCode(seatOrder + 65)}${index + 1}"),
                onTap: (seatNumber) {
                  if(numberofSeats[i] > 0) {
                    setState(() {
                      if (selectedSeats.contains(seatNumber)) {
                        selectedSeats.remove(seatNumber);
                      } else {
                        selectedSeats.add(seatNumber);
                      }
                    });
                  }
                },
                isEnabled: numberofSeats[i] > 0,
              ),
            )
          ),
        )
      );

      if (numberofSeats[i] > 0) {
        seatOrder++;
      }
    }

    return Column(
      children: widgets,
    );
  }
  
  Widget _buildNextButton() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 40),
      child: Align(
        alignment: Alignment.topCenter,
        child: FloatingActionButton(
          elevation: 4,
          backgroundColor: selectedSeats.length > 0 ? mainColor : Color(0xFFE4E4E4),
          child: Icon(
            Icons.arrow_forward,
            color: selectedSeats.length > 0 ? Colors.white : Color(0xFFBEBEBE),
          ),
          onPressed: selectedSeats.length > 0
            ? () {
                Ticket ticket = widget.ticket.copyWith(seats: selectedSeats);
                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(ticket)));
              }
            : null
          ),
      ),
    );
  }
}

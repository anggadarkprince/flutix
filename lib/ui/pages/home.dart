import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutix/models/user.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/movie.dart';
import 'package:flutix/ui/pages/ticket.dart';
import 'package:flutix/ui/pages/topup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final int tabIndex;

  HomeScreen({this.user, this.tabIndex = 0});

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomNavBarIndex;
  PageController pageController;
  User user;

  @override
  void initState() {
    super.initState();

    bottomNavBarIndex = widget.tabIndex;
    pageController = PageController(initialPage: bottomNavBarIndex);
    
    if (widget.user == null) {
      auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
      UserService.getUser(_auth.currentUser.uid).then((value) {
        user = value;
      });
    } else {
      user = widget.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: accentColor1),
          SafeArea(child: Container(color: Color(0xFFE8EBEC))),
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                bottomNavBarIndex = index;
              });
            },
            children: <Widget>[
              MovieScreen(user),
              Text('favorite'),
              TicketScreen(),
              Text('account'),
            ],
          ),
          createCustomBottomNavBar(),
        ],
      )
    );
  }

  Widget createCustomBottomNavBar() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              ),
              boxShadow: [
                BoxShadow(color: Color(0x11000000), spreadRadius: 0, blurRadius: 20, offset: Offset(0, -5)),
              ],
            ),
            child: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: mainColor,
              unselectedItemColor: Color(0xFFC1C1C1),
              selectedFontSize: 13,
              currentIndex: bottomNavBarIndex,
              onTap: (index) {
                setState(() {
                  bottomNavBarIndex = index;
                  pageController.jumpToPage(index);
                });
              },
              items: [
                BottomNavigationBarItem(
                  title: Text("Movies", style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600)),
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 6),
                    height: 20,
                    child: Image.asset((bottomNavBarIndex == 0)
                      ? "assets/ic_movie.png"
                      : "assets/ic_movie_grey.png"),
                  )
                ),
                BottomNavigationBarItem(
                  title: Container(
                    margin: EdgeInsets.only(right: 45),
                    child: Text("Favorites", style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600))
                  ),
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 6, right: 45),
                    height: 20,
                    child: Image.asset((bottomNavBarIndex == 1)
                      ? "assets/ic_tickets.png"
                      : "assets/ic_tickets_grey.png"
                    ),
                  )
                ),
                BottomNavigationBarItem(
                  title: Container(
                    margin: EdgeInsets.only(left: 45),
                    child: Text("Tickets", style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600))
                  ),
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 6, left: 45),
                    height: 20,
                    child: Image.asset((bottomNavBarIndex == 2)
                      ? "assets/ic_tickets.png"
                      : "assets/ic_tickets_grey.png"
                    ),
                  )
                ),
                BottomNavigationBarItem(
                  title: Text("Account", style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600)),
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 6),
                    height: 20,
                    child: Image.asset((bottomNavBarIndex == 3)
                      ? "assets/ic_drama.png"
                      : "assets/ic_tickets_grey.png"
                    ),
                  )
                ),
              ]
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 55,
            width: 55,
            margin: EdgeInsets.only(bottom: 35),
            child: FloatingActionButton(
              elevation: 10,
              backgroundColor: accentColor1,
              child: Icon(MdiIcons.walletPlus, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TopUpScreen()));
                /*
                AuthServices.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (Route<dynamic> route) => false,
                );
                */
              }),
          ),
        )
      ],
    );
  } 
}

class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width / 2 - 33, 0);
    path.quadraticBezierTo(size.width / 2 - 33, 40, size.width / 2, 40);
    path.quadraticBezierTo(size.width / 2 + 33, 40, size.width / 2 + 33, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
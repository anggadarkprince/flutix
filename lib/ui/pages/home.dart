import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutix/models/user.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/favorite.dart';
import 'package:flutix/ui/pages/movie.dart';
import 'package:flutix/ui/pages/ticket.dart';
import 'package:flutix/ui/pages/wallet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              FavoriteScreen(),
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
                    margin: EdgeInsets.only(right: 40),
                    child: Text("Likes", style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600))
                  ),
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 6, right: 40),
                    height: 20,
                    child: Image.asset((bottomNavBarIndex == 1)
                      ? "assets/ic_rate.png"
                      : "assets/ic_rate_grey.png"
                    ),
                  )
                ),
                BottomNavigationBarItem(
                  title: Container(
                    margin: EdgeInsets.only(left: 40),
                    child: Text("Tickets", style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600))
                  ),
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 6, left: 40),
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
                      ? "assets/ic_profile.png"
                      : "assets/ic_profile_grey.png"
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
            height: 60,
            width: 60,
            margin: EdgeInsets.only(bottom: 25),
            child: FloatingActionButton(
              elevation: 10,
              backgroundColor: mainColor,
              child: Image.asset("assets/ic_wallet_grey.png", width: 28),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen()));
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

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutix/models/models.dart';
import 'package:flutix/services/services.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/movie.dart';
import 'package:flutix/ui/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomNavBarIndex;
  PageController pageController;
  User user = new User('', '');

  @override
  void initState() {
    super.initState();

    bottomNavBarIndex = 0;
    pageController = PageController(initialPage: bottomNavBarIndex);
    auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
    UserServices.getUser(_auth.currentUser.uid).then((value) {
      user = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: accentColor1,
          ),
          SafeArea(
            child: Container(
              color: Color(0xFFF6F7F9),
            )
          ),
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                bottomNavBarIndex = index;
              });
            },
            children: <Widget>[
              MoviePage(user),
              Center(child: Text("My Tickets"),)
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
          child: ClipPath(
            clipper: BottomNavBarClipper(),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
                )
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                selectedItemColor: mainColor,
                unselectedItemColor: Color(0xFFD1D1E1),
                currentIndex: bottomNavBarIndex,
                onTap: (index) {
                  setState(() {
                    bottomNavBarIndex = index;
                    pageController.jumpToPage(index);
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    title: Text("New Movies", style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600)),
                    icon: Container(
                      margin: EdgeInsets.only(bottom: 6),
                      height: 20,
                      child: Image.asset((bottomNavBarIndex == 0)
                        ? "assets/ic_movie.png"
                        : "assets/ic_movie_grey.png"),
                    )
                  ),
                  BottomNavigationBarItem(
                    title: Text("My Tickets", style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600)),
                    icon: Container(
                      margin: EdgeInsets.only(bottom: 6),
                      height: 20,
                      child: Image.asset((bottomNavBarIndex == 1)
                        ? "assets/ic_tickets.png"
                        : "assets/ic_tickets_grey.png"),
                    )
                  )
                ]
              ),
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
              elevation: 0,
              backgroundColor: mainColor,
              child: Icon(MdiIcons.walletPlus, color: Colors.white, size: 28),
              onPressed: () {
                AuthServices.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
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
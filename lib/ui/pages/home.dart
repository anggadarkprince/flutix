import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/provider_user.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/account.dart';
import 'package:flutix/ui/pages/favorite.dart';
import 'package:flutix/ui/pages/movie.dart';
import 'package:flutix/ui/pages/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final firebaseMessaging = FirebaseMessaging();
  bool isSubscribed = false;
  String token = '';

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) {
    debugPrint('onBackgroundMessage: $message');
    if (message.containsKey('data')) {
      if (Platform.isIOS) {
      } else if (Platform.isAndroid) {
        message = message['data'];
      }
    }
    return null;
  }

  @override
  void initState() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint('onMessage: $message');
        getDataFcm(message);
      },
      onBackgroundMessage: onBackgroundMessage,
      onResume: (Map<String, dynamic> message) async {
        debugPrint('onResume: $message');
        getDataFcm(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('onLaunch: $message');
        getDataFcm(message);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true),
    );
    firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      debugPrint('Settings registered: $settings');
    });
    firebaseMessaging.getToken().then((token) => setState(() {
      this.token = token;
    }));
    super.initState();

    bottomNavBarIndex = widget.tabIndex;
    pageController = PageController(initialPage: bottomNavBarIndex);
    
    if (widget.user == null) {
      auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
      UserService.getUser(_auth.currentUser.uid).then((value) {
        //Provider.of<ProviderUser>(context, listen: false).setUser(user);
        if (this.mounted) {
          setState(() {
            user = value;
          });
        } else {
          user = value;
        }
      });
    } else {
      user = widget.user;
    }

    var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    switch (payload) {
      case 'wallet':
        Navigator.pushNamed(context, '/wallet');
      break;
      case 'ticket':
        if (pageController == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(tabIndex: 3)),
            (Route<dynamic> route) => false,
          );
        } else {
          pageController.jumpToPage(3);
        }
      break;
    }
    
    return null;
  }

  void getDataFcm(Map<String, dynamic> message) {
    if (Platform.isIOS) {
    } else if (Platform.isAndroid) {
      message = message['data'];
    }
    debugPrint('getDataFcm: name: $message');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('token: $token');
    
    user = Provider.of<ProviderUser>(context).user ?? user;
    
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
              Container(),
              TicketScreen(),
              AccountScreen(user),
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
                  title: Text(MyLocalization.of(context).menuMovies, style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600)),
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
                    child: Text(MyLocalization.of(context).menuLikes, style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600))
                  ),
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 6),
                    height: 20,
                    child: Image.asset((bottomNavBarIndex == 1)
                      ? "assets/ic_rate.png"
                      : "assets/ic_rate_grey.png"
                    ),
                  )
                ),
                BottomNavigationBarItem(
                  title: Text(''),
                  icon: Container(),
                ),
                BottomNavigationBarItem(
                  title: Container(
                    child: Text(MyLocalization.of(context).menuTickets, style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600))
                  ),
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 6),
                    height: 20,
                    child: Image.asset((bottomNavBarIndex == 3)
                      ? "assets/ic_tickets.png"
                      : "assets/ic_tickets_grey.png"
                    ),
                  )
                ),
                BottomNavigationBarItem(
                  title: Text(MyLocalization.of(context).menuAccount, style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600)),
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 6),
                    height: 20,
                    child: Image.asset((bottomNavBarIndex == 4)
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
                Navigator.pushNamed(context, '/wallet');
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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutix/services/auth_services.dart';
import 'package:flutix/ui/pages/home.dart';
import 'package:flutter/material.dart';
import 'ui/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppWrapperState();
  }
}

class _AppWrapperState extends State<MyApp> {
  bool initApp = false;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    AuthServices.isUserLoggedIn()
      .then((result) {
        new Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            initApp = true;
          });     
          if(result != isLoggedIn) {
            setState(() {
              isLoggedIn = result;
            });
          }
        });
      });

    return initApp 
      ? (isLoggedIn ? HomeScreen() : SplashScreen())
      : _buildStartUpView(); 
  }

  Widget _buildStartUpView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/logo.png"))
          ),
        ),
      )
    );
  }
  
}

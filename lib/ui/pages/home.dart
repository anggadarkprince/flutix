
import 'package:flutix/services/services.dart';
import 'package:flutix/ui/pages/splash.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Sign Out"),
          onPressed: () async {
            await AuthServices.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
          }),
      ),
    );
  }
  
}
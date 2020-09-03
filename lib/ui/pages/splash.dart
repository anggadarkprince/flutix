import 'package:flutix/ui/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutix/shared/theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.all(defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 140,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/logo.png"))
                ),
              ),
              SizedBox(height: 50),
              Text(
                'New Experience',
                textAlign: TextAlign.center,
                style: blackTextFont.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                )
              ),
              SizedBox(height: 10),
              Text(
                'Watch a new movie much\neasier than any before',
                textAlign: TextAlign.center,
                style: greyTextFont.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 100),
              Container(
                width: 250,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Get Started",
                    style: whiteTextFont.copyWith(fontSize: 16),
                  ),
                  color: mainColor,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                )
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have an account? ",
                    style: greyTextFont.copyWith(fontWeight: FontWeight.w400)
                  ),
                  GestureDetector(
                    child: Text("Sign In", style: purpleTextFont),
                    onTap: () {

                    },
                  )
                ]
              )
            ]
          )
        ),
    );
  }
}
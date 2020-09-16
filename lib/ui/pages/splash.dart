import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/registration.dart';
import 'package:flutix/ui/pages/login.dart';
import 'package:flutix/ui/pages/register.dart';
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
                MyLocalization.of(context).newExperience,
                textAlign: TextAlign.center,
                style: blackTextFont.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                )
              ),
              SizedBox(height: 10),
              Text(
                MyLocalization.of(context).watchNewMovie,
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
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    MyLocalization.of(context).getStarted,
                    style: whiteTextFont.copyWith(fontSize: 16),
                  ),
                  color: mainColor,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(Registration())));
                  }
                )
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    MyLocalization.of(context).alreadyHaveAnAccount,
                    style: greyTextFont.copyWith(fontWeight: FontWeight.w400)
                  ),
                  GestureDetector(
                    child: Text(MyLocalization.of(context).signIn, style: purpleTextFont.copyWith(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
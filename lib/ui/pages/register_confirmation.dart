import 'package:flushbar/flushbar.dart';
import 'package:flutix/models/registration.dart';
import 'package:flutix/services/services.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterConfirmationScreen extends StatefulWidget {
  
  final Registration registrationData;

  RegisterConfirmationScreen(this.registrationData);

  @override
  _RegisterConfirmationState createState() {
    return _RegisterConfirmationState();
  }
}

class _RegisterConfirmationState extends State<RegisterConfirmationScreen> {
  bool isSigningUp = false;

  @override
  Widget build(BuildContext context) {  
    var mediaQuery = MediaQuery.of(context);
    
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(defaultMargin),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitle(mediaQuery),
              _buildProfileSummary(mediaQuery),
              _buildSubmitButton(),
            ],
          ),
        ]
      )
    );
  }

  Widget _buildTitle(MediaQueryData mediaQuery) {
    final double statusBarHeight = mediaQuery.padding.top;

    return Column(
      children: [
        SizedBox(height: statusBarHeight),
        Container(
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
                      "Summary",
                      style: darkTextFont.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildProfileSummary(MediaQueryData mediaQuery) {
    final profile = widget.registrationData;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Text(
          "One step closer\nto explore thousands of movies",
          style: greyTextFont.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Container(
          width: 150,
          height: 150,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: (profile.profileImage == null)
                  ? AssetImage("assets/user_pic.png")
                  : FileImage(profile.profileImage),
                fit: BoxFit.cover
              )
          ),
        ),
        Text(
          profile.name,
          style: purpleTextFont.copyWith(
            fontSize: 22, fontWeight: FontWeight.w600
          )
        ),
        SizedBox(height: 10),
        Text(
          profile.email,
          style: darkTextFont.copyWith(
            fontSize: 20, fontWeight: FontWeight.w400
          )
        ),
        SizedBox(height: 10),
        Text(
          profile.selectedGenres.join(", "),
          style: greyTextFont.copyWith(
            fontSize: 16, fontWeight: FontWeight.w400
          )
        ),
        SizedBox(height: 50),
      ]
    );
  }

  Widget _buildSubmitButton() {
    return (isSigningUp)
      ? SpinKitFadingCircle(
          color: mainColor,
          size: 45,
        )
      : Container(
          width: 250,
          height: 50,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Confirm Registration",
              style: whiteTextFont.copyWith(fontSize: 16),
            ),
            color: mainColor,
            onPressed: () async {
              setState(() {
                isSigningUp = true;
              });
              
              SignInSignUpResult result = await AuthServices.signUp(
                widget.registrationData.email,
                widget.registrationData.password,
                widget.registrationData.name,
                widget.registrationData.selectedGenres,
                widget.registrationData.selectedLang
              );
              
              if (result.user == null) {
                setState(() {
                  isSigningUp = false;
                });

                Flushbar(
                  duration: Duration(milliseconds: 1500),
                  flushbarPosition: FlushbarPosition.TOP,
                  backgroundColor: Color(0xFFFF5C83),
                  message: result.message,
                )..show(context);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              }
            }
          )
        );
  }
}
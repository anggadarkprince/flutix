import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/registration.dart';
import 'package:flutix/provider_user.dart';
import 'package:flutix/shared/helpers.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutix/services/auth_services.dart';
import 'package:provider/provider.dart';

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
      body: Container(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTitle(),
            _buildProfileSummary(mediaQuery),
            Spacer(),
            _buildSubmitButton(),
          ],
        )
      )
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        SizedBox(height: 25),
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
                  child: Icon(Icons.arrow_back, color: darkColor),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      MyLocalization.of(context).summary,
                      style: darkTextFont.copyWith(
                        fontSize: 22,
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
        SizedBox(height: 30),
        Text(
          MyLocalization.of(context).oneStepCloserRegistration,
          style: greyTextFont.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
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
    return Container(
      width: 250,
      height: 50,
      margin: EdgeInsets.only(bottom: 10),
      child: (isSigningUp)
        ? SpinKitFadingCircle(
            color: mainColor,
            size: 45,
          )
        : RaisedButton(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              MyLocalization.of(context).confirmRegistration,
              style: whiteTextFont.copyWith(fontSize: 16),
            ),
            color: mainColor,
            onPressed: () async {
              setState(() {
                isSigningUp = true;
              });
              
              File profileImage = widget.registrationData.profileImage;
              String profileUrl = "";
              if (profileImage != null) {
                profileUrl = await uploadImage(profileImage);        
              }

              SignInSignUpResult result = await AuthServices.signUp(
                widget.registrationData.email,
                widget.registrationData.password,
                widget.registrationData.name,
                widget.registrationData.selectedGenres,
                widget.registrationData.selectedLang,
                profilePhoto: profileUrl
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
                Provider.of<ProviderUser>(context, listen: false).setUser(result.user);
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: result.user)));
              }
            }
        )
    );
  }
}
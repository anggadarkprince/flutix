import 'package:email_validator/email_validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutix/locale/my_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutix/services/auth_services.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() {
    return _ResetPasswordScreenState();
  }
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  bool isEmailValid = false;
  bool isResseting = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(defaultMargin), 
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildTitle(mediaQuery),
              _buildEmail(),
              _buildResetButton(),
            ],
          ),
        ]
      )
    );
  }

  Widget _buildTitle(MediaQueryData mediaQuery) {
    final double statusBarHeight = mediaQuery.padding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: statusBarHeight),
        SizedBox(
          height: 70,
          child: Image.asset("assets/help_centre.png"),
        ),
        SizedBox(height: 20),
        Text(
          MyLocalization.of(context).resetYourPassword,
          style: darkTextFont.copyWith(
            fontSize: 26, fontWeight: FontWeight.w600
          )
        ),
        SizedBox(height: 10),
        Text(
          MyLocalization.of(context).weWillSendYouRecoveryEmail,
          style: greyTextFont.copyWith(
            fontSize: 16, fontWeight: FontWeight.w400
          )
        ),
        SizedBox(height: 50),
      ],
    );
  }

  Widget _buildEmail() {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (text) {
            setState(() {
              isEmailValid = EmailValidator.validate(text.trim());
            });
          },
          controller: emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: MyLocalization.of(context).emailAddress,
            hintText: MyLocalization.of(context).registeredEmail
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: <Widget>[
            Text(
              MyLocalization.of(context).rememberPassword,
              style: greyTextFont.copyWith(
                fontSize: 12, fontWeight: FontWeight.w400
              ),
            ),
            GestureDetector(
              child: Text(
                MyLocalization.of(context).signIn,
                style: purpleTextFont.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w600
                ),
              ),
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(top: 40, bottom: 45),
        child: isResseting
          ? SpinKitFadingCircle(color: mainColor)
          : FloatingActionButton(
              elevation: 4,
              backgroundColor: isEmailValid
                ? Colors.red[800]
                : Color(0xFFE4E4E4
              ),
              child: Icon(
                Icons.arrow_forward,
                color: isEmailValid
                  ? Colors.white
                  : Color(0xFFBEBEBE)
              ),
              onPressed: isEmailValid ? onReset : null
            ),
      ),
    );
  }

  onReset() async {
    setState(() {
      isResseting = true;
    });

    await AuthServices.resetPassword(emailController.text);

    Flushbar(
      duration: Duration(milliseconds: 2000),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Color(0xFFFF5C83),
      message: MyLocalization.of(context).resetLinkMessage,
    )..show(context);

    setState(() {
      isResseting = false;
      emailController.text = "";
    });
  }

}

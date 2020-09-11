import 'package:email_validator/email_validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutix/models/registration.dart';
import 'package:flutix/ui/pages/home.dart';
import 'package:flutix/ui/pages/register.dart';
import 'package:flutix/ui/pages/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutix/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(defaultMargin), 
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitle(mediaQuery),
              _buildEmailPassword(),
              _buildSignInButton(),
              _buildSignUpButton(),
            ],
          ),
        ]
      )
    );
  }

  Widget _buildTitle(MediaQueryData mediaQuery) {
    final double statusBarHeight = mediaQuery.padding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: statusBarHeight),
        SizedBox(
          height: 70,
          child: Image.asset("assets/logo.png"),
        ),
        SizedBox(height: 50),
        Text("Welcome Back,\nExplorer!",
          style: blackTextFont.copyWith(
            fontSize: 26, fontWeight: FontWeight.w600
          )
        ),
        SizedBox(height: 50),
      ],
    );
  }

  Widget _buildEmailPassword() {
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
            labelText: "Email Address",
            hintText: "Email Address"
          ),
        ),
        SizedBox(height: 15),
        TextField(
          onChanged: (text) {
            setState(() {
              isPasswordValid = text.length >= 6;
            });
          },
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: "Password",
            hintText: "Password"
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: <Widget>[
            Text(
              "Forgot Password? ",
              style: greyTextFont.copyWith(
                fontSize: 12, fontWeight: FontWeight.w400
              ),
            ),
            GestureDetector(
              child: Text(
                "Reset Here",
                style: purpleTextFont.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w600
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen()
                  )
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(top: 40, bottom: 45),
        child: isSigningIn
          ? SpinKitFadingCircle(color: mainColor)
          : FloatingActionButton(
              elevation: 4,
              backgroundColor: isEmailValid && isPasswordValid
                ? mainColor
                : Color(0xFFE4E4E4
              ),
              child: Icon(
                Icons.arrow_forward,
                color: isEmailValid && isPasswordValid
                  ? Colors.white
                  : Color(0xFFBEBEBE)
              ),
              onPressed: isEmailValid && isPasswordValid ? onSignIn : null
            ),
      ),
    );
  }

  onSignIn() async {
    setState(() {
      isSigningIn = true;
    });

    SignInSignUpResult result = await AuthServices.signIn(
      emailController.text.trim(), passwordController.text
    );

    setState(() {
      isSigningIn = false;
    });

    if (result.user == null) {
      Flushbar(
        duration: Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Color(0xFFFF5C83),
        message: result.message,
      )..show(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: result.user)
        )
      );
    }
  }

  Widget _buildSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Start fresh now? ",
          style: greyTextFont.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14
          )
        ),
        GestureDetector(
          child: Text('Sign Up',
            style: purpleTextFont.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14
            )
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(Registration())
              )
            );
          },
        )
      ],
    );
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutix/models/registration.dart';
import 'package:flutix/ui/pages/login.dart';
import 'package:flutix/ui/pages/preference.dart';
import 'package:flutter/material.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  
  bool isNameValid = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  Registration registrationData = new Registration();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(defaultMargin),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTitle(mediaQuery),
              _buildRegistrationForm(),
              _buildSignUpButton(),
              _buildSignInButton(),  
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
                      "Sign Up",
                      style: blackTextFont.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Explore thousands movies",
                      style: greyTextFont.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: 100,
          height: 128,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Image.asset("assets/user_pic.png"),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    print('change photo');
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/btn_add_photo.png")
                      ),
                    ),
                  ),
                )
              )
            ]
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
  
  Widget _buildRegistrationForm() {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (text) {
            setState(() {
              isNameValid = text.trim().length > 2;
            });
          },
          controller: nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: "Full Name",
            hintText: "Your Name"
          ),
        ),
        SizedBox(height: 15),
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
            hintText: "Valid Email Address"
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
            hintText: "Secret Password"
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: "Confirm Password",
            hintText: "Repeat The Password"
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    bool isFormValid = isNameValid && isEmailValid && isPasswordValid;
    return Center(
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(top: 40, bottom: 45),
        child: FloatingActionButton(
          elevation: 4,
          backgroundColor: isFormValid ? mainColor : Color(0xFFE4E4E4),
          child: Icon(
            Icons.arrow_forward, 
            color: isFormValid ? Colors.white : Color(0xFFBEBEBE)
          ),
          onPressed: isFormValid ? onSubmit : null
        ),
      ),
    );
  }

  onSubmit() {
    registrationData.name = nameController.text.trim();
    registrationData.email = emailController.text.trim();
    registrationData.password = passwordController.text;

    if (passwordController.text == confirmPasswordController.text) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PreferenceScreen(registrationData)));
    } else {
      Flushbar(
        duration: Duration(milliseconds: 1500),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Color(0xFFFF5C83),
        message: "Confirm password mismatch",
      )..show(context);
    }
  }

  Widget _buildSignInButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Already have an account? ", 
          style: greyTextFont.copyWith(fontWeight: FontWeight.w400)
        ),
        GestureDetector(
          child: Text('Sign In', style: purpleTextFont),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        )
      ],
    );
  }
}
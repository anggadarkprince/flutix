import 'package:email_validator/email_validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutix/models/registration.dart';
import 'package:flutix/shared/helpers.dart';
import 'package:flutix/ui/pages/login.dart';
import 'package:flutix/ui/pages/preference.dart';
import 'package:flutter/material.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  final Registration registrationData;

  RegisterScreen(this.registrationData);

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

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(defaultMargin),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTitle(),
              _buildRegistrationForm(),
              _buildSignInButton(),
              _buildSignUpButton(),
            ],
          ),
        ]
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
                      "Sign Up",
                      style: darkTextFont.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    SizedBox(height: 25),
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
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: (widget.registrationData.profileImage == null)
                      ? AssetImage("assets/user_pic.png")
                      : FileImage(widget.registrationData.profileImage),
                    fit: BoxFit.cover
                  )
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    if (widget.registrationData.profileImage == null) {
                      widget.registrationData.profileImage = await getImage();
                    } else {
                      widget.registrationData.profileImage = null;
                    }
                    setState(() {}); // force trigger update
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          widget.registrationData.profileImage == null 
                            ? "assets/btn_add_photo.png" 
                            : "assets/btn_del_photo.png"
                        )
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
            hintText: "Your Name",
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 5)
          ),
        ),        
        SizedBox(height: 20),
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
            hintText: "Valid Email Address",
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 5)
          ),
        ),
        SizedBox(height: 20),
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
            hintText: "Secret Password",
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 5)
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: "Confirm Password",
            hintText: "Repeat The Password",
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 5)
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSignUpButton() {
    bool isFormValid = isNameValid && isEmailValid && isPasswordValid;
    return Center(
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(top: 40, bottom: 15),
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
    widget.registrationData.name = nameController.text.trim();
    widget.registrationData.email = emailController.text.trim();
    widget.registrationData.password = passwordController.text;

    if (passwordController.text == confirmPasswordController.text) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PreferenceScreen(widget.registrationData)));
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
          style: greyTextFont.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14
          )
        ),
        GestureDetector(
          child: Text(
            'Sign In', 
            style: purpleTextFont.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14
            )
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        )
      ],
    );
  }
}
import 'package:flutix/services/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text("Sign Up"),
                onPressed: () async {
                  SignInSignUpResult result = await AuthServices.signUp(
                      "jennie@blackpink.com",
                      "123456",
                      "Jennie",
                      ["Action", "Horror", "Music", "Drama"],
                      "Korean");

                  if (result.user == null) {
                    print(result.message);
                  } else {
                    print(result.user.toString());
                  }
                }),
            RaisedButton(
                child: Text("Sign In"),
                onPressed: () async {
                  SignInSignUpResult result = await AuthServices.signIn(
                    "jennie@blackpink.com",
                    "123456",
                  );

                  if (result.user == null) {
                    print(result.message);
                  } else {
                    print(result.user.toString());
                  }
                })
          ],
        ),
      )),
    );
  }
}

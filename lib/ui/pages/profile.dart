import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/services/auth_services.dart';
import 'package:flutix/services/user_service.dart';
import 'package:flutix/shared/helpers.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen(this.user);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController;
  String profilePath;
  bool isDataEdited = false;
  File profileImageFile;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    profilePath = widget.user.profilePicture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text('Edit Profile'),
        backgroundColor: mainColor,
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
          },
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 22, bottom: 10),
              width: 90,
              height: 104,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: (profileImageFile != null)
                          ? FileImage(profileImageFile)
                          : (profilePath != "") ? NetworkImage(profilePath) : AssetImage("assets/user_pic.png"),
                        fit: BoxFit.cover
                      )
                    )
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () async {
                        if (profilePath == "") {
                          profileImageFile = await getImage();
                          if (profileImageFile != null) {
                            List<String> splitPath = profileImageFile.path.split('/');
                            profilePath = splitPath[splitPath.length - 1];
                          }
                        } else {
                          profileImageFile = null;
                          profilePath = "";
                        }

                        setState(() {
                          isDataEdited = (nameController.text.trim() != widget.user.name || profilePath != widget.user.profilePicture) ? true : false;
                        });
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage((profilePath == "") ? "assets/btn_add_photo.png" : "assets/btn_del_photo.png")
                          )
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            AbsorbPointer(
              child: TextField(
                controller: TextEditingController(text: widget.user.id),
                style: whiteNumberFont.copyWith(color: accentColor3),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "User ID",
                ),
              ),
            ),
            SizedBox(height: 15),
            AbsorbPointer(
              child: TextField(
                controller: TextEditingController(text: widget.user.email),
                style: greyTextFont,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "Email Address",
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: nameController,
              onChanged: (text) {
                setState(() {
                  isDataEdited = (text.trim() != widget.user.name || profilePath != widget.user.profilePicture) ? true : false;
                });
              },
              style: blackTextFont,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: "Full Name",
                hintText: "Full Name"
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 250,
              height: 50,
              child: RaisedButton(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "Change Password",
                  style: whiteTextFont.copyWith(
                    fontSize: 16,
                    color: (isUpdating) ? Color(0xFFBEBEBE) : Colors.white
                  ),
                ),
                disabledColor: Color(0xFFE4E4E4),
                color: Colors.red[400],
                onPressed: (isUpdating)
                  ? null
                  : () async {
                      await AuthServices.resetPassword(widget.user.email);

                      Flushbar(
                        duration: Duration(milliseconds: 2000),
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        backgroundColor: Color(0xFFFF5C83),
                        message: "The link to change your password has been sent to your email.",
                      )..show(context);
                    }
              ),
            ),
            SizedBox(height: 15),
            (isUpdating)
              ? SizedBox(
                  width: 50,
                  height: 50,
                  child: SpinKitFadingCircle(
                    color: Color(0xFF3E9D9D),
                  ),
                )
              : SizedBox(
                  width: 250,
                  height: 50,
                  child: RaisedButton(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      "Update My Profile",
                      style: whiteTextFont.copyWith(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                    disabledColor: Color(0xFFE4E4E4),
                    color: mainColor,
                    onPressed: (isDataEdited)
                      ? () async {
                          setState(() {
                            isUpdating = true;
                          });

                          if (profileImageFile != null) {
                            profilePath = await uploadImage(profileImageFile);
                          }

                          User updatedUser = widget.user.copyWith(name: nameController.text.trim(), profilePicture: profilePath);
                          await UserService.updateUser(updatedUser);

                          Flushbar(
                            duration: Duration(milliseconds: 2000),
                            flushbarPosition: FlushbarPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            message: "Profile succesfully updated",
                          )..show(context);

                          setState(() {
                            isUpdating = false;
                          });
                        }
                      : null
                  ),
                ),
            SizedBox(height: 30),
          ],
        ),
      )
    );
  }

}

import 'package:flutix/models/user.dart';
import 'package:flutix/services/auth_services.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/profile.dart';
import 'package:flutix/ui/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AccountScreen extends StatefulWidget {
  final User user;

  AccountScreen(this.user);
  
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<Map> menu = [
    {
      "type": "title",
      "title": "Account",
    },
    {
      "type": "menu",
      "title": "Edit Account",
      "icon": Image.asset("assets/user_pic.png"),
      "onTap": (BuildContext context, User user) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user)));
      }
    },
    {
      "type": "menu",
      "title": "Transaction Histories",
      "icon": Image.asset("assets/my_wallet.png"),
      "onTap": (BuildContext context, User user) {}
    },
    {
      "type": "menu",
      "title": "Promo Code",
      "icon": Image.asset("assets/bg_topup.png"),
      "onTap": (BuildContext context, User user) {}
    },
    {
      "type": "menu",
      "title": "My Voucher",
      "icon": Image.asset("assets/ic_tickets.png"),
      "onTap": (BuildContext context, User user) {}
    },
    {
      "type": "menu",
      "title": "Change Language",
      "icon": Image.asset("assets/language.png"),
      "onTap": (BuildContext context, User user) {}
    },
    {
      "type": "title",
      "title": "General",
    },
    {
      "type": "menu",
      "title": "Privacy Policy",
      "icon": Image.asset("assets/help_centre.png"),
      "onTap": (BuildContext context, User user) {}
    },
    {
      "type": "menu",
      "title": "Terms of Service",
      "icon": Image.asset("assets/ic_movie.png"),
      "onTap": (BuildContext context, User user) {}
    },
    {
      "type": "menu",
      "title": "Rate App",
      "icon": Image.asset("assets/rate.png"),
      "onTap": (BuildContext context, User user) {}
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildListMenu(context),
    );
  }

  Widget _buildProfile(context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(widget.user)));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 10),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                SpinKitFadingCircle(
                  color: accentColor2,
                  size: 60,
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: (widget.user == null || widget.user.profilePicture == "" || widget.user.profilePicture == null) 
                        ? AssetImage("assets/user_pic.png") 
                        : NetworkImage(widget.user.profilePicture),
                      fit: BoxFit.cover
                    )
                  ),
                )
              ],
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  child: Text(
                    (widget.user != null ? widget.user.name : 'User'),
                    style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 5),
                Text(widget.user.email, style: greyTextFont.copyWith(fontSize: 14))
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward, color: Colors.grey[500], size: 25)
          ],
        ),
      )
    );
  }

  Widget _buildListMenu(context) {
    return Container(
      child: ListView.separated(
        itemCount: menu.length + 2,
        separatorBuilder: (context, index) => 
          index > 0 && menu[index - 1]["type"] == 'menu'
          ? Divider(
              height: 0,
              color: Colors.grey[300],
            ) 
          : Container(),
        itemBuilder: (_, index) {
          if (index == 0) {
              return _buildProfile(context);
          }
          if (index == menu.length + 1) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              margin: EdgeInsets.only(bottom: 100),
              child: SizedBox(
                height: 50,
                child: RaisedButton(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    "Sign Out",
                    style: whiteTextFont.copyWith(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                  disabledColor: Color(0xFFE4E4E4),
                  color: Colors.red[500],
                  onPressed: () async {
                    AuthServices.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                      (Route<dynamic> route) => false,
                    );
                  }
                )
              )
            );
          }
          index -= 1;

          return Container(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                menu[index]["type"] == 'menu' && menu[index].containsKey('icon') 
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 13),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 16),
                          width: 25,
                          child: menu[index]["icon"],
                        ),
                        Text(
                          menu[index]["title"], 
                          style: darkTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w600)
                        ),
                      ],
                    )
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 5),
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(menu[index]["title"], style: greyTextFont)
                    ),
                  ),
                menu[index].containsKey('onTap') 
                  ? Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          print(menu[index]['onTap'].runtimeType);
                          menu[index]['onTap'](context, widget.user);
                        },
                      )
                    )
                  )
                : Container(),
              ]
            )
          );
        }
      )
    );
  }
}

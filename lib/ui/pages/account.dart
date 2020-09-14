import 'package:flutix/models/user.dart';
import 'package:flutix/services/auth_services.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/legal.dart';
import 'package:flutix/ui/pages/profile.dart';
import 'package:flutix/ui/pages/promo_code.dart';
import 'package:flutix/ui/pages/splash.dart';
import 'package:flutix/ui/pages/voucher.dart';
import 'package:flutix/ui/pages/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  final User user;

  AccountScreen(this.user);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User user;
  List<Map> menu;

  @override
  void initState() {
    user = widget.user;
    menu = [
      {
        "type": "title",
        "title": "Account",
      },
      {
        "type": "menu",
        "title": "Edit Account",
        "icon": Image.asset("assets/user_pic.png"),
        "onTap": (BuildContext context, User currentUser) async {
          final updatedUser = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(currentUser)));
          if (updatedUser != null) {
            setState(() {
              user = updatedUser;
              print(updatedUser);
              print(user.name);
            });
          }
        }
      },
      {
        "type": "menu",
        "title": "Transaction Histories",
        "icon": Image.asset("assets/my_wallet.png"),
        "onTap": (BuildContext context, User user) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen()));
        }
      },
      {
        "type": "menu",
        "title": "Enter Promo Code",
        "icon": Image.asset("assets/bg_topup.png"),
        "onTap": (BuildContext context, User user) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PromoCodeScreen(user)));
        }
      },
      {
        "type": "menu",
        "title": "My Voucher",
        "icon": Image.asset("assets/ic_tickets.png"),
        "onTap": (BuildContext context, User user) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherScreen(user)));
        }
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
        "onTap": (BuildContext context, User user) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LegalScreen("Privacy", "assets/static/privacy.html")));
        }
      },
      {
        "type": "menu",
        "title": "Terms of Service",
        "icon": Image.asset("assets/ic_movie.png"),
        "onTap": (BuildContext context, User user) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LegalScreen("Terms of Service", "assets/static/term.html")));
        }
      },
      {
        "type": "menu",
        "title": "Rate App",
        "icon": Image.asset("assets/rate.png"),
        "onTap": (BuildContext context, User user) async {
          const url = 'https://angga-ari.com';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not launch $url'),
                duration: Duration(milliseconds: 1000)
              )
            );
          }
        }
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildListMenu(context),
    );
  }

  Widget _buildProfile(context) {
    return InkWell(
      onTap: () async {
        final updatedUser = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user)));
        if (updatedUser != null) {
          setState(() {
            user = updatedUser;
          });
        }
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
                      image: (user == null || user.profilePicture == "" || user.profilePicture == null)
                        ? AssetImage("assets/user_pic.png")
                        : NetworkImage(user.profilePicture),
                      fit: BoxFit.cover
                    )
                  )
                )
              ],
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  child: Text(
                    (user != null ? user.name : 'User'),
                    style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 5),
                Text(user.email, style: greyTextFont.copyWith(fontSize: 14))
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward, color: Colors.grey[500], size: 25)
          ],
        ),
      )
    );
  }

  Widget _buildSignOut(context) {
    AlertDialog confirmSignOut = AlertDialog(
      title: Text("Sign Out"),
      content: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        height: 35,
        child: Stack(
          children: [
            Text("Are you sure want to sign out?"),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Your personal preferences will be kept.",
                style: greyTextFont.copyWith(fontSize: 12)
              ),
            )
          ]
        )
      ),
      actions: [
        FlatButton(
          child: Text("SIGN OUT", style: TextStyle(color: Colors.red[500])),
          onPressed: () {
            AuthServices.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        FlatButton(
          child: Text("CANCEL"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      margin: EdgeInsets.only(bottom: 100),
      child: SizedBox(
        height: 40,
        child: OutlineButton(
          borderSide: BorderSide(color: Colors.red[500], width: 1, style: BorderStyle.solid),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Text(
            "Sign Out",
            style: whiteTextFont.copyWith(fontSize: 16, color: Colors.red[500]),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return confirmSignOut;
              },
            );
          }
        )
      )
    );
  }

  Widget _buildListMenu(context) {
    return Container(
      child: ListView.separated(
        itemCount: menu.length + 2,
        separatorBuilder: (context, index) =>
          index > 0 && menu[index - 1]["type"] == 'menu'
            ? Divider(height: 0, color: Colors.grey[300])
            : Container(),
        itemBuilder: (_, index) {
          if (index == 0) {
            return _buildProfile(context);
          }
          if (index == menu.length + 1) {
            return _buildSignOut(context);
          }
          index -= 1;

          return Container(
              child: Stack(alignment: Alignment.centerLeft, children: <Widget>[
              menu[index]["type"] == 'menu' && menu[index].containsKey('icon')
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 13),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 16),
                          width: 25,
                          height: 25,
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
                            menu[index]['onTap'](context, user);
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

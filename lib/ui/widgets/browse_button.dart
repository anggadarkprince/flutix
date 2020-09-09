import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';

class BrowseButton extends StatelessWidget {
  final String genre;
  final Function onTap;

  BrowseButton(this.genre, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 4),
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: Color(0xFFEEF1F8), borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: SizedBox(
                  height: 36,
                  child: Image(image: AssetImage(getImageFromGenre(genre)))
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(genre, style: darkTextFont.copyWith(fontSize: 13, fontWeight: FontWeight.w500))
          ],
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(genre),
            )
          )
        )
      ]
    );
  }

  String getImageFromGenre(String genre) {
    switch (genre) {
      case "Horror":
        return "assets/ic_horror.png";
        break;
      case "Music":
        return "assets/ic_music.png";
        break;
      case "Action":
        return "assets/ic_action.png";
        break;
      case "Drama":
        return "assets/ic_drama.png";
        break;
      case "War":
        return "assets/ic_war.png";
        break;
      case "Crime":
        return "assets/ic_crime.png";
        break;
      default:
        return "";
    }
  }
}

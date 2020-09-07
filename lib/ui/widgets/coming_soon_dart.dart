import 'package:flutix/models/movie.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutter/material.dart';

class ComingSoonCard extends StatelessWidget {
  final Movie movie;
  final Function onTap;

  ComingSoonCard(this.movie, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 160,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(imageBaseURL + "w500" + movie.posterPath),
              fit: BoxFit.cover
            )
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
            )
          )
        )
      ]
    );
  }
}

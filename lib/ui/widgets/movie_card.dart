import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutix/models/movie.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function onTap;
  final List<Color> overlay;
  final defaultOverlay = [
    Colors.black.withOpacity(0.8),
    Colors.black.withOpacity(0.65),
    Colors.black.withOpacity(0)
  ];

  MovieCard(this.movie, {this.onTap, this.overlay});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: 'poster-' + movie.id.toString(),
          child: Container(
            margin: EdgeInsets.only(top: 10),
            height: 140,
            width: 210,
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageBaseURL + "w780" + movie.backdropPath),
                fit: BoxFit.cover
              ),
              boxShadow: [
                BoxShadow(color: Color(0x44000000), spreadRadius: 0, blurRadius: 10, offset: Offset(0, 0)),
              ],
            ),
            child: Container(
              height: 140,
              width: 210,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: overlay == null ? defaultOverlay : overlay
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movie.title,
                    style: whiteTextFont.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  RatingStars(voteAverage: movie.voteAverage)
                ],
              ),
            ),
          )
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

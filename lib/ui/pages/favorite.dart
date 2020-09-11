import 'package:flutix/models/favorite.dart';
import 'package:flutix/services/favorite_service.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/movie_detail.dart';
import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FavoriteScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Favorite> favorites;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: FutureBuilder(
          future: FavoriteService.getFavorites(auth.FirebaseAuth.instance.currentUser.uid),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              favorites = snapshot.data;
              if (favorites.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 85,
                        width: 85,
                        child: Image(image: AssetImage('assets/ic_movie_grey.png'))
                      ),
                      SizedBox(height: 5),
                      Text(
                        'No favorite available', 
                        style: greyTextFont.copyWith(fontSize: 16)
                      )
                    ]
                  ),
                );
              }

              return _buildFavoriteList(favorites, context);
            } else if (snapshot.hasError) {
              return Container(
                padding: EdgeInsets.all(defaultMargin),
                child: Center(child: Text("${snapshot.error}")),
              );
            } else {
              return SpinKitPulse(
                color: mainColor,
                size: 50,
              );
            }
          }
        )
      ),
    );
  }

  Widget _buildFavoriteList(List<Favorite> favorites, context) {
    return Container(
      child:ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (_, index) => Container(
          margin: EdgeInsets.only(
            top: index == 0 ? 20 : 0,
            bottom: index == favorites.length - 1 ? 120 : 15
          ),
          child: Stack(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 70,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(imageBaseURL + 'w500' + favorites[index].movieDetail.posterPath),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 2 * defaultMargin - 70 - 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            favorites[index].movieDetail.title,
                            style: blackTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(height: 5),
                          Text(
                            favorites[index].movieDetail.genresAndLanguage,
                            style: greyTextFont.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          RatingStars(
                            voteAverage: favorites[index].movieDetail.voteAverage,
                            color: accentColor3,
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(favorites[index].movie)));
                    },
                  )
                )
              )
            ]
          ) 
        )
      )
    );
  }
}
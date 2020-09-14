import 'package:flushbar/flushbar.dart';
import 'package:flutix/models/favorite.dart';
import 'package:flutix/services/favorite_service.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/movie_detail.dart';
import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutix/ui/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Favorite> favorites;
  Set<String> favoriteIsDeleting = new Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              return Container(
                margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 20),
                child: ShimmerList(ShimmerListTemplate.Movie)
              );
            }
          }
        )
      ),
    );
  }

  Widget _buildFavoriteList(List<Favorite> favorites, context) {
    return Container(
      child: ListView.builder(
        itemCount: favorites.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) => Container(
          margin: EdgeInsets.only(
            top: index == 0 ? 20 : 0,
            bottom: index == favorites.length - 1 ? 100 : 0
          ),
          child: Dismissible(
            direction: DismissDirection.endToStart,
            key: UniqueKey(),
            background: Container(
              color: Colors.orange[200],
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "REMOVE",
                        style: whiteTextFont.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.end
                      ),
                    )
                  ), 
                ],
              ),
            ),
            onDismissed: (direction) async {
              await FavoriteService.deleteMovie(favorites[index].id);
              //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Removed from your favorite")));
              Flushbar(
                duration: Duration(milliseconds: 1000),
                flushbarPosition: FlushbarPosition.TOP,
                backgroundColor: Color(0xFFFF5C83),
                message: favorites[index].movie.title + ' removed from your favorite list',
              )..show(context);
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 8),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blueGrey[100],
                          image: DecorationImage(
                            image: NetworkImage(imageBaseURL + 'w500' + favorites[index].movieDetail.posterPath),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
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
                      ),
                      favoriteIsDeleting.contains(favorites[index].id)
                        ? SpinKitPulse(
                            color: mainColor,
                            size: 20,
                          )
                        : Padding(
                            padding: EdgeInsets.only(left: 10), 
                            child: Icon(Icons.delete_outline, color: Colors.grey[400])
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
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(right: 15),
                    width: 40,
                    height: 40,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          favoriteIsDeleting.add(favorites[index].id);
                        });
                        await FavoriteService.deleteMovie(favorites[index].id);
                        Flushbar(
                          duration: Duration(milliseconds: 1000),
                          flushbarPosition: FlushbarPosition.TOP,
                          backgroundColor: Color(0xFFFF5C83),
                          message: favorites[index].movie.title + ' removed from your favorite list',
                        )..show(context);
                        setState(() {
                          favorites.removeWhere((data) => data.id == favorites[index].id);
                          favoriteIsDeleting.remove(favorites[index].id);
                        });
                      },
                    ),
                  )
                )
              ]
            ),
          )
        )
      )
    );
  }
}

import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutix/locale/my_localization.dart';
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
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Favorite> favorites;
  Set<String> favoriteIsDeleting = new Set();

  @override
  void initState() {
    super.initState();
    refreshData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        color: Colors.white,
        backgroundColor: mainColor,
        child: _buildFavoriteList(favorites, context)
      )
    );
  }

  Future refreshData() {
    return FavoriteService.getFavorites(auth.FirebaseAuth.instance.currentUser.uid)
      .then((value) {
        if (mounted) {
          setState(() {
            favorites = value;
          });
        } else {
          favorites = value;
        }
      });
  }

  Widget _buildFavoriteList(List<Favorite> favorites, context) {
    if (favorites == null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 20),
        child: ShimmerList(ShimmerListTemplate.Movie)
      );
    }
    else if (favorites.length == 0) {
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
              MyLocalization.of(context).noFavoriteMessage, 
              style: greyTextFont.copyWith(fontSize: 16)
            )
          ]
        ),
      );
    }

    return Container(
      child: ListView.builder(
        itemCount: favorites.length,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                        MyLocalization.of(context).remove.toUpperCase(),
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
              Flushbar(
                duration: Duration(milliseconds: 1000),
                flushbarPosition: FlushbarPosition.TOP,
                backgroundColor: Color(0xFFFF5C83),
                message: favorites[index].movie.title + ' ' + MyLocalization.of(context).removeFavoriteMessage,
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
                      onLongPress: () {
                        _showBottomSheetModal(context, favorites[index]);
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
                      onTap: () {
                        removeFromFavorite(context, favorites[index]);
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

  void removeFromFavorite(BuildContext context, Favorite favorite) async {
    setState(() {
      favoriteIsDeleting.add(favorite.id);
    });
    Flushbar(
      duration: Duration(milliseconds: 1000),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Color(0xFFFF5C83),
      message: favorite.movie.title + ' ' + MyLocalization.of(context).removeFavoriteMessage,
    )..show(context);
    await FavoriteService.deleteMovie(favorite.id);
    setState(() {
      favorites.removeWhere((data) => data.id == favorite.id);
      favoriteIsDeleting.remove(favorite.id);
    });
  }

  void _showBottomSheetModal(BuildContext context, Favorite favorite){
    showModalBottomSheet(
      context: context,
      elevation: 4,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        ),
      ),
      builder: (BuildContext _){
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: new Wrap(
            children: <Widget>[
              ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.movie_creation_outlined)
                ),
                title: Text(MyLocalization.of(context).showMovie),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(favorite.movie)));
                }
              ),
              ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.share_outlined)
                ),
                title: Text(MyLocalization.of(context).shareMovie),
                onTap: () async {
                  if (Platform.isAndroid) {
                    var response = await http.get(imageBaseURL + 'w500' + (favorite.movie.posterPath ?? favorite.movie.posterPath));
                    final documentDirectory = (await getExternalStorageDirectory()).path;
                    File imgFile = new File('$documentDirectory/shared-movie.png');
                    imgFile.writeAsBytesSync(response.bodyBytes);
                    Share.shareFiles(['$documentDirectory/shared-movie.png'], text: favorite.movie.title);
                  } else {
                    Share.share('Check out my favorite movie: ${favorite.movie.title}', subject: 'Favorite Movie');
                  }
                }
              ),
              ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.delete_outline)
                ),
                title: Text(MyLocalization.of(context).removeFavorite),
                onTap: () {
                  Navigator.pop(context);
                  removeFromFavorite(context, favorite);
                },          
              ),
              ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.close)
                ),
                title: Text(MyLocalization.of(context).cancel),
                onTap: () {
                  Navigator.pop(context);
                },          
              ),
            ],
            ),
        );
      }
    );
  }
}

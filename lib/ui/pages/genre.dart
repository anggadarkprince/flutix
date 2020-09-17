import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/genre.dart';
import 'package:flutix/services/genre_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GenreScreen extends StatefulWidget {
  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  List<Genre> genres;

  @override
  void initState() {
    super.initState();
    refreshData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(MyLocalization.of(context).genre),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        color: Colors.white,
        backgroundColor: mainColor,
        child: _buildGenreList(genres, context)
      )
    );
  }

  Future refreshData() {
    return GenreService.getGenres()
      .then((value) {
        setState(() {
          genres = value;
        });
      });
  }

  Widget _buildGenreList(List<Genre> genres, context) {
    if (genres == null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 20),
        child: SpinKitFadingCircle(
          size: 50,
          color: mainColor,
        )
      );
    }
    else if (genres.length == 0) {
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
      child: ListView.separated(
        itemCount: genres.length,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        separatorBuilder: (context, index) => Divider(height: 0, color: Colors.grey[300]),
        itemBuilder: (_, index) => Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 15),
                child: Text(
                  genres[index].genre, 
                  style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600)
                )
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      
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

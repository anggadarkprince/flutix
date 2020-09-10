import 'package:flutix/models/credit.dart';
import 'package:flutix/models/movie.dart';
import 'package:flutix/models/movie_detail.dart';
import 'package:flutix/services/movie_service.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/schedule.dart';
import 'package:flutix/ui/widgets/credit_card.dart';
import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  MovieDetailScreen(this.movie);

  @override
  Widget build(BuildContext context) {
    MovieDetail movieDetail;

    return Scaffold(
        body: Stack(
        children: <Widget>[
          Container(color: accentColor1),
          SafeArea(child: Container(color: Colors.white)),
          ListView(
            children: <Widget>[
              FutureBuilder(
                future: MovieServices.getDetails(movie),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    movieDetail = snapshot.data;
                  } else if (snapshot.hasError) {
                    return Container(
                      padding: EdgeInsets.all(defaultMargin),
                      child: Center(child: Text("${snapshot.error}")),
                    );
                  }

                  return Column(
                    children: <Widget>[
                      _buildBackDrop(movie, context),
                      _buildTitle(movie),
                      _buildGenre(movieDetail),
                      _buildRating(movie),
                      _buildCredit(movie),
                      _buildStoryLine(movie),
                      _buildButtons(movieDetail, context),
                    ],
                  );
                }
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget _buildBackDrop(Movie movie, BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 270,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageBaseURL + "w1280" + movie.backdropPath ?? movie.posterPath),
                  fit: BoxFit.cover
                )
              ),
            ),
            Container(
              height: 270,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, 1),
                  end: Alignment(0, 0.06),
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0)
                  ]
                )
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: defaultMargin),
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black.withOpacity(0.04)
          ),
          child: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(Movie movie) {
    return Container(
      margin: EdgeInsets.fromLTRB(defaultMargin, 15, defaultMargin, 5),
      child: Text(
        movie.title,
        textAlign: TextAlign.center,
        style: blackTextFont.copyWith(fontSize: 22),
      ),
    );
  }

  Widget _buildGenre(MovieDetail movieDetail) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: (movieDetail != null)
        ? Text(
            movieDetail.genresAndLanguage,
            style: greyTextFont.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
          )
        : SizedBox(
            height: 50,
            width: 50,
            child: SpinKitFadingCircle(
              color: accentColor3,
            ),
          )
    );
  }

  Widget _buildRating(Movie movie) {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        RatingStars(
          voteAverage: movie.voteAverage,
          color: accentColor3,
          alignment: MainAxisAlignment.center,
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget _buildCredit(Movie movie) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(left: defaultMargin, bottom: 15),
            child: Text("Cast & Crew", style: darkTextFont.copyWith(fontSize: 14))
          ),
        ),
        FutureBuilder(
          future: MovieServices.getCredits(movie.id),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              List<Credit> credits = snapshot.data;
              return SizedBox(
                height: 115,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: credits.length,
                  itemBuilder: (_, index) => Container(
                    margin: EdgeInsets.only(
                      left: (index == 0) ? defaultMargin : 0,
                      right: (index == credits.length - 1) ? defaultMargin : 16
                    ),
                    child: CreditCard(credits[index])
                  )
                ),
              );
            } else {
              return SizedBox(
                height: 50,
                child: SpinKitFadingCircle(
                  color: accentColor1,
                )
              );
            }
          }
        )
      ],
    );
  }
  
  Widget _buildStoryLine(Movie movie) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 24, defaultMargin, 8),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Storyline",
              style: darkTextFont,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 30),
          child: Text(
            movie.overview,
            style: greyTextFont.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(MovieDetail movieDetail, context) {
    return Container(
      margin: EdgeInsets.only(bottom: defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250,
            height: 45,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: mainColor,
              child: Text("Continue to Book", style: whiteTextFont.copyWith(fontSize: 16)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleScreen(movieDetail)));
              }
            )
          ),
          SizedBox(width: 5),
          Container(
            width: 55,
            height: 45,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: mainColor,
              child: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: () {
                
              }
            )
          ),
        ],
      ),
    );
  }

}

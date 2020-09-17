import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/movie.dart';
import 'package:flutix/services/movie_service.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/movie_detail.dart';
import 'package:flutix/ui/widgets/rating_star.dart';
import 'package:flutix/ui/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class DiscoveryScreen extends StatefulWidget {
  final String title;
  final int genre;

  DiscoveryScreen(this.title, {this.genre});

  @override
  _DiscoveryScreenState createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  List<Movie> movies;
  int currentPage = 1;
  bool hasMore = true;
  final int nextPageThreshold = 5;

  @override
  void initState() {
    super.initState();
    fetchhData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchhData(reset: true);
        },
        color: Colors.white,
        backgroundColor: mainColor,
        child: _buildMovieList(movies, context)
      )
    );
  }

  Future fetchhData({reset: false}) {
    if (reset) {
      currentPage = 1;
    }
    return MovieServices.getMovies(currentPage, genre: widget.genre)
      .then((value) {
        setState(() {
          if (movies == null || reset) {
            movies = value;
          } else {
            movies.addAll(value);
          }
          hasMore = value.length == 20;
          currentPage += 1;
        });
      });
  }

  Widget _buildMovieList(List<Movie> movies, context) {
    if (movies == null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 20),
        child: ShimmerList(ShimmerListTemplate.Movie)
      );
    }
    else if (movies.length == 0) {
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
        itemCount: movies.length + (hasMore ? 1 : 0),
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        separatorBuilder: (context, index) => Divider(height: 0, color: Colors.grey[300]),
        itemBuilder: (_, index) {
          if (index == movies.length - nextPageThreshold) {
            fetchhData();
          }
          if (index == movies.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SpinKitPulse(
                  size: 50,
                  color: mainColor,
                ),
              )
            );
          }
          return Container(
            margin: EdgeInsets.only(top: index == 0 ? 10 : 0),
            child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 12),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blueGrey[100],
                            image: DecorationImage(
                              image: NetworkImage(imageBaseURL + 'w500' + movies[index].posterPath),
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
                                movies[index].title,
                                style: blackTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Released ${DateFormat('dd MMMM yyyy').format(DateTime.parse(movies[index].releaseDate))}",
                                style: greyTextFont.copyWith(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              RatingStars(
                                voteAverage: movies[index].voteAverage,
                                color: accentColor3,
                              )
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movies[index])));
                        },
                      )
                    )
                  ),
                ]
              )
          );
        }
      )
    );
  }
}

import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/movie.dart';
import 'package:flutix/models/promo.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/services/movie_service.dart';
import 'package:flutix/services/promo_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/discovery.dart';
import 'package:flutix/ui/pages/genre.dart';
import 'package:flutix/ui/pages/map.dart';
import 'package:flutix/ui/pages/movie_detail.dart';
import 'package:flutix/ui/pages/search_movie.dart';
import 'package:flutix/ui/widgets/browse_button.dart';
import 'package:flutix/ui/widgets/coming_soon_dart.dart';
import 'package:flutix/ui/widgets/movie_card.dart';
import 'package:flutix/ui/widgets/promo_card.dart';
import 'package:flutix/ui/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class MovieScreen extends StatefulWidget {  
  final User user;

  MovieScreen(this.user);

  @override
  _MovieScreenState createState() {
    return _MovieScreenState();
  }
}

class _MovieScreenState extends State<MovieScreen> {
  List<Movie> movies;
  List<Promo> promotions;

  @override
  void initState() {
    super.initState();

    MovieServices.getMovies(1)
      .then((value) {
        if(this.mounted) {
          setState(() {
            movies = value;
          });
        }
      });

    PromoService.getPromotions()
      .then((value) {
        if(this.mounted) {
          setState(() {
            promotions = value;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildProfileInfo(),
        _buildSearchBar(),
        _buildNowPlaying(),
        _buildBrowseMovie(),
        _buildComingSoon(),
        _buildPromotion(),
        SizedBox(height: 110)
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      decoration: BoxDecoration(
        color: accentColor1,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25)
        ),
        boxShadow: [
          BoxShadow(color: Color(0x44000000), spreadRadius: 3, blurRadius: 12, offset: Offset(0, 5)),
        ],
      ),
      padding: EdgeInsets.fromLTRB(defaultMargin, 10, defaultMargin, 15),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile', arguments: widget.user);
            },
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF5F558B), width: 1)
              ),
              child: Stack(
                children: <Widget>[
                  SpinKitFadingCircle(
                    color: accentColor2,
                    size: 50,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: (widget.user == null || widget.user.profilePicture == "" || widget.user.profilePicture == null) 
                          ? AssetImage("assets/user_pic.png") 
                          : NetworkImage(widget.user.profilePicture),
                        fit: BoxFit.cover
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile', arguments: widget.user);
                },
                child: SizedBox(
                  child: Text(
                    (widget.user != null ? widget.user.name : 'User'),
                    style: whiteTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/wallet');
                },
                child: Text(
                  NumberFormat.currency(locale: "id_ID", decimalDigits: 0, symbol: "IDR ").format((widget.user != null ? widget.user.balance : 0)),
                  style: yellowNumberFont.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: SearchMovie());
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 20),
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.search, 
                            color: Colors.blueGrey[200],
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(MyLocalization.of(context).exploreThousandsMovies + '...', style: greyTextFont)
                        ],
                      ),
                    )
                  ),     
                ],
              )
            )
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () async {
              Location location = new Location();

              bool _serviceEnabled;
              PermissionStatus _permissionGranted;

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) {
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  return;
                }
              }

              Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                Icons.room, 
                color: Colors.white,
                size: 25,
              ),
            )
          )
        ],
      )
    );
  }

  Widget _buildNowPlaying() {
    List<Movie> nowPlaying = movies == null ? null : movies.sublist(0, 10);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 10),
          child: Text(MyLocalization.of(context).nowPlaying, style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 160,
          child: nowPlaying != null 
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nowPlaying.length,
                itemBuilder: (_, index) => Container(
                  margin: EdgeInsets.only(
                    left: (index == 0) ? defaultMargin : 0,
                    right: (index == nowPlaying.length - 1) ? defaultMargin : 15
                  ),
                  child: MovieCard(nowPlaying[index], onTap: () => _onMovieTap(nowPlaying[index])),
                )
              )
            : ShimmerList(ShimmerListTemplate.MovieCard, itemCount: 5)
        )
      ],
    );
  }

  Widget _buildBrowseMovie() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 10, defaultMargin, 15),
          child: Text(MyLocalization.of(context).browseMovie, style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        (
          widget.user != null
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: defaultMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    widget.user.selectedGenres.length + 1,
                    (index) {
                      if (index == widget.user.selectedGenres.length) {
                        return BrowseButton('More', onTap: (id, genre) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => GenreScreen()));
                        });
                      }
                      return BrowseButton(widget.user.selectedGenres[index], onTap: (id, genre) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DiscoveryScreen(genre, genre: id)));
                      });
                    }
                  ),
                ),
              )
            : SpinKitPulse(
                color: mainColor,
                size: 50,
              )
        )
      ],
    );
  }

  Widget _buildComingSoon() {
    List<Movie> comingSoon = movies == null ? null : movies.sublist(10);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 15),
          child: Text(MyLocalization.of(context).comingSoon, style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 140,
          child: comingSoon != null 
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: comingSoon.length,
                itemBuilder: (_, index) => Container(
                  margin: EdgeInsets.only(
                    left: (index == 0) ? defaultMargin : 0,
                    right: (index == comingSoon.length - 1) ? defaultMargin : 16
                  ),
                  child: ComingSoonCard(comingSoon[index], onTap: () => _onMovieTap(comingSoon[index])),
                )
              )
            : ShimmerList(ShimmerListTemplate.MovieCardPortrait, itemCount: 5)
        )
      ]
    );
  }

  Widget _buildPromotion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 20),
          child: Text(MyLocalization.of(context).promotion, style: darkTextFont.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        promotions == null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: ShimmerList(ShimmerListTemplate.Promo, itemCount: 3)
            )
          : Column(
              children: promotions.map((promoItem) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 16),
                  child: PromoCard(promoItem, onTap: () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('${MyLocalization.of(context).promotion} ${promoItem.title}'),
                      duration: Duration(milliseconds: 1000)
                    ));
                  })
                );
              }).toList(),
            ),
      ]
    ); 
  }

  void _onMovieTap(movie) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movie)));
  }
}
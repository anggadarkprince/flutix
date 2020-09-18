import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/movie_list.dart';
import 'package:flutix/ui/pages/search_movie.dart';
import 'package:flutter/material.dart';

class DiscoveryScreen extends StatefulWidget {
  final String title;
  final int genre;

  DiscoveryScreen(this.title, {this.genre});

  @override
  _DiscoveryScreenState createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              showSearch(context: context, delegate: SearchMovie());
            },
          )
        ]
      ),
      body: MovieList(genre: widget.genre)
    );
  }
}

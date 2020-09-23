import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/movie_list.dart';
import 'package:flutix/ui/widgets/preference_builder.dart';
import 'package:flutter/material.dart';

class SearchMovie extends SearchDelegate {
  final String recentKey = AppPrefs.recentSearch.toString();
  List<String> suggestions = [];
  int genre;

  SearchMovie({genre}) {
    this.genre = genre;
    SharedPreferencesBuilder.getData(recentKey, suggestions)
      .then((value) {
        suggestions = List.from(value);
      });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      SharedPreferencesBuilder.getData(recentKey, [])
        .then((value) {
          List<String> recents = value == null || value.length == 0 ? [] : (value.cast<String>().toList());
          
          if (!recents.contains(query)) {
            recents.add(query);
            if (recents.length > 5) {
              recents.removeAt(0);
            }
            print(recents);
            SharedPreferencesBuilder.setData(recentKey, recents);
          }
        });
      return MovieList(genre: genre, query: query);
    } else {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search, 
              color: Colors.blueGrey[100],
              size: 70
            ),
            SizedBox(height: 5),
            Text(
              MyLocalization.of(context).discoverNewMovie,
              style: greyTextFont.copyWith(color: Colors.blueGrey[200], fontSize: 18)
            ),
            Text(
              MyLocalization.of(context).exploreThousandsMovies,
              style: greyTextFont.copyWith(color: Colors.blueGrey[100])
            ),
            SizedBox(height: 20),
          ],
        )
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
      ? suggestionList = List.from(suggestions.reversed)
      : suggestionList.addAll(
          suggestions.where((element) => element.toLowerCase().contains(query.toLowerCase()))
        );
    print(suggestionList);

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            query = suggestionList[index];
            showResults(context);
          },
        );
      }
    );
  }
  
}
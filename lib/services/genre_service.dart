import 'dart:convert';

import 'package:flutix/models/genre.dart';
import 'package:flutix/shared/prefs.dart';
import 'package:http/http.dart' as http;

class GenreService {

  static Future<List<Genre>> getGenres({http.Client client}) async {
    String url = "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey";
    
    client ??= http.Client();

    var response = await client.get(url);

    if(response.statusCode != 200) {
      return [];
    }

    var data = json.decode(response.body);
    List result = data['genres'];

    return result.map((e) => Genre.fromJson(e)).toList();
  }
}

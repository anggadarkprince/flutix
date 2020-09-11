import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutix/models/favorite.dart';
import 'package:flutix/models/movie.dart';
import 'package:flutix/models/movie_detail.dart';
import 'package:flutix/services/movie_service.dart';

class FavoriteService {
  static CollectionReference favoriteCollection = FirebaseFirestore.instance.collection('favorites');

  static Future<Favorite> saveMovie(String userID, Movie movie) async {
    DocumentReference docReference = favoriteCollection.doc();
    await docReference.set({
      'movieID': movie.id ?? "",
      'userID': userID ?? "",
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    DocumentSnapshot snapshot = await favoriteCollection.doc(docReference.id).get();
    return Favorite(
      docReference.id, 
      movie, 
      userID, 
      DateTime.fromMillisecondsSinceEpoch(snapshot.data()['time'])
    );
  }

  static Future<void> deleteMovie(String id) async {
    await favoriteCollection.doc(id).delete();
  }

  static Future<Favorite> getFavoriteByUserMovie(String userID, Movie movie) async {
    QuerySnapshot snapshot = await favoriteCollection.get();
    var documents = snapshot.docs.where((document) => document.data()['userID'] == userID && document.data()['movieID'] == movie.id);
    if (documents != null && documents.length > 0) {
      var document = documents.first;
      return Favorite(
        document.id,
        movie,
        userID,
        DateTime.fromMillisecondsSinceEpoch(document.data()['time'])
      );
    }
    return null;
  }

  static Future<List<Favorite>> getFavorites(String userId) async {
    QuerySnapshot snapshot = await favoriteCollection.get();
    var documents = snapshot.docs.where((document) => document.data()['userID'] == userId);

    List<Favorite> favorites = [];
    for (var document in documents) {
      MovieDetail movieDetail = await MovieServices.getDetails(null, movieID: document.data()['movieID']);
      favorites.add(
        Favorite(
          document.id,
          movieDetail,
          document.data()['userID'],
          DateTime.fromMillisecondsSinceEpoch(document.data()['time']),
          movie: Movie(
            id: movieDetail.id, 
            title: movieDetail.title, 
            voteAverage: movieDetail.voteAverage, 
            overview: movieDetail.overview, 
            posterPath: movieDetail.posterPath, 
            backdropPath: movieDetail.backdropPath
          )
        )
      );
    }
    favorites.sort((favorite1, favorite2) => favorite2.time.compareTo(favorite1.time));

    return favorites;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutix/models/theater.dart';

class TheaterService {
  static CollectionReference theaterCollection = FirebaseFirestore.instance.collection('cinemas');

  static Future<List<Theater>> getTheaters() async {
    QuerySnapshot snapshot = await theaterCollection.get();

    List<Theater> theaters = [];
    for (var document in snapshot.docs) {
      theaters.add(
        Theater(
          document.data()['cinema'], 
          document.data()['location'],
          lat: document.data()['lat'] ?? 0,
          lng: document.data()['lng'] ?? 0,
        )
      );
    }

    return theaters;
  }
}

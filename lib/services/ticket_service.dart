import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutix/models/movie_detail.dart';
import 'package:flutix/models/theater.dart';
import 'package:flutix/models/ticket.dart';

import 'movie_service.dart';

class TicketService {
  static CollectionReference ticketCollection = FirebaseFirestore.instance.collection('tickets');

  static Future<void> saveTicket(String id, Ticket ticket) async {
    await ticketCollection.doc().set({
      'movieID': ticket.movieDetail.id ?? "",
      'userID': id ?? "",
      'theaterName': ticket.theater.name ?? 0,
      'location': ticket.theater.location ?? '',
      'time': ticket.time.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      'bookingCode': ticket.bookingCode,
      'seats': ticket.seatsInString,
      'name': ticket.name,
      'totalPrice': ticket.totalPrice
    });
  }

  static Future<List<Ticket>> getTickets(String userId) async {
    QuerySnapshot snapshot = await ticketCollection.get();
    var documents = snapshot.docs.where((document) => document.data()['userID'] == userId);

    List<Ticket> tickets = [];
    for (var document in documents) {
      MovieDetail movieDetail = await MovieServices.getDetails(null, movieID: document.data()['movieID']);
      tickets.add(Ticket(
          movieDetail,
          Theater(document.data()['theaterName'], document.data().containsKey('location') ? document.data()['location'] : ''),
          DateTime.fromMillisecondsSinceEpoch(document.data()['time']),
          document.data()['bookingCode'],
          document.data()['seats'].toString().split(','),
          document.data()['name'],
          document.data()['totalPrice']));
    }

    return tickets;
  }
}

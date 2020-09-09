
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutix/models/transaction.dart' as tix;

class TransactionService {
  static CollectionReference transactionCollection = FirebaseFirestore.instance.collection('transactions');

  static Future<void> saveTransaction(tix.Transaction transaction) async {
    await transactionCollection.doc().set({
      'userID': transaction.userID,
      'type': transaction.type,
      'category': transaction.category,
      'title': transaction.title,
      'subtitle': transaction.subtitle,
      'time': transaction.time.millisecondsSinceEpoch,
      'amount': transaction.amount,
      'picture': transaction.picture
    });
  }

  static Future<List<tix.Transaction>> getTransaction(String userID) async {
    QuerySnapshot snapshot = await transactionCollection.get();

    var documents = snapshot.docs.where((document) => document.data()['userID'] == userID);

    return documents
        .map((e) => tix.Transaction(
            userID: e.data()['userID'],
            type: e.data()['type'],
            category: e.data()['category'],
            title: e.data()['title'],
            subtitle: e.data()['subtitle'],
            time: DateTime.fromMillisecondsSinceEpoch(e.data()['time']),
            amount: e.data()['amount'],
            picture: e.data()['picture']))
        .toList();
  }
}

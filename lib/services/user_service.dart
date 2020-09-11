import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutix/models/user.dart';

class UserService {
  static CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  static Future<void> updateUser(User user) async {
    _userCollection.doc(user.id).set({
      'email': user.email,
      'name': user.name,
      'balance': user.balance,
      'selectedGenres': user.selectedGenres,
      'selectedLanguage': user.selectedLanguage,
      'profilePicture': user.profilePicture ?? ""
    });
  }

  static Future<void> purchaseTicket(User user, totalPurchase) async {
    _userCollection.doc(user.id).update({
      'balance': user.balance - totalPurchase,
    });
  }

  static Future<void> depositTicket(User user, totalDeposit) async {
    _userCollection.doc(user.id).update({
      'balance': user.balance + totalDeposit,
    });
  }

  static Future<User> getUser(String id) async {
    DocumentSnapshot snapshot = await _userCollection.doc(id).get();

    return User(id, snapshot.data()['email'],
        balance: snapshot.data()['balance'],
        profilePicture: snapshot.data()['profilePicture'],
        selectedGenres: List.from(snapshot.data()['selectedGenres']),
        selectedLanguage: snapshot.data()['selectedLanguage'],
        name: snapshot.data()['name']);
  }
}

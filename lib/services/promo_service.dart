import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutix/models/promo.dart';

class PromoService {
  static CollectionReference promoCollection = FirebaseFirestore.instance.collection('promos');

  static Future<List<Promo>> getPromotions() async {
    QuerySnapshot snapshot = await promoCollection.get();

    List<Promo> promotions = [];
    for (var document in snapshot.docs) {
      promotions.add(
        Promo(
          title: document.data()['title'],
          description: document.data()['description'],
          discount: document.data()['discount'],
          effectiveDate: document.data()['effective_date'],
          expiredDate: document.data()['expired_date'],
        )
      );
    }
    promotions.sort((favorite1, favorite2) => favorite2.expiredDate.compareTo(favorite1.expiredDate));

    return promotions;
  }
}

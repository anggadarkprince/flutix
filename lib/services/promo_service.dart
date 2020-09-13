import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutix/models/promo.dart';

class PromoService {
  static CollectionReference promoCollection = FirebaseFirestore.instance.collection('promos');

  static Future<Promo> getPromoByCode(String couponCode) async {
    QuerySnapshot snapshot = await promoCollection.get();
    var documents = snapshot.docs.where((document) => document.data()['couponCode'] == couponCode);
    if (documents != null && documents.length > 0) {
      var document = documents.first;
      return Promo(
        title: document.data()['title'],
        description: document.data()['description'],
        discount: document.data()['discount'],
        effectiveDate: document.data()['effectiveDate'],
        expiredDate: document.data()['expiredDate'],
        couponCode: document.data()['couponCode'],
      );
    }
    return null;
  }

  static Future<List<Promo>> getPromotions() async {
    QuerySnapshot snapshot = await promoCollection.get();

    List<Promo> promotions = [];
    for (var document in snapshot.docs) {
      promotions.add(
        Promo(
          title: document.data()['title'],
          description: document.data()['description'],
          discount: document.data()['discount'],
          effectiveDate: document.data()['effectiveDate'],
          expiredDate: document.data()['expiredDate'],
          couponCode: document.data()['couponCode'],
        )
      );
    }
    promotions.sort((favorite1, favorite2) => favorite2.expiredDate.compareTo(favorite1.expiredDate));

    return promotions;
  }
}

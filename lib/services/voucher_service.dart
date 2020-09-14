import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutix/models/promo.dart';
import 'package:flutix/models/voucher.dart';

class VoucherService {
  static CollectionReference voucherCollection = FirebaseFirestore.instance.collection('vouchers');

  static Future<Voucher> saveVoucher(String userID, Promo promo) async {
    DocumentReference docReference = voucherCollection.doc();
    await docReference.set({
      'userID': userID ?? "",
      'couponCode': promo.couponCode,
      'title': promo.title,
      'description': promo.description,
      'discount': promo.discount,
      'expiredDate': promo.expiredDate,
    });
    DocumentSnapshot snapshot = await voucherCollection.doc(docReference.id).get();
    return Voucher(
      docReference.id,
      userID,
      snapshot.data()['couponCode'],
      snapshot.data()['title'],
      snapshot.data()['description'],
      snapshot.data()['discount'],
      snapshot.data()['expiredDate'],
    );
  }

  static Future<void> deleteVoucher(String id) async {
    await voucherCollection.doc(id).delete();
  }

  static Future<bool> isAcquired(String userId, String couponCode) async {
    QuerySnapshot snapshot = await voucherCollection.get();
    var document = snapshot.docs.where((document) => document.data()['userID'] == userId && document.data()['couponCode'] == couponCode);

    return document != null && document.length > 0;
  }

  static Future<List<Voucher>> getVouchers(String userId) async {
    QuerySnapshot snapshot = await voucherCollection.get();
    var documents = snapshot.docs.where((document) => document.data()['userID'] == userId);

    List<Voucher> vouchers = [];
    for (var document in documents) {
      vouchers.add(
        Voucher(
          document.id,
          document.data()['userID'],
          document.data()['couponCode'],
          document.data()['title'],
          document.data()['description'],
          document.data()['discount'],
          document.data()['expiredDate'],
        )
      );
    }
    return vouchers;
  }
}

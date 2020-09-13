import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutix/models/voucher.dart';

class VoucherService {
  static CollectionReference voucherCollection = FirebaseFirestore.instance.collection('vouchers');

  static Future<void> deleteVoucher(String id) async {
    await voucherCollection.doc(id).delete();
  }

  static Future<List<Voucher>> getFavorites(String userId) async {
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

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<File> getImage({from: ImageSource.gallery}) async {
  final picker = ImagePicker();
  var image = await picker.getImage(source: from);
  return File(image.path);
}

Future<String> uploadImage(File image) async {
  List<String> splitPath = image.path.split('/');
  String fileName = splitPath[splitPath.length - 1];

  StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
  StorageUploadTask task = ref.putFile(image);
  StorageTaskSnapshot snapshot = await task.onComplete;

  return await snapshot.ref.getDownloadURL();
}
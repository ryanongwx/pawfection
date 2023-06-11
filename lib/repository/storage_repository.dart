import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as FirebaseStorage;
import 'dart:async';

class StorageRepository {

  final FirebaseStorage.FirebaseStorage _storage =
      FirebaseStorage.FirebaseStorage.instance;

  Future<String> uploadImageToStorage(File file, String user_id) async {
    FirebaseStorage.Reference ref =
        _storage.ref().child('profilepictures').child(user_id);
    FirebaseStorage.UploadTask uploadTask = ref.putFile(file);
    FirebaseStorage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
}

import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageRepository {
  UploadTask uploadImageFile(String uid, String filename, File file){
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user2/$uid')        // 경로
        .child('/$filename.jpg');  // 파일명

    // 현재 metadata는 필요가 없으므로 생략
    // final metadata = firebase_storage.SettableMetadata(
    //     contentType: 'image/jpeg',
    //     customMetadata: {'picked-file-path': file.path});
    //
      return ref.putFile(file);
  }
}
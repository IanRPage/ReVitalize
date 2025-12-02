import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  CloudStorageService._();

  static final CloudStorageService instance = CloudStorageService._();

  final _storage = FirebaseStorage.instance;

  Reference userProfilePictureRef(String uid) {
    return _storage.ref().child('userProfilePictures').child(uid);
  }

  Future<String> uploadProfilePicture({
    required String uid,
    required File file,
  }) async {
    final ref = userProfilePictureRef(uid);

    await ref.putFile(file);

    final url = await ref.getDownloadURL();
    return url;
  }

  Future<String?> getUserProfilePictureUrl(String uid) async {
    final ref = userProfilePictureRef(uid);
    try {
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return null;
      }
      rethrow; // let other errors bubble up
    }
  }
}

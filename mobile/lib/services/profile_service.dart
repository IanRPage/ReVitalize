import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final _db = FirebaseFirestore.instance;

  Future<void> createProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<void> updateProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Future<DocumentSnapshot> getProfile(String uid) {
    return _db.collection('users').doc(uid).get();
  }
}

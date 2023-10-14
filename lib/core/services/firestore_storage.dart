import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirestoreStorageService {
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://rental-task.appspot.com');

  Future<String> getDownloadURL(String fileName) async {
    try {
      return await _storage.ref().child(fileName).getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFile(String fileName) async {
    try {
      await _storage.ref().child(fileName).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadFile(File file, String fileName) async {
    try {
      final reference = _storage.ref().child(fileName);
      await reference.putFile(file);
    } catch (e) {
      rethrow;
    }
  }
}

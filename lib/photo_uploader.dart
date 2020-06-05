import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';

import 'firebase_provider.dart';

class PhotoUploader {
  static void uploadImageToStorage(ImageSource source, DateTime startDate, FirebaseProvider fp) async {
    FirebaseUser _user = fp.getUser();
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

    File _image = await ImagePicker.pickImage(source: source);
    DateTime now = new DateTime.now();

    StorageReference storageReference =
      _firebaseStorage.ref().child("certification_photo/${_user.uid}_$now");
    DatabaseReference databaseReference = 
      _firebaseDatabase.reference().child("users/${_user.uid}").child("goal").child("auth_image");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image);
    await storageUploadTask.onComplete;
    String url = await storageReference.getDownloadURL();
    databaseReference.update(<String, String>{
      "0${now.difference(startDate).inDays}": url
    });
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureUploader {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final metadata = SettableMetadata(
    contentType: 'image/jpeg',
  );
  String _imageUrl = '';

  Future<void> uploadImage() async {
    String? image = await _pickImage();
    if (image == null) return;

    final imageRef = _getImageRef();

    UploadTask uploadTask = imageRef.putFile(File(image), metadata);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    _imageUrl = downloadUrl;

    await _updateProfilePicture();
  }

  Future<String?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) return image.path;
    return null;
  }

  Reference _getImageRef() {
    final user = _auth.currentUser;
    final imageRef = _storage.ref().child('profile_pictures/${user!.uid}.jpg');
    return imageRef;
  }

  Future<void> _updateProfilePicture() async {
    final user = _auth.currentUser;
    var userData = _firestore.collection('users');

    await userData.doc(user!.uid).set(
      {
        'profile_picture': _imageUrl,
      },
      SetOptions(merge: true),
    );
    await _auth.currentUser!.updatePhotoURL(_imageUrl);
  }
}

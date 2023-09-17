import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class PictureUploader {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final metadata = SettableMetadata(
    contentType: 'image/jpeg',
  );

  Future<String?> uploadImage(String chatId) async {
    String? image = await _pickImage();
    if (image == null) return null;

    final imageRef = _getImageRef();

    UploadTask uploadTask = imageRef.putFile(File(image), metadata);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) return image.path;
    return null;
  }

  Reference _getImageRef() {
    // final user = _auth.currentUser;
    final name = DateTime.now().millisecondsSinceEpoch;
    final imageRef = _storage.ref().child('chats_pictures/$name.jpg');
    return imageRef;
  }
}

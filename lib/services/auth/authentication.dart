import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static Future<String> registerNewUser(
      String email, String password, String username) async {
    String? msg;

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(username);

      String userId = credential.user!.uid;
      addUserToDB(userId, email, username);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        msg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        msg = 'The account already exists for that email.';
      } else {
        msg = 'Invalid Input';
      }
    } catch (e) {
      msg = 'Invalid Input';
    }

    if (msg != null) {
      return msg;
    }

    msg = 'Registration successfully. Go and login to your account';
    return msg;
  }

  static Future<String> loginOldUser(String email, String password) async {
    String? msg;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        msg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        msg = 'Wrong password provided for that user.';
      } else {
        msg = 'Invalid Input';
      }
    } catch (e) {
      msg = 'Invalid Input';
    }

    if (msg != null) {
      return msg;
    }

    msg = 'Login Successfully';
    return msg;
  }

  static void addUserToDB(String userId, String email, String username) {
    final CollectionReference snapShot =
        FirebaseFirestore.instance.collection('users');

    snapShot.doc(userId).set({
      'email': email,
      'username': username,
      'profile_picture':
          'https://firebasestorage.googleapis.com/v0/b/chat-app-dc281.appspot.com/o/profile_pictures%2FpersonLogo.jpg?alt=media&token=cef46837-a270-472b-8f8e-658e5775a233',
    });
  }
}

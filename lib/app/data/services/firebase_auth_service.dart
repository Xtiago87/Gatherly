import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  Future<bool> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      String? fcmToken = await FirebaseMessaging.instance.getToken();

      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'email': email,
        'fcmToken': fcmToken
      });

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else {
        throw e.message ?? "Algo de errado aconteceu! Tente novamente mais tarde.";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
     final resp = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(resp);

     User? user = resp.user;

     String? fcmToken = await FirebaseMessaging.instance.getToken();

     await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
       'email': email,
       'fcmToken': fcmToken
     });
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
       throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
       throw 'Wrong password provided for that user.';
      } else {
        throw e.message ?? "Algo de errado aconteceu! Tente novamente mais tarde.";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
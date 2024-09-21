import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iplanning/utils/authExceptionHandler.dart';

class AuthenticationService {
  final _firebase = FirebaseAuth.instance;

  Future<AuthStatus> creatAccount({
    required String email,
    required String password,
    required String name,
    String? country,
    String? phoneNumber,
  }) async {
    AuthStatus _status;
    try {
      UserCredential userCredentials = await _firebase
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'email': email,
        'name': name,
        'country': country,
        "phone": phoneNumber
      }); //createData

      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<AuthStatus> login({
    required String email,
    required String password,
  }) async {
    AuthStatus _status;
    try {
      UserCredential userCredentials = await _firebase
          .signInWithEmailAndPassword(email: email, password: password);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<AuthStatus> forgotPassword({
    required String email,
  }) async {
    AuthStatus _status;
    try {
      await _firebase.sendPasswordResetEmail(email: email);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }
}

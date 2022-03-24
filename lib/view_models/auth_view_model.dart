import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_info_view_model.dart';

class AuthViewModel {
  final FirebaseAuth _firebaseAuth;

  AuthViewModel(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  User CurrentUser() => _firebaseAuth.currentUser;

  Future<User> AnonymousOrCurrent() async {
    if (_firebaseAuth.currentUser == null) {
      await _firebaseAuth.signInAnonymously();
    }
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signIn({String email, String password}) async {
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
    return userCredential;
  }

  Future<UserCredential> signUp({String email, String password, String fullName, String phoneNumber, String governorate, String address}) async {
    UserCredential userCredential;
    if (_firebaseAuth.currentUser.isAnonymous) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
        userCredential = await _firebaseAuth.currentUser.linkWithCredential(credential);
        User user = userCredential.user;
        await UserInfoViewModel(uid: user.uid).addUserData(fullName, phoneNumber, governorate, address);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          log('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          log('The account already exists for that email.');
        }
      } catch (e) {
        log(e);
      }
    } else {
      try {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        User user = userCredential.user;
        await UserInfoViewModel(uid: user.uid).addUserData(fullName, phoneNumber, governorate, address);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          log('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          log('The account already exists for that email.');
        }
      } catch (e) {
        log(e);
      }
    }
    return userCredential;
  }
}

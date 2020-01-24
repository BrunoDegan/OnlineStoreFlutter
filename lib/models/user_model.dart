import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:scoped_model/scoped_model.dart";

class UserModel extends Model {
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData;

  Future<void> signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailed}) async {
    isLoading = true;
    notifyListeners();

    await firebaseAuth.createUserWithEmailAndPassword(
        email: userData["email"], password: pass);

    await saveUserData(userData).then((user) async {
      firebaseUser = user;

      if (firebaseUser != null) {
        onSuccess();
      } else {
        onFailed();
      }
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  void recoverPassword() {}

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;

    Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  void signOut() async {
    await firebaseAuth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

}

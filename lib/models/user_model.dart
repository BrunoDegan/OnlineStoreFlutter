import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:scoped_model/scoped_model.dart";

class UserModel extends Model {
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData;

  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);
    await loadCurrentUser();
  }

  Future<Null> saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;

    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<void> signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailed}) async {
    isLoading = true;
    notifyListeners();

    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) {
      firebaseUser = user.user;
      isLoading = false;
      saveUserData(userData);
      onSuccess();
    }).catchError((onError) {
      isLoading = false;
      notifyListeners();
      onFailed();
    });
  }

  Future<Null> loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await firebaseAuth.currentUser();

    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

  void signIn(
      {@required var email,
      @required var password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailed}) async {
    isLoading = true;
    notifyListeners();

    firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      firebaseUser = authResult.user;

      await loadCurrentUser();

      onSuccess();
      notifyListeners();
      isLoading = false;
    }).catchError((error) {
      onFailed();
      notifyListeners();
      isLoading = false;
    });
  }

  void recoverPassword(String email) {
    firebaseAuth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void signOut() async {
    await firebaseAuth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }
}

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
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    loadCurrentUser();
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
      saveUserData(userData);

      onSuccess();
      isLoading = false;
    }).catchError((onError) {
      onFailed();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> loadCurrentUser() async {
    if (firebaseUser == null)
      firebaseUser = await firebaseAuth.currentUser();

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

  void recoverPassword() {}

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

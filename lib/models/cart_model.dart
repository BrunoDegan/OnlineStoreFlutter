import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlinestore/data/cart_product.dart';
import 'package:onlinestore/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  List<CartProduct> products = [];
  UserModel userModel;
  bool isLoading = false;

  CartModel(this.userModel);

  static CartModel of(BuildContext context) {
    return ScopedModel.of<CartModel>(context);
  }

  void addCartItem(CartProduct product) {
    products.add(product);
    Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .add(product.toMap())
        .then((response) {
      product.id = response.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct product) {
    Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("chart")
        .document(product.id)
        .delete();

    products.remove(product);
    notifyListeners();
  }
}

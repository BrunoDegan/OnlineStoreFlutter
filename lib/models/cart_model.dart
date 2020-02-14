import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlinestore/data/cart_product.dart';
import 'package:onlinestore/models/user_model.dart';
import 'package:onlinestore/widgets/cart_price.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  List<CartProduct> products = [];
  UserModel userModel;
  bool isLoading = false;
  String cupomCode;
  int discountPercentage = 0;

  CartModel(this.userModel){
    if(userModel.isLoggedIn())
      loadCartItems();
  }

  static CartModel of(BuildContext context) {
    return ScopedModel.of<CartModel>(context);
  }

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((response) {
      cartProduct.id = response.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.id)
        .delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void decrementProduct(CartProduct cartProduct) {
    cartProduct.qtd--;

    Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.id)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incrementProduct(CartProduct cartProduct) {
    cartProduct.qtd++;

    Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.id)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void loadCartItems() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    products = snapshot.documents
        .map((document) => CartProduct.fromDocument(document))
        .toList();

    notifyListeners();
  }

  double getProductPrice() {
    double price = 0.0;
    for(CartProduct product in products) {
      if(product != null) {
        price += product.qtd * product.productData.price;
      }
    }

    return price;
  }

  double getDiscount(){
    return getProductPrice() * discountPercentage / 100;
  }
  double getShipPrice(){
    return 9.99;
  }

  void updatePrices(){
    notifyListeners();
  }

  void setCupon(String cuponCode, int discountPercentage) {
    this.cupomCode = cuponCode;
    this.discountPercentage = discountPercentage;
  }

}

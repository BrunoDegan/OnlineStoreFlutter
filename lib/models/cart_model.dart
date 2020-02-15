import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlinestore/data/cart_product.dart';
import 'package:onlinestore/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  List<CartProduct> products = [];
  UserModel userModel;
  bool isLoading = false;
  String cupomCode;
  int discountPercentage = 0;

  CartModel(this.userModel) {
    if (userModel.isLoggedIn()) loadCartItems();
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

  double getOrderValue() {
    double price = 0.0;
    for (CartProduct product in products) {
      if (product != null) {
        price += product.qtd * product.productData.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getOrderValue() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrices() {
    notifyListeners();
  }

  void setCupon(String cuponCode, int discountPercentage) {
    this.cupomCode = cuponCode;
    this.discountPercentage = discountPercentage;
  }

  Future<String> finishOrder() async {
    if (products.length == 0)
      return null;

    isLoading = true;
    notifyListeners();

    double orderValue = getOrderValue();
    double discountValue = getDiscount();
    double shipmentValue = getShipPrice();

    DocumentReference orderRef =
        await Firestore.instance.collection('orders').add({
      "clientId": userModel.firebaseUser.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipmentValue,
      "orderValue": orderValue,
      "discount": discountValue,
      "totalPrice": (orderValue - discountValue) + shipmentValue,
      "status": 1
    });

    await Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("orders")
        .document(orderRef.documentID)
        .setData({"orderId": orderRef.documentID});

    QuerySnapshot snapshot = await Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    for(DocumentSnapshot docSnapshot in snapshot.documents) {
      docSnapshot.reference.delete();
    }

    products.clear();

    discountPercentage = 0;
    cupomCode = null;
    isLoading = false;
    notifyListeners();

    return orderRef.documentID;

  }
}

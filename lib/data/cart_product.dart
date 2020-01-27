import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinestore/data/product_data.dart';

class CartProduct {
  String id;
  String category;
  String productId;
  int qtd;
  String size;

  ProductData productData;

  CartProduct.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    category = snapshot.data["category"];
    productId = snapshot.data["pid"];
    qtd = snapshot.data["quantity"];
    size = snapshot.data["size"];
  }

  Map<String, dynamic> toMap() {
    var cartProduct = Map<String, dynamic>();
    cartProduct.addAll({
      "category" : category,
      "pid" : productId,
      "quantity" : qtd,
      "size" : size,
      "product" : productData.toResumedMap()
    });

    return cartProduct;
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlinestore/data/cart_product.dart';
import 'package:onlinestore/data/product_data.dart';
import 'package:onlinestore/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget buildWidget() {
      return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image(image: NetworkImage(cartProduct.productData.imagesUrl[0])),
        ),
        Expanded(
            child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        cartProduct.productData.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17.0),
                      ),
                      Text("Tamanho: ${cartProduct.size}",
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      Text(
                          "R\ ${cartProduct.productData.price.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            color: Theme.of(context).primaryColor,
                            onPressed: cartProduct.qtd > 1
                                ? () {
                                    CartModel.of(context)
                                        .decrementProduct(cartProduct);
                                  }
                                : null,
                          ),
                          Text(cartProduct.qtd.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              CartModel.of(context)
                                  .incrementProduct(cartProduct);
                            },
                          ),
                          FlatButton(
                            child: Text("Remover"),
                            textColor: Colors.grey[500],
                            onPressed: () {
                              CartModel.of(context).removeCartItem(cartProduct);
                            },
                          )
                        ],
                      )
                    ])))
      ]);
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection("products")
                    .document(cartProduct.category)
                    .collection("items")
                    .document(cartProduct.productId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data);
                    return buildWidget();
                  } else {
                    return Container(
                        height: 70.0,
                        child: CircularProgressIndicator(),
                        alignment: Alignment.center);
                  }
                })
            : buildWidget());
  }

  Future<dynamic> getImageUrl() async {
    var imageRef = FirebaseStorage.instance
        .ref()
        .child(cartProduct.productData.imagesUrl[0]);

    String url = await imageRef.getDownloadURL();

    return url;
  }
}
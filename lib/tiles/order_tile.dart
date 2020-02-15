import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection("orders")
                    .document("orderId")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Código do pedido: ${snapshot.data.documentID}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(buildProductsTab(snapshot.data))
                      ],
                    );
                  }
                })));
  }


  String buildProductsTab(DocumentSnapshot snapshot) {
    String formattedDescription = "Descrição:\n";
    for (LinkedHashMap map in snapshot.data["products"]) {
      formattedDescription +=
      "${map["quantity"]} x ${map["product"]["title"]} {R\$ ${map["product"]["price"].toString()}\n";
      formattedDescription += "Total: R\$ ${snapshot.data["totalPrice"].toString()}";
    }

    return formattedDescription;
  }

}



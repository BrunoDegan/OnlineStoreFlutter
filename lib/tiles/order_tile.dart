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
                    .document(orderId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    int status = snapshot.data["status"];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Código do pedido: ${snapshot.data.documentID}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4.0,),
                        Text(buildProductsTab(snapshot.data)),
                        SizedBox(height: 4.0,),
                        Text("Status do pedido",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildOrderStatus("1", "Preparação",status, 1),
                            Container(height: 1.0, width: 40.0, color: Colors.grey,),
                            buildOrderStatus("2", "Transporte", status, 2),
                            Container(height: 1.0, width: 40.0, color: Colors.grey,),
                            buildOrderStatus("2", "Entrega", status, 3)
                          ],
                        )
                      ],
                    );
                  }
                })));
  }

  String buildProductsTab(DocumentSnapshot snapshot) {
    String formattedDescription = "Descrição:\n";

    for (LinkedHashMap map in snapshot.data["products"]) {
      formattedDescription +=
          "${map["quantity"]} x ${map["product"]["title"]} R\$ ${map["product"]["price"].toString()}\n";
      formattedDescription +=
          "Total: R\$ ${snapshot.data["totalPrice"].toString()}";
    }

    return formattedDescription;
  }

  Widget buildOrderStatus(
      String title, String subtitle, int status, thisStatus) {

    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    }

    if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}

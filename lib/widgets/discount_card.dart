import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlinestore/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
          title: Text(
            "Cupom de desconto",
            textAlign: TextAlign.start,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          leading: Icon(Icons.card_giftcard),
          trailing: Icon(Icons.add),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Digite seu cupom'),
                initialValue: CartModel.of(context).cupomCode ?? "",
                onFieldSubmitted: (text) {
                  Firestore.instance
                      .collection("cupons")
                      .document(text)
                      .get()
                      .then((snapshot) {
                    if (snapshot.data != null) {
                      CartModel.of(context)
                          .setCupon(text, snapshot.data["percent"]);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Desconto de ${snapshot.data["percent"]} % aplicado!"),
                        backgroundColor: Theme.of(context).primaryColor,
                      ));
                    } else {
                      CartModel.of(context).setCupon(null, 0);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Cupom não existente"),
                          backgroundColor: Colors.redAccent));
                    }
                  });
                },
              ),
            )
          ]),
    );
  }
}

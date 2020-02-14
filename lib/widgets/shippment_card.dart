import 'package:flutter/material.dart';

class ShipmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
          title: Text(
            "Calcular frete",
            textAlign: TextAlign.start,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          leading: Icon(Icons.location_on),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Digite seu CEP'),
                initialValue: "",
                onFieldSubmitted: (text) {},
              ),
            )
          ]),
    );
  }
}

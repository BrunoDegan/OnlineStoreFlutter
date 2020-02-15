import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlinestore/tiles/category_tiles.dart';

class ProductsTabs extends StatelessWidget {

  final String products = "products";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection(products).getDocuments(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var dividerTiles = ListTile.divideTiles(context: context,
                tiles: snapshot.data.documents.map((doc) {

                  return CategoryTiles(doc);

                }).toList(), color: Colors.grey[500]).toList();

            return ListView(children: dividerTiles);
          }
        }
    );
  }

}
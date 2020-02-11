import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinestore/data/product_data.dart';
import 'package:onlinestore/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data["title"]),
              centerTitle: true,
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.grid_on)),
                  Tab(icon: Icon(Icons.list))
                ],
              ),
            ),
            body: FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection("products")
                    .document(snapshot.documentID)
                    .collection("items")
                    .getDocuments(),
                builder: (context, documentSnapshot) {
                  if (!documentSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        GridView.builder(
                            padding: EdgeInsets.all(4.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 4.0,
                                    crossAxisSpacing: 4.0,
                                    childAspectRatio: 0.65),
                            itemCount: documentSnapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              ProductData pData = ProductData.fromDocument(
                                  documentSnapshot.data.documents[index]);
                              pData.category = this.snapshot.documentID;

                              return ProductTile("grid", pData);
                            }),
                        ListView.builder(
                            padding: EdgeInsets.all(4.0),
                            itemCount: documentSnapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              ProductData pData = ProductData.fromDocument(
                                  documentSnapshot.data.documents[index]);
                              pData.category = this.snapshot.documentID;

                              return ProductTile("list", pData);
                            })
                      ],
                    );
                  }
                })));
  }
}

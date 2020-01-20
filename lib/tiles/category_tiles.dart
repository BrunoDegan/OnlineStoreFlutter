import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinestore/screens/category_screen.dart';

class CategoryTiles extends StatelessWidget {
  final DocumentSnapshot snapshot;
  final String icon = "icon";
  final String title = "title";

  CategoryTiles(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(snapshot.data[icon]),
        ),
        title: Text(snapshot.data[title]),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CategoryScreen(snapshot)));
        });
  }
}

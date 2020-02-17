import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacesTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  PlacesTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 100.0,
                child: Image(
                    fit: BoxFit.cover,
                    image: CacheImage(snapshot.data["image"]))),
            Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      snapshot.data["title"],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                    Text(
                      snapshot.data["address"],
                      textAlign: TextAlign.start,
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("Ver no mapa"),
                  textColor: Colors.blue,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    launch(
                        "http://www.google.com/maps/search/?api=1&query=${snapshot.data["latitude"]}, ${snapshot.data["longitude"]}");
                  },
                ),
                FlatButton(
                  child: Text("Ligar"),
                  textColor: Colors.blue,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    launch("tel: ${snapshot.data["phone"]}");
                  },
                ),
              ],
            )
          ],
        ));
  }
}

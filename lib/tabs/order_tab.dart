import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:onlinestore/models/user_model.dart';
import 'package:onlinestore/screens/login_screen.dart';
import 'package:onlinestore/tiles/order_tile.dart';

class OrderTabs extends StatelessWidget {
  BuildContext appContext;

  Future<bool> onWillPop() async {
    return (await showDialog(
          context: appContext,
          builder: (context) => new AlertDialog(
            title: new Text('Você tem certeza?'),
            content: new Text('Deseja sair do app'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;
      return new WillPopScope(
          child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("users")
                  .document(uid)
                  .collection("orders")
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView(
                      children: snapshot.data.documents
                          .map((doc) => OrderTile(doc.documentID))
                          .toList()
                          .reversed
                          .toList());
                }
              }),
          onWillPop: onWillPop);
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list,
                size: 80.0, color: Theme.of(context).primaryColor),
            SizedBox(height: 16.0),
            Text("Faça o login para acompanhar seu pedido!",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center),
            SizedBox(height: 16.0),
            RaisedButton(
                child: Text(
                  "Entrar",
                  style: TextStyle(fontSize: 18.0),
                ),
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                })
          ],
        ),
      );
    }
  }
}

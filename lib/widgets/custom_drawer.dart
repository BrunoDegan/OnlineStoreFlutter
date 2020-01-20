import 'package:flutter/material.dart';
import 'package:onlinestore/screens/login_screen.dart';
import 'package:onlinestore/screens/signup_screen.dart';
import 'package:onlinestore/tiles/drawer_tiles.dart';

class CustomDrawer extends StatelessWidget {
  final PageController _pageController;

  CustomDrawer(this._pageController);

  @override
  Widget build(BuildContext context) {

      Widget buildDrawerBackground() {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 203, 236, 241),
                Colors.white,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        );
      }

      return Drawer(
          child: Stack(
            children: <Widget>[
              buildDrawerBackground(),
              ListView(
                  padding: EdgeInsets.only(left: 32.0, top: 16.0),
                  children: <Widget> [
                    Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                      height: 170.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 8.0,
                            left: 0.0,
                            child: Text("Flutter's\nClothing",
                                style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold)),
                          ),

                          Positioned(
                            left: 0.0,
                            bottom: 0.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Olá,",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),

                                GestureDetector(
                                  child: Text(
                                    "Entre ou cadastre-se",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16.0
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder:(context) => LoginScreen())
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    DrawerTiles(Icons.home, "Inicio", _pageController, 1),
                    DrawerTiles(Icons.list, "Produtos", _pageController, 2),
                    DrawerTiles(Icons.location_on, "Lojas", _pageController, 3),
                    DrawerTiles(Icons.playlist_add_check, "Meus pedidos", _pageController, 4),
                  ]
              )
            ],
          ));
        }
      }
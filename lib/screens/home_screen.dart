import 'package:flutter/material.dart';
import 'package:onlinestore/tabs/home_tab.dart';
import 'package:onlinestore/tabs/products_tab.dart';
import 'package:onlinestore/widgets/cart_button.dart';
import 'package:onlinestore/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Categorias"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTabs(),
          floatingActionButton: CartButton() ,
        ),
      ],
      controller: _pageController,

    );
  }
}

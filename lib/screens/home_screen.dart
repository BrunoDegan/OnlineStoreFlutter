import 'package:flutter/material.dart';
import 'package:onlinestore/tabs/home_tab.dart';
import 'package:onlinestore/tabs/order_tab.dart';
import 'package:onlinestore/tabs/places_tab.dart';
import 'package:onlinestore/tabs/products_tab.dart';
import 'package:onlinestore/widgets/cart_button.dart';
import 'package:onlinestore/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          body: ProductsTabs(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus pedidos"),
            centerTitle: true,
          ),
          body: OrderTabs(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}

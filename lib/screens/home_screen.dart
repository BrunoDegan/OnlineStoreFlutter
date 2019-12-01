import 'package:flutter/material.dart';
import 'package:onlinestore/tabs/home_tab.dart';
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
        ),
      ],
      controller: _pageController,

    );
  }
}

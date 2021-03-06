import "package:flutter/material.dart";

class DrawerTiles extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController _pageController;
  final int page;

  DrawerTiles(this.icon, this.text, this._pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            _pageController.jumpToPage(page);
          },
          child: Container(
            height: 60.0,
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  size: 32.0,
                  color: getColor(context),
                ),
                SizedBox(width: 32.0),
                Text(
                  text,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ],
            ),
          )),
    );
  }

  Color getColor(context) {
    var color = Colors.grey[700];

    if (_pageController.page.round() == this.page)
      color = Theme.of(context).primaryColor;

    return color;
  }
}

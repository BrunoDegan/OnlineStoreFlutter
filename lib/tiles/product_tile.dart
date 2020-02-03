import 'package:cache_image/cache_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlinestore/data/product_data.dart';
import 'package:onlinestore/screens/product_description_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProductScreen(product)));
        },
        child: Card(
          child: type == 'grid'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                      AspectRatio(
                          aspectRatio: 0.8,
                          child:
                              Image(image: CacheImage(product.imagesUrl[0]))),
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    product.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                      "R\$ ${product.price.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold))
                                ],
                              )))
                    ])
              : Row(
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: Image(
                          image: CacheImage(product.imagesUrl[0]),
                          height: 250.0,
                        )),
                    Flexible(
                        flex: 1,
                        child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  product.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text("R\$ ${product.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold))
                              ],
                            )))
                  ],
                ),
        ));
  }
}

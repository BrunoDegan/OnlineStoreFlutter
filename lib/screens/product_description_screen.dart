import 'package:cache_image/cache_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onlinestore/data/cart_product.dart';
import 'package:onlinestore/data/product_data.dart';
import 'package:onlinestore/models/cart_model.dart';
import 'package:onlinestore/models/user_model.dart';
import 'package:onlinestore/screens/cart_screen.dart';
import 'package:onlinestore/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  State<StatefulWidget> createState() => ProductScreenState(product);
}

class ProductScreenState extends State<ProductScreen> {
  final ProductData product;

  String sizeSelected;

  ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.9,
              child: Carousel(
                images: product.imagesUrl.map((url) {
                  return Image(image: CacheImage(url));
                }).toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
                animationCurve: Curves.bounceIn,
                showIndicator: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                  ),
                  Text("R\$ ${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor)),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text("Tamanho",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 34.0,
                    child: GridView(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.5,
                        ),
                        children: product.sizes.map((size) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                sizeSelected = size;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  border: Border.all(
                                      color: sizeSelected == size
                                          ? primaryColor
                                          : Colors.grey[500],
                                      width: 3.0)),
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Text(size),
                            ),
                          );
                        }).toList()),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      onPressed: sizeSelected != null
                          ? () {
                              if (UserModel.of(context).isLoggedIn()) {

                                CartProduct cartProduct = CartProduct();
                                cartProduct.size = sizeSelected;
                                cartProduct.qtd = 1;
                                cartProduct.productId = product.id;
                                cartProduct.category = product.category;

                                CartModel.of(context).addCartItem(cartProduct);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CartScreen()));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              }
                            }
                          : null,
                      color: primaryColor,
                      textColor: Colors.white,
                      child: Text("Adicionar ao carrinho",
                          style: TextStyle(fontSize: 18.0)),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Descrição",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  Text(product.description)
                ],
              ),
            )
          ],
        ));
  }
}

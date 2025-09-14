import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/model/model%20product.dart';
import 'package:doctor/pages/product_details/ProductDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class WidgetProdect extends StatefulWidget {
  int index;
  List<Product> Shop_by_CategoriesAllProdect = [];

  WidgetProdect({
    super.key,
    required this.index,
    required this.Shop_by_CategoriesAllProdect,
  });
  @override
  State<WidgetProdect> createState() =>
      _WidgetProdect(Shop_by_CategoriesAllProdect);
}

String? PriceString;
String? PriceStringEq;

class _WidgetProdect extends State<WidgetProdect> {
  @override
  void initState() {
    super.initState();
  }

  List<Product> Shop_by_CategoriesAllProdect = [];
  _WidgetProdect(this.Shop_by_CategoriesAllProdect);
  String? createThePrice(double Price) {
    PriceString = Price.toInt().toString(); //4500,000
    PriceStringEq = PriceString;
    int one = 3;
    for (int i = 0; i < PriceStringEq!.length; i++) {
      if (i % one == 0 && i != 0) {
        PriceStringEq =
            "${PriceStringEq!.substring(0, PriceStringEq!.length - i)},${PriceStringEq!.substring(PriceStringEq!.length - i, PriceStringEq?.length)}";
        one += 4;
      }
    }
    return PriceStringEq;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetailsPage(
                  shop_by_categoriesAllProdect:
                      Shop_by_CategoriesAllProdect[widget.index],
                ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),

        decoration: BoxDecoration(
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            SizedBox(height: 5),

            GestureDetector(
              onTap: () {
                if (!Shop_by_CategoriesAllProdect[widget.index].isFavorite!) {
                  FirebaseFirestore.instance
                      .collection(
                        "${Shop_by_CategoriesAllProdect[widget.index].mainCategory}",
                      )
                      .doc('${Shop_by_CategoriesAllProdect[widget.index].name}')
                      .set({"isFavorite": true}, SetOptions(merge: true));
                  Shop_by_CategoriesAllProdect[widget.index].isFavorite = true;
                  FirebaseFirestore.instance
                      .collection("user")
                      .doc('${FirebaseAuth.instance.currentUser!.email}')
                      .collection(
                        "${Shop_by_CategoriesAllProdect[widget.index].mainCategory}",
                      )
                      .doc('${Shop_by_CategoriesAllProdect[widget.index].name}')
                      .set(
                        Shop_by_CategoriesAllProdect[widget.index].toMap(),
                        SetOptions(merge: true),
                      );
                } else {
                  FirebaseFirestore.instance
                      .collection(
                        "${Shop_by_CategoriesAllProdect[widget.index].mainCategory}",
                      )
                      .doc('${Shop_by_CategoriesAllProdect[widget.index].name}')
                      .set({"isFavorite": false}, SetOptions(merge: true));
                  Shop_by_CategoriesAllProdect[widget.index].isFavorite = false;
                  FirebaseFirestore.instance
                      .collection("user")
                      .doc('${FirebaseAuth.instance.currentUser!.email}')
                      .collection(
                        "${Shop_by_CategoriesAllProdect[widget.index].mainCategory}",
                      )
                      .doc('${Shop_by_CategoriesAllProdect[widget.index].name}')
                      .delete();
                }

                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (Shop_by_CategoriesAllProdect[widget.index].offer != null)
                    Container(
                      height: 20,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${Shop_by_CategoriesAllProdect[widget.index].offer!}% OFF",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    )
                  else
                    SizedBox(width: 80),
                  SizedBox(width: 40),
                  Icon(
                    Shop_by_CategoriesAllProdect[widget.index].isFavorite!
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        Shop_by_CategoriesAllProdect[widget.index].isFavorite!
                            ? Colors.red
                            : Colors.grey,
                    size: 22,
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              height: 110,
              width: 120,
              color: Color(0xFFF8F8F8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  Shop_by_CategoriesAllProdect[widget.index].Image[0],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            Text(
              Shop_by_CategoriesAllProdect[widget.index].name,

              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Shop_by_CategoriesAllProdect[widget.index].offer != null
                      ? "EGP ${createThePrice(Shop_by_CategoriesAllProdect[widget.index].price * (100 - Shop_by_CategoriesAllProdect[widget.index].offer!) / 100)}"
                      : "EGP ${createThePrice(Shop_by_CategoriesAllProdect[widget.index].price)}",

                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),

                if (Shop_by_CategoriesAllProdect[widget.index].offer != null)
                  Text(
                    "EGP ${createThePrice(Shop_by_CategoriesAllProdect[widget.index].price)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:doctor/model/model%20product.dart';
import 'package:doctor/pages/product_details/ProductDetails.dart';
import 'package:doctor/pages/addProduct/addProduct.dart';
import 'package:doctor/widgets/widget_prodect.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/model/modelorder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Wishlistprofile extends StatelessWidget {
  Wishlistprofile({super.key});

  final List<String> Shop_by_Categories = [
    'Hoodies',

    'Shorts',
    'Shoes',
    'Bags',

    'Accessories',
  ];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<Product>> fetchProducts(String name) async {
    try {
      QuerySnapshot snapshot =
          await firestore
              .collection("user")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection(name)
              .get();
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          SizedBox(height: 40),

          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Iconsax.arrow_left_2,
                      size: 30,
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                Text(
                  "Wishlist",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Shop_by_Categories.length,
              itemBuilder: (context, index) {
                final categoryName = Shop_by_Categories[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),

                    FutureBuilder<List<Product>>(
                      future: fetchProducts(categoryName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError || snapshot.data!.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "No products available in this category",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        final products = snapshot.data!;
                        final screenWidth = MediaQuery.of(context).size.width;
                        final padding = 16 * 2; // Padding أيسر + أيمن
                        final crossAxisSpacing = 12;
                        final itemWidth =
                            (screenWidth - crossAxisSpacing - padding) / 2;
                        final itemHeight = itemWidth * 1.2; // ارتفاع نسبي للعرض

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: itemWidth / itemHeight,
                              ),
                          itemBuilder: (context, prodIndex) {
                            return isfav(
                              prodIndex: prodIndex,
                              products: products,
                            );
                          },
                        );
                      },
                    ),

                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 2,
                      height: 32,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class isfav extends StatelessWidget {
  int prodIndex;
  List<Product> products;
  isfav({super.key, required this.products, required this.prodIndex});
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
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (products[prodIndex].offer != null)
                Container(
                  height: 20,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "${products[prodIndex].offer!}% OFF",
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
                products[prodIndex].isFavorite!
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    products[prodIndex].isFavorite! ? Colors.red : Colors.grey,
                size: 22,
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 5),
          // الصورة
          Container(
            height: 110,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                products[prodIndex].Image[0],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
              ),
            ),
          ),
          SizedBox(height: 5),
          // الاسم
          Text(
            products[prodIndex].name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(height: 5),
          // السعر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                products[prodIndex].offer != null
                    ? "EGP ${createThePrice(products[prodIndex].price * (100 - products[prodIndex].offer!) / 100)}"
                    : "EGP ${createThePrice(products[prodIndex].price)}",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
              if (products[prodIndex].offer != null)
                Text(
                  "EGP ${createThePrice(products[prodIndex].price)}",
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
    );
  }
}
